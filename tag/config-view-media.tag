<config-view-media>
    <div class="field">
        <input type="text" class="form-control" id="textDisplayName" value="{config.displayName}" onkeyup="{edit('config.displayName')}">
        <label class="">Display name:</label>
    </div>
    <!-- This field is required -->
    <div class="inline field">
        <input type="checkbox" onchange="{edit( 'config.required')}" checked="{config.required}">
        <label class="">Is required</label>
    </div>
    <!-- View Only Field -->
    <div class="inline field">
        <label class="">Only View</label>
        <input type="checkbox" onchange="{edit( 'config.viewOnly')}" checked="{config.viewOnly}">
    </div>

    <script>
        var me = this;
        me.mixin('form');

        me.config = {type: 'Media'};

        me.clear = function () {
            me.config = {
                type: 'Media'
            };
        };

        me.getConfig = function () {
            me.config.type = 'Media';
            return me.config;
        };

        me.loadConfig = function (config) {
            console.log('config', config);
            me.config = Object.assign({}, config);
            me.update();
        }
    </script>
</config-view-media>
