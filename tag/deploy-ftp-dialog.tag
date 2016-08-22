<deploy-ftp-dialog>
    <div name="ftpDeployForm" class="container-fluid" style="display: none">
        <form class="form-horizontal">
            <div class="form-group">
                <label for="inputHost" class="col-sm-3 control-label">Ftp host</label>
                <div class="col-sm-9">
                    <input type="text" class="form-control" id="inputHost" placeholder="" onkeyup="{edit.bind(this, 'host')}">
                </div>
            </div>

            <div class="form-group">
                <label for="inputPort" class="col-sm-3 control-label">Port</label>
                <div class="col-sm-9">
                    <input type="number" class="form-control" id="inputPort" placeholder="" onkeyup="{edit.bind(this, 'port')}">
                </div>
            </div>

            <div class="form-group">
                <label for="inputRemotePath" class="col-sm-3 control-label">Remote path</label>
                <div class="col-sm-9">
                    <input type="text" class="form-control" id="inputRemotePath" placeholder="" onkeyup="{edit.bind(this, 'remotePath')}">
                </div>
            </div>

            <div class="form-group">
                <label for="inputUsername" class="col-sm-3 control-label">Username</label>
                <div class="col-sm-9">
                    <input type="text" class="form-control" id="inputUsername" placeholder="" onkeyup="{edit.bind(this, 'username')}">
                </div>
            </div>

            <div class="form-group">
                <label for="inputPassword" class="col-sm-3 control-label">Password</label>
                <div class="col-sm-9">
                    <input type="password" class="form-control" id="inputPassword" placeholder="" onkeyup="{edit.bind(this, 'password')}">
                </div>
            </div>

            <pre style="height: 100px; max-height:100px; overflow: auto;">
                <code name="uploadLog" class="accesslog hljs"></code>
            </pre>

            <div class="progress" style="margin-top: 7px;">
                <div name="progressBar" class="progress-bar progress-bar-success" role="progressbar" aria-valuemin="0" aria-valuemax="100" style="background-color: #5cb85c;"></div>
            </div>

            <div class="form-group">
                <div class="col-sm-offset-5 col-sm-2">
                    <button type="button" class="btn btn-default" name="processBtn" onclick="{process}">Upload</button>
                </div>
            </div>
        </form>
    </div>

    <script>
        var fs = require('fs');
        var path = require('path');
        var jsftp = require('jsftp');
        var bluebird = require('bluebird');

        var me = this;
        me.mixin('form');
        var dialog;
        var uploading = false;

        me.host = '127.0.0.1';
        me.post = 21;
        me.remotePath = '/subdir';
        me.username = '';
        me.password = '';
        me.isStop = false;

        function reset() {
            uploading = false;
            setProgress(0);
            clearLog();
            $(me.processBtn).text('Upload');
        }

        var ignoreName = ['.git'];
        var getFileAndDirList = function (root, dir, fileList, dirList) {
            try {
                for (var name of fs.readdirSync(dir)) {
//                    if (ignoreName.indexOf(name) != -1) continue;

                    var fullPath = path.join(dir, name);
//                    console.log('fullPath', fullPath, 'relPath', path.relative(root, fullPath));
                    var stat = fs.statSync(fullPath);

                    if (stat.isDirectory()) {
                        dirList.push({name: name, path: path.relative(root, fullPath).replace(/\\/g, '/')});
                        getFileAndDirList(root, fullPath, fileList, dirList);
                    } else if (stat.isFile()) {
                        fileList.push({name: name, path: path.relative(root, fullPath).replace(/\\/g, '/')});
                    }
                }
            } catch (e) {
                console.log('getFileAndDirList failed', e);
            }
        };

        function createRemoteDirs(ftp, root, dirList) {
            return bluebird.map(dirList, function (item) {
                return new bluebird(function (resolve, reject) {
                    var fullPath = path.join(root, item.path);
                    ftp.raw.mkd(fullPath, function (err, data) {
                        if (err && err.code != 550) {
                            reject(err);
                        }
                        else resolve(data);
                    });
                });
            });
        }

        function uploadFiles(ftp, root, filePathList) {
//            console.log('uploadFiles', root, filePathList);
            ftp.setDebugMode(true);
            var totalFiles = filePathList.length;
            var uploaded = 0;
            return new bluebird(function (resolve, reject) {
                var doUpload = function () {
                    if (me.isStop) {
                        console.log('isStop true, stop');
                        resolve();
                        return;
                    }

                    var item = filePathList.shift();
//                    console.log('doUpload item', item);
                    if (item == null) {
                        resolve();
                        return;
                    }
                    var fullRemotePath = path.join(root, item.path).replace(/\\/g, '/');
                    var fullLocalPath = path.resolve(path.join('sites', me.opts.siteName, 'build', item.path));
                    appendLog(`upload file ${item.path}`);
                    ftp.put(fullLocalPath, fullRemotePath, function (err, data) {
                        if (err) {
                            reject(err);
                            return;
                        }
                        uploaded = uploaded + 1;
                        setProgress(Math.floor(uploaded / totalFiles * 100));
                    });
                };

                ftp.on('jsftp_debug', function (eventType, data) {

                    if (data.code == 226) {
                        doUpload();
                    }
                });

                doUpload();
            });
        }

        function setProgress(i) {
            me.progressBar.style.width = i + '%';
        }

        function scrollLogToBottom() {
            me.uploadLog.parentNode.scrollTop = me.uploadLog.parentNode.scrollHeight
        }

        function appendLog(text) {
            var span = document.createElement('span');
            span.innerHTML = text;
            me.uploadLog.appendChild(span);
            me.uploadLog.appendChild(document.createElement('br'));
            scrollLogToBottom();
        }

        function clearLog() {
            me.uploadLog.innerHTML = '';
        }

        function loginFtp() {
            return new bluebird(function (resolve, reject) {
                var ftp = new jsftp({
                    host: me.host,
                    port: me.port,
                    user: me.username,
                    pass: me.password
                });

                ftp.auth(me.username, me.password, function (error, ret) {
                    console.log('LOGIN', error, ret);
                    if (error) reject(error);
                    else resolve(ftp, ret);
                });
            });
        }

        me.on('mount', function () {
//            console.log('ftpDeployForm', me.ftpDeployForm);
        });

        me.on('unmount', function () {

        });

        me.stopUpload = function () {
            me.isStop = true;
        };

        me.startUpload = function () {
            appendLog('start uploading...');
            $(me.processBtn).addClass('disabled');
            $(me.processBtn).attr('disabled', true);
            loginFtp().then(function (ftp, ret) {
                // collect all file
                var dirList = [], fileList = [];
                getFileAndDirList(path.join('sites', me.opts.siteName, 'build'), path.join('sites', me.opts.siteName, 'build'), fileList, dirList);

                // sort dir list
                dirList.sort(function (a, b) {
                    var val1 = a.path;
                    var val2 = b.path;
                    if (val1 == val2)
                        return 0;
                    if (val1 > val2)
                        return 1;
                    if (val1 < val2)
                        return -1;
                });

//            console.log('DIR LIST', dirList);

                // create directory tree on remote
                return createRemoteDirs(ftp, me.remotePath, dirList).then(function () {
                    // copy file
                    return uploadFiles(ftp, me.remotePath, fileList).then(function () {
                        appendLog('all file uploaded');
                    });
                });
            }).catch(function (ex) {
                appendLog('upload failed, error: ' + ex.message);
                console.log('create remote directory failed', ex);
            });
        };

        me.process = function () {
            console.log('process');
            var btn = $(me.processBtn);
            if (uploading) {
                btn.text('Upload');
//                btn.removeClass('btn-default');
//                btn.addClass('btn-warning');
                me.stopUpload();
            } else {
//                btn.text('Pause');
//                btn.addClass('btn-default');
//                btn.removeClass('btn-warning');
                me.startUpload();
            }
            uploading = !uploading;
        };

        me.show = function () {
            if (!dialog) {
                dialog = $.jsPanel({
                    headerTitle:    'FTP Deployment',
                    headerControls: {
                        iconfont: 'font-awesome',
                        maximize: 'remove',
                        smallify: 'remove'
                    },
                    position:       {
                        my: 'center',
                        at: 'center'
                    },
                    contentSize:    {width: 500, height: 450},
                    content:        $(me.ftpDeployForm).show(),
                    onclosed:       function () {
                        me.stopUpload();
                        reset();
                        dialog = null;
                        console.log('dialog closed');
                    }
                });
            } else {
                dialog.show();
            }
        };

        me.hide = function () {
            if (dialog)
                dialog.minimize();
        };

    </script>
</deploy-ftp-dialog>
