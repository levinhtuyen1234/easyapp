<build role="tabpanel" class="tab-pane" id="build">
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
    </div>
    <pre>
        <code class="accesslog hljs"></code>
    </pre>
    <script>
        var ChildProcess = require('child_process');
        var Path = require('path');

        var me = this;
        var output = '';
        var watchProcess;

        var nodePath = Path.join(opts.dir, '..', '..', 'sites_node_modules');
        var PATH = [
            Path.join(opts.dir, 'node_modules', '.bin', Path.sep),
            Path.join(opts.dir, '..', '..', 'tools', 'nodejs', Path.sep),
            Path.join(opts.dir, '..', '..', 'tools', 'git', 'bin', Path.sep)
        ].join(';');

        function spawnProcess(command, args) {
            args = args || [];
            var newProcess = ChildProcess.spawn(command, args, {
                env:   {
                    'NODE_PATH': nodePath,
                    'PATH':      PATH
                },
                cwd:   opts.dir,
                shell: true
            });

            newProcess.stdout.on('data', function (data) {
                me.append(data);
            });

            newProcess.stderr.on('data', function (data) {
                me.appendError(data);
            });

            return newProcess;
        }

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

        me.clear = function () {
            me.output.innerHTML = '';
        };

        var body = document.querySelector('body');
        function scrollToBottom() {
            body.scrollTop = body.scrollHeight;
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
    </script>
</build>
