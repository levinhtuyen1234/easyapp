<side-bar>
    <div class="row">
        <!-- ADD button -->
        <div class="btn-group btn-block" style="width: 270px; padding: 15px 15px 0 15px;">
            <button type="button" class="btn btn-primary dropdown-toggle btn-block" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <i class="fa fa-fw fa-plus"></i> New <span class="caret"></span>
            </button>
            <ul class="dropdown-menu">
                <li><a href="#" onclick="{parent.addContent}"><i class="fa fa-newspaper-o fa-fw"></i> Content</a></li>
                <li><a href="#" onclick="{parent.addLayout}"><i class="fa fa-file-code-o fa-fw"></i> Layout</a></li>
                <li><a href="#" onclick="{parent.addConfig}"><i class="fa fa-gear fa-fw"></i> Config</a></li>
            </ul>
        </div>
    </div>

    <div class="row">
        <div class="panel panel-default">
            <div class="panel-heading">Files</div>
            <div class="panel-body">
                <div class="input-group">
                    <span class="input-group-addon"><i class="fa fa-fw fa-filter"></i></span>
                    <input type="text" class="form-control" placeholder="Filter" onkeyup="{onFilterInput}">
                </div>
                <ul class="list-group" style="height: calc(100vh - 200px); overflow: auto;">
                    <li each="{filteredFiles}" class="list-group-item" data-path="{path}" onclick="{openFile}">{name}</li>
                </ul>
            </div>
        </div>
    </div>

    <script>
        var me = this;
        var table, dataTable;
        var $root = $(me.root);
        var curFilePath = '';

        me.files = [];
        me.filteredFiles = [];

        function fuzzySearch(needle, haystack) {
            var hlen = haystack.length;
            var nlen = needle.length;
            if (nlen > hlen) {
                return false;
            }
            if (nlen === hlen) {
                return needle === haystack;
            }
            outer: for (var i = 0, j = 0; i < nlen; i++) {
                var nch = needle.charCodeAt(i);
                while (j < hlen) {
                    if (haystack.charCodeAt(j++) === nch) {
                        continue outer;
                    }
                }
                return false;
            }
            return true;
        }

        var delay = (function () {
            var timer = 0;
            return function (callback, ms) {
                clearTimeout(timer);
                timer = setTimeout(callback, ms);
            };
        })();

        me.loadFiles = function (siteDir) {
            me.clear();
            var files = BackEnd.getSiteFiles(siteDir);
            me.files = files;
            me.filteredFiles = files;
            me.update();
        };

        me.openFile = function (e) {
            var filePath = e.target.dataset.path;
            if (filePath === me.curFilePath) return;
            me.curFilePath = filePath;
            $root.find('.list-group-item').removeClass('active');
            $(e.target).addClass('active');
            if (filePath.endsWith('.md'))
                me.openContentFile(filePath);
            else
                me.openLayoutFile(filePath);
        };

        me.openLayoutFile = function (filePath) {
            console.log('openLayoutFile', filePath);
        };

        me.openContentFile = function (filePath) {
            console.log('openContentFile', filePath);
        };

        me.filter = function (e) {
            console.log('filter');
            var needle = e.target.value;
            var filtered = [];
            for (var file of me.files) {
                if (fuzzySearch(needle, file.name)) {
                    filtered.push(file);
                }
            }

            me.clear();
            me.filteredFiles = filtered;
            me.update();
        };

        me.onFilterInput = function (e) {
            delay(function () {
                me.filter(e)
            }, 100);
        };

        me.clear = function () {
            me.filteredFiles = [];
            me.files = [];
            me.update();
        };

        me.on('mount', function () {
            me.loadFiles(opts.dir);
        });

    </script>
</side-bar>
