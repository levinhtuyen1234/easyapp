<config-view-array>
    <div class="field">
        <label>Display name:</label>
        <input type="text" class="" id="textDisplayName" value="{config.displayName}" onkeyup="{bind('config.displayName')}">
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

    <!-- TODO model for children object -->

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
