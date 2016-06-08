<home>
    <nav></nav>
    <div class="container-fluid" style="padding-top: 60px;">
        <div class="tab-content">
            <content></content>
            <setting></setting>
            <browse dir={opts.sitePath}></browse>
            <review></review>
        </div>
    </div>

    <script>
        var ChildProcess = require("child_process");
        var script_process = ChildProcess.spawn(opts.sitePath, [], {
            env: process.env,
            cwd: opts.sitePath
        });

        script_process.stdout.on('data', function (data) {
            console.log('stdout: ' + data);
        });

        var sitePath = opts.sitePath;
        riot.mount($('#browseTab'), opts);
    </script>
</home>
