<config-view-boolean>
    <div class="field">
        <label>Display name:</label>
        <input type="text"id="textDisplayName" value="{config.displayName}" onkeyup="{edit.bind(this,'config.displayName')}">
    </div>

    <div class="inline field ui checkbox">
        <label class="title">Default value:</label>
        <input type="checkbox" onchange="{edit.bind(this,'config.defaultValue')}" checked="{config.defaultValue}">
    </div>

    <!-- This field is required -->
    <div class="inline field ui checkbox">
        <label class="title">Is required</label>
        <input type="checkbox" onchange="{edit.bind(this,'config.required')}" checked="{config.required}">
    </div>
    <br>
    <!-- View Only Field -->
    <div class="inline field ui checkbox">
        <label class="label">Only View</label>
        <input type="checkbox" onchange="{edit.bind(this,'config.viewOnly')}" checked="{config.viewOnly}">
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
