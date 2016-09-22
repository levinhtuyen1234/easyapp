<breadcrumb>
    <div class="ui breadcrumb compact truncate" style="padding-left: 10px;">
        <virtual each="{name, index in parts}">
            <i if="{index > 0 && index <= parts.length - 1}" class="right chevron icon divider"></i>
            <div title="{name}" class="section {index == parts.length - 1 ? 'active' : ''}" onclick="{showItemInFolder}">{name}</div>
        </virtual>
    </div>

    <style>
        .hand-cursor {
            cursor: pointer;
        }

        .hand-cursor:hover {
            text-decoration: underline;
        }
    </style>
    <script>
        var me = this;
        me.parts = [];
        me.opts.path = me.opts.path ? me.opts.path : '';

        me.setPath = function (filePath) {
            me.parts = filePath.split(/[\\\/]/);
            me.parts.unshift(me.opts.site_name);
            me.update();

            var links = $(me.root.querySelectorAll('.section'));
            if (me.parts[me.parts.length - 1].endsWith('.html')) {
                links.addClass('hand-cursor');
            } else {
                links.removeClass('hand-cursor');
            }
        };

        me.showItemInFolder = function (e) {
            if (!me.parts[me.parts.length - 1].endsWith('.html')) return;
            var path = me.parts.slice(1, e.item.index + 1).join('/');
            BackEnd.showItemInFolder(me.opts.site_name, path);
        };


        me.on('mount', function () {
            me.setPath(me.opts.path);
        });

        me.open = function (index) {
            var fullPath = me.parts.slice(0, index + 1).join('/');
            if (me.parent.open)
                me.parent.open(fullPath);
        };
    </script>
</breadcrumb>
