<file-list-flat>
    <div class="input-group">
        <span class="input-group-addon" style="border-bottom-left-radius: 0;"><i class="fa fa-fw fa-filter"></i></span>
        <input type="text" class="form-control" style="border-bottom-right-radius: 0;" placeholder="Enter keywords to search" onkeyup="{onFilterInput}">
    </div>
    <div class="list-group" style="overflow: auto; height: 85vh;">
        <a href="#" each="{filteredFiles}" class="list-group-item truncate" title="{hideExt(name)}" data-path="{path}" onclick="{openFile}" style="{}">
            <span style="margin-right: 10px; margin-left: -5px;" class={getFileIcon(name, path)}></span> {getContentType(path)}{hideExt(name)}
        </a>
    </div>
    <script>
        var me = this;
        me.event = riot.observable();
        me.files = [];
        me.filteredFiles = [];

        var $root = $(me.root);
        var curFilePath = '';

        me.isPartial = function (path) {
            return path.indexOf('layout/partial/') != -1;
        };

        me.getContentType = function (path) {
            if (path.indexOf('layout/partial/') != -1)
                return '[Partial] ';
            if (path.indexOf('content/category/') != -1)
                return '[Category] ';
            return '';
        };

        me.getFileIcon = function (name, path) {
            var ext = name.split('\.').pop().toLowerCase();
            switch (ext) {
                case 'html':
                    if (me.isPartial(path))
                        return 'octicon octicon-file-text';
                    else
                        return 'octicon octicon-file-code';
                case 'css':
                case 'js':
                    return 'octicon octicon-file-code';
                case 'json':
                    return 'octicon octicon-settings';
                case 'md':
                    return 'octicon octicon-markdown';
                default:
                    return 'octicon octicon-file-text';
            }
        };

        var fuzzySearch = function (needle, haystack) {
            var hLen = haystack.length;
            var nLen = needle.length;
            if (nLen > hLen) {
                return false;
            }
            if (nLen === hLen) {
                return needle === haystack;
            }
            outer: for (var i = 0, j = 0; i < nLen; i++) {
                var nch = needle.charCodeAt(i);
                while (j < hLen) {
                    if (haystack.charCodeAt(j++) === nch) {
                        continue outer;
                    }
                }
                return false;
            }
            return true;
        };

        var delay = (function () {
            var timer = 0;
            return function (callback, ms) {
                clearTimeout(timer);
                timer = setTimeout(callback, ms);
            };
        })();

        var sortByExt = function (a, b) {
            if (a.path.startsWith('content/category'))
                return 1;

            if (a.path.startsWith('content/metadata/'))
                return 1;
//            return -1;
            return a.name > b.name;
        };

        var sortLayout = function (a, b) {
            if (a.path.startsWith('layout/partial'))
                return 1;
            return a.path > b.path;
        };

        var sortContentFiles = function (files) {
            var categories = [];
            var contents = [];
            var metadataList = [];

            files.forEach(function (file) {
                if (file.path.startsWith('content/category')) {
                    categories.push(file);
                } else if (file.path.startsWith('content/metadata/')) {
                    metadataList.push(file);
                } else {
                    contents.push(file);
                }
            });

            categories.sort();
            metadataList.sort();
            contents.sort();
            return metadataList.concat(categories, contents);
        };

        me.hideExt = function (name) {
            var parts = name.split('.');
            if (parts.length > 1)
                parts.pop();
            return parts.join('.');
        };

        me.loadFiles = function (files) {
            me.clear();
            if (me.opts.type == 'layout') {
                files = files.sort(sortLayout);
            } else if (me.opts.type == 'content') {
                files = sortContentFiles(files);
            } else
                files = files.sort(sortByExt);

            me.files = files;
            me.filteredFiles = files;
            me.update();
        };

        me.openFile = function (e) {
            var filePath = e.target.dataset.path;
            if (filePath === me.curFilePath) return;
            me.curFilePath = filePath;
            $root.find('.list-group-item').removeClass('active');
            $(e.currentTarget).addClass('active');
            me.event.trigger('openFile', filePath);
        };

        me.activeFile = function (filePath) {
//            console.log("filePath", filePath);
//            console.log("query '[data-path=\"' + filePath + '\"]'");
            var elm = $root.find('[data-path="' + filePath + '"]');
            $root.find('.list-group-item').removeClass('active');
            window.elm = elm;
//            console.log('elm', elm);
            $(elm).addClass('active');
        };

        me.filter = function (e) {
            var needle = e.target.value;
            var filtered = [];
            for (var file of me.files) {
                if (fuzzySearch(needle, file.name)) {
                    filtered.push(file);
                }
            }

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
    </script>
</file-list-flat>
