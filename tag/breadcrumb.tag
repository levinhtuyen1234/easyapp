<breadcrumb>
    <div class="ui breadcrumb compact" each="{name, index in parts}">
        <i if="{index > 0 && index <= parts.length - 1}" class="right chevron icon divider"></i>
        <a class="section {index == parts.length - 1 ? 'active' : ''}">{name}</a>
    </div>
    <!--<a class="section">Home</a>-->

    <!--<a class="section">Registration</a>-->
    <!--<i class="right arrow icon divider"></i>-->
    <!--<div class="active section">Personal Information</div>-->
    <!--<ol class="breadcrumb" style="margin: 2px 0 2px 0; padding: 0;">-->
        <!--<li each="{name, index in parts}"></li>-->
    <!--</ol>-->

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
