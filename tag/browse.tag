<browse role="tabpanel" class="tab-pane active" id="browse">
    <div class="row">
        <div class="col-md-12">
            <ol class="breadcrumb">
                <li each="paths"><a href="#">{name}</a></li>
                <div class="pull-right">
                    <!--<label class="btn btn-default btn-xs btn-file">-->
                    <!--Browse <input type="file" style="display: none;">-->
                    <!--</label>-->
                    <button class="btn btn-primary btn-xs">New <i class="fa fa-plus"></i></button>
                </div>
            </ol>

        </div>
    </div>

    <div class="row">
        <table class="table table-responsive">
            <thead>
            <tr>
                <th>Name</th>
                <th class="hidden-xs">Size</th>
                <th class="hidden-xs text-right">Modified</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            <tr each="{dirEntries}">
                <td>
                    <i class="fa { isDir ? 'fa-folder' : 'fa-file'}"></i> <a class="filename" href="{path}">{name}</a>
                </td>
                <td class="hidden-xs">{size}</td>
                <td class="hidden-xs text-right">{modifiedAt}</td>
                <td class="right">
                    <button title="File renamed" class="btn btn-primary btn-xs">✎</button>
                    <button title="File deleted" class="btn btn-danger btn-xs">✖</button>
                </td>
            </tr>
            </tbody>
        </table>
    </div>

    <script>
        var me = this;
        var Fs = require('fs');
        var Path = require('path');
        var Moment = require('moment');

        me.dirEntries = [];
        console.log('opts.dir', opts.dir);
        me.paths = opts.dir.split(Path.sep);

        function humanizeFileSize(size) {
            var i = Math.floor(Math.log(size) / Math.log(1024));
            return ( size / Math.pow(1024, i) ).toFixed(2) * 1 + ' ' + ['B', 'kB', 'MB', 'GB', 'TB'][i];
        }

        me.scanDir = function (dir) {
            var files = [];
            for (var name of Fs.readdirSync(dir)) {
                var fullPath = Path.join(dir, name);
                var stat = Fs.statSync(fullPath);

                var entry = {
                    name:       name,
                    isDir:      stat.isDirectory(),
                    path:       fullPath,
                    modifiedAt: Moment(stat.mtime).fromNow()
                };

                if (stat.size === 0)
                    entry.size = '';
                else
                    entry.size = humanizeFileSize(stat.size);

                // add folder vo danh sach truoc
                if (entry.isDir) {
                    this.dirEntries.push(entry);
                } else {
                    files.push(entry);
                }
            }
            // add list files vo danh sanh dirEntries
            this.dirEntries.push.apply(this.dirEntries, files);
        };

        me.scanDir(opts.dir);

    </script>
</browse>
