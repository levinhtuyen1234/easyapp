<bottom-bar>
    <div class="ui attached tabular mini menu">
        <div class="active item" data-tab="webView" style="border-radius: 0 !important;">PC</div>
        <div class=" item" data-tab="webView1" >Tablet</div>
        <div class=" item" data-tab="webView2" >Smartphone</div>
        <div class="item ui button" data-tab="onBrowser" style="border-radius: 0 !important;">Open on Browser</div>
        <div class="right item" data-tab="buildLog" style="border-radius: 0 !important;">Build Log</div>
    </div>
    <div class="ui bottom attached active tab segment" data-tab="webView" style="padding: 0; height: calc(100% - 35px); border-right: none; border-bottom: none;">
        <webview id="webview" src="https://www.google.com.vn" style="display:flex; height: 100%"></webview>
    </div>
    <div class="ui bottom attached tab segment" data-tab="buildLog" style="padding: 0; height: calc(100% - 35px); border-right: none; border-bottom: none;">
        <pre class="accesslog hljs" style="height:100%; overflow: auto; margin: 0;font-family: Consolas, monospace;">
            asdfasd
            fa
            dsf
            as
            fd
            asf
            as
            df
            asd
            fasd
            f
            sda
            df
            sdf
            sad
            fsda
            f
            sadf
            sda
        </pre>
    </div>

    <script>
        var Path = require('path');
        var Fs = require('fs');

        var me = this;
        var tab;

        var resizerScript = Fs.readFileSync(__dirname + '/assets/js/resizer.min.js').toString();
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

        me.on('mount', function () {
            tab = $(me.root.querySelector('.ui.tabular.menu'));
            tab.tab();
        });
        var ChildProcess = require('child_process');

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

                logTimer = setTimeout(function () {
                    // find browserSync port in stdout
                    var str = dataBuf.join('');
//                    console.log(str);
                    if (str.indexOf('[Error:') != -1) {
                        me.appendError(str);
                        riot.event.trigger('watchFailed', str);
//                        $(me.consoleLog).show();
                    } else {
                        var reviewUrl = (/Local: (http:\/\/.+)/gm).exec(str);

                        if (reviewUrl != null) {
                            console.log('found review url', reviewUrl[1]);
                            riot.event.trigger('watchSuccess', reviewUrl[1]);
                            me.webview.src = reviewUrl[1];
                            me.webview.executeJavaScript(resizerScript, false);
//                    if (!me.webview.isDevToolsOpened())
//                        me.webview.openDevTools();
                            me.update();
                        }
                        me.append(str);
//                        $(me.consoleLog).hide();
                    }
                    dataBuf = [];
                }, 500);
            });

            newProcess.stderr.on('data', function (data) {
                var str = String.fromCharCode.apply(null, data);
                me.appendError(str);
                riot.event.trigger('watchFailed', str);
//                $(me.consoleLog).show();
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

        riot.event.on('refreshWatch', function () {
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
            me.output = me.root.querySelector('pre');
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
</bottom-bar>
