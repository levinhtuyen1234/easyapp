<breadcrumb>
    <ol class="breadcrumb">
        <li each="{name, index in parts}"><a class="pathName" onclick="{open.bind(this,index)}">{name}</a></li>
    </ol>

    <script>
        var me = this;
        me.parts = [];
        me.opts.path = me.opts.path ? me.opts.path : '';

        me.setPath = function(filePath) {
            me.parts = filePath.split(/[\\\/]/);
            me.update();
        };

        me.on('mount', function() {
            me.setPath(me.opts.path);
        });

        me.open = function(index) {
            var fullPath = me.parts.slice(0, index + 1).join('/');
            console.log('breadcrumb clicked', fullPath);
            if (me.parent.open)
                me.parent.open(fullPath);
        };
    </script>
</breadcrumb>
