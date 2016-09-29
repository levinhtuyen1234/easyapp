<config-view-boolean>
    <div class="field">
        <label>Display name:</label>
        <input type="text"id="textDisplayName" value="{config.displayName}" onkeyup="{edit('config.displayName')}">
    </div>
    <!-- This field is required -->
    <div class="inline field">
        <input type="checkbox" onchange="{edit('config.required')}" checked="{config.required}">
        <label>Is required</label>
    </div>
    <!-- View Only Field -->
    <div class="inline field">
        <input type="checkbox" onchange="{edit('config.viewOnly')}" checked="{config.viewOnly}">
        <label>Only View</label>
    </div>

    <script>
        var me = this;
        me.mixin('form');

        me.config = { type: 'Boolean' };

        me.clear = function () {
            me.config = {
                type: 'Boolean'
            };
        };

        me.getConfig = function () {
            me.config.type = 'Boolean';
            return me.config;
        };

        me.loadConfig = function(config) {
            me.config = Object.assign({}, config);
            me.update();
        }
    </script>
</config-view-boolean>
