<config-view-object>
    <div class="form-group">
        <label class="col-sm-2 control-label">Display name:</label>
        <div class="col-sm-10">
            <input type="text" class="form-control" id="textDisplayName" value="{config.displayName}" onkeyup="{edit.bind(this,'config.displayName')}">
        </div>
    </div>
    <!-- This field is required -->
    <label>
        <input type="checkbox" onchange="{edit.bind(this, 'config.required')}" checked="{config.required}"> This field is required
    </label>

    <script>
        var me = this;
        me.mixin('form');

        me.config = { type: 'Object' };

        me.clear = function () {
            me.config = {
                type: 'Object'
            };
        };

        me.getConfig = function () {
            me.config.type = 'Object';
            return me.config;
        };

        me.loadConfig = function(config) {
            console.log('config', config);
            me.config = Object.assign({}, config);
            me.update();
        }
    </script>
</config-view-object>
