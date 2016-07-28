<watch-view>
    <!--<div class="btn-group" data-toggle="buttons">-->
    <!--<label class="btn btn-default btn-sm" onclick="{watch}">-->
    <!--<input type="radio" name="options"/>Watch-->
    <!--</label>-->
    <!--<label class="btn btn-default btn-sm" onclick="{buildDev}">-->
    <!--<input type="radio" name="options"/>Build (dev)-->
    <!--</label>-->
    <!--<label class="btn btn-default btn-sm" onclick="{buildProd}">-->
    <!--<input type="radio" name="options"/>Build (prod)-->
    <!--</label>-->
    <!--&lt;!&ndash;<label class="btn btn-default" onclick="{npmInstall}">&ndash;&gt;-->
    <!--&lt;!&ndash;<input type="radio" name="options"/>Npm install&ndash;&gt;-->
    <!--&lt;!&ndash;</label>&ndash;&gt;-->

    <!--<label class="btn btn-default btn-sm" onclick="{openExternalBrowser}">-->
    <!--<a>Open In Browser</a>-->
    <!--</label>-->
    <!--</div>-->
    <div class="tab-content">
        <pre style="height: 300px; overflow: auto;">
            <code class="accesslog hljs"></code>
        </pre>
        <webview id="webview" src="about:blank" style="display:flex; height:calc(100vh - 500px)"></webview>
    </div>
    <script>
        var ChildProcess = require('child_process');
        var Path = require('path');

        var me = this;
        var output = '';
        var watchProcess;

        me.iframeUrl = me.opts.iframeUrl ? me.opts.iframeUrl : 'about:blank';

        var nodePath = Path.resolve(Path.join('tools', 'nodejs', 'node_modules'));
        var PATH = [
            Path.resolve(Path.join('tools', 'nodejs', 'node_modules', '.bin')),
            Path.resolve(Path.join('tools', 'nodejs')),
            Path.resolve(Path.join('tools', 'git', 'bin'))
        ].join(';');
        console.log('watch-view PATH', PATH);

        function spawnProcess(command, args) {
            args = args || [];
            var newProcess = ChildProcess.spawn(command, args, {
                env:   {
                    'NODE_PATH': nodePath,
                    'PATH':      PATH
                },
                cwd:   Path.resolve(Path.join('sites', opts.site_name)),
                shell: true
            });

            newProcess.stdout.on('data', function (data) {
                // find browserSync port in stdout
                var str = String.fromCharCode.apply(null, data);
                console.log(str);
                var reviewUrl = (/Local: (http:\/\/.+)/gm).exec(str);
                if (reviewUrl != null) {
                    console.log('found review url', reviewUrl[1]);
                    riot.api.trigger('watchSuccess', reviewUrl[1]);
                    me.webview.src = reviewUrl[1];
                    me.update();
                }
                me.append(str);
            });

            newProcess.stderr.on('data', function (data) {
                var str = String.fromCharCode.apply(null, data);
                me.appendError(str);
                riot.api.trigger('watchFailed');
                me.closeWatchProcess();
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
            me.append('close exists process\r\n');
        }
        //        me.npmInstall = function () {
        //            console.log('npmInstall');
        //            console.log('npm cli', Path.resolve(Path.join(opts.site_name, '..', 'tools', 'nodejs', 'node_modules', 'npm', 'bin', 'npm-cli.js')));
        //            spawnProcess('node.exe', [Path.resolve(Path.join(opts.site_name, '..', 'tools', 'nodejs', 'node_modules', 'npm', 'bin', 'npm-cli.js')), 'install']);
        //        };

        // close watch process truoc khi app exit
        window.onbeforeunload = function (e) {
            me.closeWatchProcess();
        };

        riot.api.on('RefreshWatch', function () {
            me.append('refresh watch');
            me.closeWatchProcess();
            me.clear();
            me.watch();
        });

        me.closeWatchProcess = function () {
            try {
                if (!watchProcess)
                    return;
                closeProcess(watchProcess);
                watchProcess = null;
            } catch (ex) {
                console.log('watch error', ex);
                watchProcess = null;
            }
        };

        me.watch = function () {
            if (watchProcess != null) return;
            me.clearLog();
            me.closeWatchProcess();

            me.append('build starting...\r\n');
            watchProcess = spawnProcess('gulp.cmd', ['app-watch']);
        };

        me.watchDev = function () {
            if (watchProcess != null) return;
            me.clearLog();
            me.closeWatchProcess();

            me.append('build dev starting...\r\n');
            watchProcess = spawnProcess('gulp.cmd', ['--gulpfile', 'gulpfile.dev.js', 'app-watch']);
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
            window.webview = me.webview;
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
