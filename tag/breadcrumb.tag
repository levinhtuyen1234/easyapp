<breadcrumb>
    <div class="ui breadcrumb compact truncate" style="padding-left: 10px;">
        <virtual each="{name, index in parts}">
            <i if="{index > 0 && index <= parts.length - 1}" class="right chevron icon divider"></i>
            <div title="{name}" class="section {index == parts.length - 1 ? 'active' : ''}">{name}</div>
        </virtual>
    </div>

    <script>
        var me = this;
        me.parts = [];
        me.opts.path = me.opts.path ? me.opts.path : '';

        me.setPath = function(filePath) {
            me.parts = filePath.split(/[\\\/]/);
            me.parts.unshift(me.opts.site_name);
            me.update();
        };

        me.on('mount', function() {
            me.setPath(me.opts.path);
        });

        me.open = function(index) {
            var fullPath = me.parts.slice(0, index + 1).join('/');
            if (me.parent.open)
                me.parent.open(fullPath);
        };
    </script>
</breadcrumb>
