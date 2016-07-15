<watch-view>
    <div class="btn-group" data-toggle="buttons">
        <label class="btn btn-default btn-sm" onclick="{watch}">
            <input type="radio" name="options"/>Watch
        </label>
        <label class="btn btn-default btn-sm" onclick="{buildDev}">
            <input type="radio" name="options"/>Build (dev)
        </label>
        <label class="btn btn-default btn-sm" onclick="{buildProd}">
            <input type="radio" name="options"/>Build (prod)
        </label>
        <!--<label class="btn btn-default" onclick="{npmInstall}">-->
            <!--<input type="radio" name="options"/>Npm install-->
        <!--</label>-->

        <label class="btn btn-default btn-sm" onclick="{openExternalBrowser}">
            <a>Open In Browser</a>
        </label>
    </div>

    <pre style="height: 70vh; overflow: auto;">
        <code class="accesslog hljs"></code>
    </pre>
    <script>
        var ChildProcess = require('child_process');
        var Path = require('path');

        var me = this;
        var output = '';
        var watchProcess;

        me.iframeUrl = me.opts.iframeUrl ? me.opts.iframeUrl : 'about:blank';

        var nodePath = Path.resolve(Path.join('tools', 'nodejs', 'node_modules'));
        console.log('watch-view nodePath', nodePath);
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
                    me.iframeUrl = reviewUrl[1];
                    me.update();
                }
                me.append(str);
            });

            newProcess.stderr.on('data', function (data) {
                console.log(data);
                me.appendError(data);
            });

            return newProcess;
        }

        me.npmInstall = function () {
            console.log('npmInstall');
            console.log('npm cli', Path.resolve(Path.join(opts.site_name, '..', 'tools', 'nodejs', 'node_modules', 'npm', 'bin', 'npm-cli.js')));
            spawnProcess('node.exe', [Path.resolve(Path.join(opts.site_name, '..', 'tools', 'nodejs', 'node_modules', 'npm', 'bin', 'npm-cli.js')), 'install']);
        };

        function closeProcess(proc) {
            proc.stdin.pause();

            if (process.platform === 'linux') {
                process.kill('SIGKILL');
            } else if (process.platform === 'win32') {
                ChildProcess.execSync('taskkill /pid ' + proc.pid + ' /F /T');
            }
            me.append('close exists process\r\n');
        }

        function closeWatchProcess() {
            if (!watchProcess)
                return;
            closeProcess(watchProcess);
            watchProcess = null;
        }

        me.watch = function () {
            me.clearLog();
            closeWatchProcess();
            watchProcess = spawnProcess('gulp.cmd', ['app-watch']);
        };

        me.buildDev = function () {
            me.clearLog();
            closeWatchProcess();
            spawnProcess('gulp.cmd', ['build']);
        };

        me.buildProd = function () {
            me.clearLog();
            closeWatchProcess();
            spawnProcess('gulp.cmd', ['build', '--production']);
        };

        // close watch process truoc khi app exit
        window.onbeforeunload = function (e) {
            closeWatchProcess();
        };

        me.on('mount', function () {
            me.output = me.root.querySelector('code');
            me.output.innerHTML = '';
        });

        me.clearLog = function () {
            me.output.innerHTML = '';
        };

        function scrollToBottom() {
            me.output.parentNode.scrollTop = me.output.parentNode.scrollHeight
        }

        me.append = function (text) {
            var span = document.createElement('span');
            span.innerHTML = text;
            me.output.appendChild(span);
            scrollToBottom();
        };

        me.openExternalBrowser = function () {
            if (me.iframeUrl != 'about:blank') {
                const {shell} = require('electron');
                shell.openExternal(me.iframeUrl);
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
