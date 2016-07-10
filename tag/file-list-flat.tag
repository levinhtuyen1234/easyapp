<file-list-flat>
    <div class="input-group">
        <span class="input-group-addon" style="border-bottom-left-radius: 0;"><i class="fa fa-fw fa-filter"></i></span>
        <input type="text" class="form-control" style="border-bottom-right-radius: 0;" placeholder="Enter keywords to search" onkeyup="{onFilterInput}">
    </div>
    <ul class="list-group" style="overflow: auto;">
        <li each="{filteredFiles}" class="list-group-item file-list-group-item" data-path="{path}" onclick="{openFile}">{name}</li>
    </ul>
    <script>
        var me = this;
        me.event = riot.observable();
        me.files = [];
        me.filteredFiles = [];

        var $root = $(me.root);
        var curFilePath = '';

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

        me.loadFiles = function (files) {
            me.clear();
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
            me.event.trigger('openFile', filePath);
        };

        me.activeFile = function (filePath) {
            var elm = $root.find('li[data-path="' + filePath + '"]');
            $root.find('.list-group-item').removeClass('active');
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
