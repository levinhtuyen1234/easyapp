<config-view-media>
    <div class="form-group">
        <label class="col-sm-2 control-label">Display name:</label>
        <div class="col-sm-10">
            <input type="text" class="form-control" id="textDisplayName" value="{config.displayName}" onkeyup="{edit.bind(this,'config.displayName')}">
        </div>
    </div>
    <!-- This field is required -->
    <div class="form-group">
        <label class="col-sm-2 control-label">Is required</label>
        <div class="col-sm-10">
            <input type="checkbox" onchange="{edit.bind(this, 'config.required')}" checked="{config.required}">
        </div>
    </div>
    <!-- View Only Field -->
    <div class="form-group">
        <label class="col-sm-2 control-label">Only View</label>
        <div class="col-sm-10">
            <input type="checkbox" onchange="{edit.bind(this, 'config.viewOnly')}" checked="{config.viewOnly}">
        </div>
    </div>

    <script>
        var me = this;
        me.mixin('form');

        me.config = { type: 'Media' };

        me.clear = function () {
            me.config = {
                type: 'Media'
            };
        };

        me.getConfig = function () {
            me.config.type = 'Media';
            return me.config;
        };

        me.loadConfig = function(config) {
            console.log('config', config);
            me.config = Object.assign({}, config);
            me.update();
        }
    </script>
</config-view-media>
