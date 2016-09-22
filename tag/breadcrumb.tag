<breadcrumb>
    <ol class="breadcrumb" style="margin: 2px 0 2px 0; padding: 0;">
        <li each="{name, index in parts}"><a class="pathName default-cursor" onclick="{showItemInFolder}">{name}</a></li>
    </ol>

    <style>
        .hand-cursor {
            cursor: pointer !important;
        }

        .default-cursor {
            cursor: default;
        }
    </style>
    <script>
        var me = this;
        me.parts = [];
        me.opts.path = me.opts.path ? me.opts.path : '';

        me.setPath = function(filePath) {
            me.parts = filePath.split(/[\\\/]/);
            me.parts.unshift(me.opts.site_name);
            me.update();
            var links = $(me.root.querySelectorAll('a'));
            if (me.parts[me.parts.length - 1].endsWith('.html')) {
                links.addClass('hand-cursor');
            } else {
                links.removeClass('hand-cursor');
            }
        };

        me.on('mount', function() {
            me.setPath(me.opts.path);
        });

        me.showItemInFolder = function(e) {
            // only allow click with layout file (.html)
            if (!me.parts[me.parts.length - 1].endsWith('.html')) {
                return;
            }

            var path = me.parts.slice(1, e.item.index + 1).join('/');
//            console.log('showItemInFolder', me.opts.site_name + '/' + path);
            BackEnd.showItemInFolder(me.opts.site_name, path);
        };

        me.open = function(index) {
            var fullPath = me.parts.slice(0, index + 1).join('/');
            if (me.parent.open)
                me.parent.open(fullPath);
        };
    </script>
</breadcrumb>
