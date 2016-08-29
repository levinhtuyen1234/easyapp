<watch-view>
    <div class="tab-content">
        <webview id="webview" src="about:blank" style="display:flex; height: calc(50vh - 30px);"></webview>
        <div id="consoleLog" style="height:100px;">
            <p style="margin: 0;">ConsoleLog of Build Process</p>
            <pre style="max-height:100px; overflow: auto;">
                <code class="accesslog hljs"></code>
            </pre>
        </div>
    </div>
    <script>
        var ChildProcess = require('child_process');
        var Path = require('path');
        var Fs = require('fs');

        var resizerScript = Fs.readFileSync('assets/js/resizer.min.js').toString();

        var me = this;
        var output = '';
        var watchProcess;
        var watchProcessPids = [];

        var lastWatchMode = '';

        me.iframeUrl = me.opts.iframeUrl ? me.opts.iframeUrl : 'about:blank';

        var nodePath = Path.resolve(Path.join('tools', 'nodejs', 'node_modules'));
        var PATH = [
            Path.resolve(Path.join('tools', 'nodejs', 'node_modules', '.bin')),
            Path.resolve(Path.join('tools', 'nodejs')),
            Path.resolve(Path.join('tools', 'git', 'bin'))
        ].join(';');

        function spawnProcess(command, args) {
            args = args || [];
            var newProcess = ChildProcess.spawn(command, args, {
                env:   {
                    'NODE_PATH': nodePath,
                    'PATH':      PATH
                },
                cwd:   Path.resolve(Path.join('sites', opts.siteName)),
                shell: true
            });
//            watchProcessPids.push(newProcess.pid);

            var dataBuf = [];
            var logTimer;
            newProcess.stdout.on('data', function (data) {
                dataBuf.push(String.fromCharCode.apply(null, data));
                clearTimeout(logTimer);

                logTimer = setTimeout(function(){
                    // find browserSync port in stdout
                    var str = dataBuf.join('<br>');
                    console.log(str);
                    if (str.indexOf('[Error:') != -1) {
                        console.log('APPEND ERROR');
                        me.appendError(str);
                        riot.api.trigger('watchFailed', str);
                        $(me.consoleLog).show();
                    } else {
                        var reviewUrl = (/Local: (http:\/\/.+)/gm).exec(str);

                        if (reviewUrl != null) {
                            console.log('APPEND TEXT 1');
                            console.log('found review url', reviewUrl[1]);
                            riot.api.trigger('watchSuccess', reviewUrl[1]);
                            me.webview.src = reviewUrl[1];
                            me.webview.executeJavaScript(resizerScript, false);
//                    if (!me.webview.isDevToolsOpened())
//                        me.webview.openDevTools();
                            me.update();
                        }
                        console.log('APPEND TEXT 2');
                        me.append(str);
                        $(me.consoleLog).hide();
                    }
                    dataBuf = [];
                }, 500);
            });

            newProcess.stderr.on('data', function (data) {
                var str = String.fromCharCode.apply(null, data);
                me.appendError(str);
                riot.api.trigger('watchFailed', str);
                $(me.consoleLog).show();
//                me.closeWatchProcess();
            });

            return newProcess;
        }

        function scrollToBottom() {
            me.output.parentNode.scrollTop = me.output.parentNode.scrollHeight
        }

        function closeProcess(proc) {
            proc.stdin.pause();

            if (process.platform === 'linux') {
                process.kill('SIGKILL');
            } else if (process.platform === 'win32') {
                ChildProcess.execSync('taskkill /pid ' + proc.pid + ' /F /T');
            }
            me.append('close exists watch process');
        }
        //        me.npmInstall = function () {
        //            console.log('npmInstall');
        //            console.log('npm cli', Path.resolve(Path.join(opts.siteName, '..', 'tools', 'nodejs', 'node_modules', 'npm', 'bin', 'npm-cli.js')));
        //            spawnProcess('node.exe', [Path.resolve(Path.join(opts.siteName, '..', 'tools', 'nodejs', 'node_modules', 'npm', 'bin', 'npm-cli.js')), 'install']);
        //        };

        // close watch process truoc khi app exit
        window.onbeforeunload = function (e) {
            me.closeWatchProcess();
        };

        riot.api.on('refreshWatch', function () {
            me.append('refresh watch');
            me.closeWatchProcess();
            me.clear();
            if (lastWatchMode == 'user')
                me.watch();
            else if (lastWatchMode == 'dev')
                me.watchDev();
        });

        me.closeWatchProcess = function () {
            try {
                if (!watchProcess)
                    return;
                closeProcess(watchProcess);
                watchProcess = null;
            } catch (ex) {
                console.log('close watch error', ex);
                watchProcess = null;
            }
        };

        me.watch = function () {
            if (watchProcess != null) return;
            me.clearLog();
            me.closeWatchProcess();

            me.append('build starting...\r\n');
            lastWatchMode = 'user';
            watchProcess = spawnProcess('gulp.cmd', ['--continue', 'app-watch']);
        };

        me.watchDev = function () {
            if (watchProcess != null) return;
            me.clearLog();
            me.closeWatchProcess();
            console.log('WATCH DEV NEED gulpfile.dev.js');

            me.append('build dev starting...\r\n');
            lastWatchMode = 'dev';
            watchProcess = spawnProcess('gulp.cmd', ['--continue', '--gulpfile', 'gulpfile.dev.js', 'app-watch']);
        };

        // TODO on unmount close watch process

//        me.buildDev = function () {
//            me.clearLog();
//            me.closeWatchProcess();
//            spawnProcess('gulp.cmd', ['build']);
//        };
//
//        me.buildProd = function () {
//            me.clearLog();
//            me.closeWatchProcess();
//            spawnProcess('gulp.cmd', ['build', '--production']);
//        };

        me.on('mount', function () {
            me.output = me.root.querySelector('code');
            me.output.innerHTML = '';
        });

        me.clearLog = function () {
            me.output.innerHTML = '';
        };

        me.append = function (text) {
            var span = document.createElement('span');
            span.innerHTML = text;
            me.output.appendChild(span);
            scrollToBottom();
        };

        me.clear = function () {
            me.output.innerHTML = '';
        };

        me.openExternalBrowser = function () {
            console.log('openExternalBrowser', me.webview.src);
            if (me.webview.src != 'about:blank') {
                const {shell} = require('electron');
                shell.openExternal(me.webview.src);
            }
        };

        me.appendError = function (text) {
            var span = document.createElement('span');
            span.innerHTML = text;
            span.style.color = 'red';
            me.output.appendChild(span);
            scrollToBottom();
        };
    </script>
</watch-view>
