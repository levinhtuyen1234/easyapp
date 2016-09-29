<config-view-array>
    <div class="field">
        <label>Display name:</label>
        <input type="text" class="" id="textDisplayName" value="{config.displayName}" onkeyup="{bind('config.displayName')}">
    </div>
    <!-- This field is required -->
    <div class="inline field">
        <input type="checkbox" onchange="{bind('config.required')}" checked="{config.required}">
        <label>Is required</label>
    </div>

    <!-- View Only Field -->
    <div class="inline field">
        <input type="checkbox" onchange="{bind('config.viewOnly')}" checked="{config.viewOnly}">
        <label>Only View</label>
    </div>

    <script>
        var me = this;
        me.mixin('form');

        me.config = {type: 'Array'};

        me.clear = function () {
            me.config = {
                type: 'Array'
            };
        };

        me.getConfig = function () {
            me.config.type = 'Array';
            return me.config;
        };

        me.loadConfig = function (config) {
            console.log('config', config);
            me.config = Object.assign({}, config);
            me.update();
        }
    </script>
</config-view-array>
