<browse role="tabpanel" class="tab-pane active" id="browse">
    <div class="row">
        <div class="col-md-12">
            <ol class="breadcrumb">
                <li each="{name, index in breadcrumb}"><a class="pathName" onclick="{goBack.bind(this,index)}">{name}</a></li>
                <div class="pull-right">
                    <!--<label class="btn btn-default btn-xs btn-file">-->
                    <!--Browse <input type="file" style="display: none;">-->
                    <!--</label>-->
                    <button class="btn btn-primary btn-xs" onclick="alert('TODO');">New <i class="fa fa-plus"></i></button>
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
                    <i class="fa { isDir ? 'fa-folder' : 'fa-file'}"></i>
                    <a class="pathName" onclick="{isDir ? scanDir.bind(this,path) : openFile.bind(this,path)}">
                        <i class="fa fa-level-up" show="{path == '..'}"></i> {name}
                    </a>
                </td>
                <td class="hidden-xs">{size}</td>
                <td class="hidden-xs text-right">{modifiedAt}</td>
                <td class="text-right">
                    <button title="rename" class="btn btn-primary btn-xs" show="{path !== '..'}" onclick="{confirmRename.bind(this,path)}">✎</button>
                    <button title="delete" class="btn btn-danger btn-xs" show="{path !== '..'}" onclick="{confirmDelete.bind(this,path)}">✖</button>
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
        var RimRaf = require('rimraf');

        var siteFolder = opts.dir.split(Path.sep).pop();
        var root = Path.join(__dirname, 'sites', siteFolder);
        var curPath = root;
        var ignoreDir = ['.git', '__PUBLIC', '.gitignore'];
        me.dirEntries = [];
        me.breadcrumb = [siteFolder];

        function humanizeFileSize(size) {
            var i = Math.floor(Math.log(size) / Math.log(1024));
            return ( size / Math.pow(1024, i) ).toFixed(2) * 1 + ' ' + ['B', 'kB', 'MB', 'GB', 'TB'][i];
        }

        me.goBack = function (n) {
            n = me.breadcrumb.length - n - 1;
            var dir = '';
            while (n > 0) {
                dir = Path.join(dir, '..');
                n -= 1;
            }
            me.scanDir(dir);
        };

        me.openFile = function (filePath) {
            console.log('openFile', filePath);
            alert('TODO');
        };

        me.confirmDelete = function (filePath) {
            bootbox.confirm(`Are you sure you want to delete "${filePath}" ?`, function(ok) {
                if (!ok) return;
                RimRaf.sync(Path.join(curPath, filePath), {glob: false});
                me.scanDir('');
            });
        };

        me.confirmRename = function (filePath) {
            bootbox.prompt({
                title:    `Write down the new name of "${filePath}".`,
                value:    filePath,
                callback: function (newName) {
                    if (newName === null || newName === filePath)
                        return;

                    Fs.renameSync(Path.join(curPath, filePath), Path.join(curPath, newName));
                    me.scanDir('');
                }
            });
        };

        me.scanDir = function (dir) {
            if (ignoreDir.indexOf(dir) != -1) return;
            curPath = Path.join(curPath, dir);

            if (dir === '..') me.breadcrumb.pop();
            else if (dir !== '') me.breadcrumb.push(dir);

            var files = [];
            me.dirEntries = [];
            // them .. neu khong phai la root
            if (curPath !== root) {
                me.dirEntries.push({
                    name:       'up',
                    isDir:      true,
                    path:       '..',
                    modifiedAt: ''
                });
            }
            for (var name of Fs.readdirSync(curPath)) {
                if (ignoreDir.indexOf(name) != -1) continue;
                var fullPath = Path.join(curPath, name);
                var stat = Fs.statSync(fullPath);

                var entry = {
                    name:       name,
                    isDir:      stat.isDirectory(),
                    path:       name,
                    modifiedAt: Moment(stat.mtime).fromNow()
                };

                if (stat.size === 0)
                    entry.size = '';
                else
                    entry.size = humanizeFileSize(stat.size);

                // add folder vo danh sach truoc
                if (entry.isDir) {
                    me.dirEntries.push(entry);
                } else {
                    files.push(entry);
                }
            }
            // add list files vo danh sanh dirEntries
            me.dirEntries.push.apply(me.dirEntries, files);
            me.update();
        };

        me.scanDir('');

    </script>
</browse>
