<watch-view>
    <div class="btn-group" data-toggle="buttons">
        <label class="btn btn-default" onclick="{watch}">
            <input type="radio" name="options"/>Watch
        </label>
        <label class="btn btn-default" onclick="{buildDev}">
            <input type="radio" name="options"/>Build (dev)
        </label>
        <label class="btn btn-default" onclick="{buildProd}">
            <input type="radio" name="options"/>Build (prod)
        </label>
        <label class="btn btn-default" onclick="{npmInstall}">
            <input type="radio" name="options"/>Npm install
        </label>
    </div>

    <pre style="height: 250px; overflow: auto;">
        <code class="accesslog hljs">TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST </code>
    </pre>

    <iframe width="100%" height="800px" frameborder="0" src="{iframeUrl}"></iframe>

    <script>
        var ChildProcess = require('child_process');
        var Path = require('path');

        var me = this;
        var output = '';
        var watchProcess;

        me.iframeUrl = me.opts.iframeUrl ? me.opts.iframeUrl : 'https://react.rocks/example/react-serial-forms';

        var nodePath = Path.resolve(Path.join('sites', opts.site_name, 'node_modules'));
        console.log('nodePath', nodePath);
        var PATH = [
            Path.resolve(Path.join('sites', opts.site_name, 'node_modules', '.bin', Path.sep)),
            Path.resolve(Path.join(opts.site_name, '..', 'tools', 'nodejs', Path.sep)),
            Path.resolve(Path.join(opts.site_name, '..', 'tools', 'git', 'bin', Path.sep))
        ].join(';');
        console.log('PATH', PATH);

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
                console.log(data);
                // find browserSync port in stdout
                var str = String.fromCharCode.apply(null, data);
                (/Local: (http:\/\/.+)/gm).exec(str);
                var reviewUrl = str.match(/Local: (http:\/\/.+)/gm);
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
//            '\\node_modules\\npm\\bin\\npm-cli.js'
            console.log('npm cli', Path.resolve(Path.join(opts.site_name, '..', 'tools', 'nodejs', 'node_modules', 'npm', 'bin', 'npm-cli.js')));
            spawnProcess('node.exe', [Path.resolve(Path.join(opts.site_name, '..', 'tools', 'nodejs', 'node_modules', 'npm', 'bin', 'npm-cli.js')), 'install']);
        };

        function closeProcess(proc) {
            proc.stdin.pause();

            if (process.platform === 'linux') {
                process.kill('SIGKILL');
            } else if (process.platform === 'win32') {
                ChildProcess.spawn('taskkill', ['/pid', proc.pid, '/f', '/t']);
            }
            me.append('close exists process\r\n');
        }

        function closeWatchProcess() {
            if (!watchProcess) return;
            closeProcess(watchProcess);
            watchProcess = null;
        }

        me.watch = function () {
            closeWatchProcess();
            watchProcess = spawnProcess('gulp.cmd');
        };

        me.buildDev = function () {
            closeWatchProcess();
            spawnProcess('gulp.cmd', ['build']);
        };

        me.buildProd = function () {
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

        var body = document.querySelector('body');
        function scrollToBottom() {
//            body.scrollTop = body.scrollHeight;
//            me.output.scrollTop = me.output.scrollHeight;
            me.output.parentNode.scrollTop = me.output.parentNode.scrollHeight
        }

        me.append = function (text) {
            var span = document.createElement('span');
            span.innerHTML = text;
            me.output.appendChild(span);
            scrollToBottom();
        };

        me.appendError = function (text) {
            var span = document.createElement('span');
            span.innerHTML = text;
            span.style.color = 'red';
            me.output.appendChild(span);
            scrollToBottom();
        };

        /*
         * reconfig browserSync ui: false
         * */
    </script>
</watch-view>
