<home>
    <nav></nav>
    <div class="container-fluid" style="padding-top: 60px;">
        <div class="tab-content">
            <content dir={opts.sitePath}></content>
            <setting dir={opts.sitePath}></setting>
            <browse dir={opts.sitePath}></browse>
            <review dir={opts.sitePath}></review>
        </div>
    </div>

    <script>
        var ChildProcess = require("child_process");
        var Path = require('path');

        var nodePath = Path.join(opts.sitePath, '..', '..', 'sites_node_modules');
//        var scriptProcess = ChildProcess.spawn(nodePath + '/.bin/gulp.cmd', [], {
        console.log(Path.join(opts.sitePath, '..', '..', 'sites_node_modules', '.bin'));
        var scriptProcess = ChildProcess.spawn(opts.sitePath + '/RUN_LOCAL.bat', [], {
            env:   {
                'NODE_PATH': nodePath,
                'PATH':      Path.join(opts.sitePath, '..', '..', 'tools', 'nodejs') + ';' +
                             Path.join(opts.sitePath, '..', '..', 'sites_node_modules', '.bin')
            },
//            detached: true,
            cwd:   opts.sitePath,
            shell: true,
//            stdio: 'ignore'
        });

        scriptProcess.stdout.on('data', function (data) {
            console.log('stdout: ' + data);
        });
        scriptProcess.stderr.on('data', function (data) {
            console.log('stderr: ' + data);
        });

        var sitePath = opts.sitePath;
        riot.mount($('#browseTab'), opts);
    </script>
</home>
