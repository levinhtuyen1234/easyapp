<config-view-number>
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

    <!-- Display Type -->
    <div class="form-group">
        <label class="col-sm-2 control-label">Display type:</label>
        <div class="col-sm-10">
            <select class="selectpicker" onchange="{edit.bind(this,'config.displayType'); tags['config-view-prop-predefined-value'].update()}">
                <option value="Number">Number</option>
                <option value="DropDown">DropDown</option>
            </select>
        </div>
    </div>
    <config-view-prop-predefined-value type="number"></config-view-prop-predefined-value>

    <script>
        var me = this;
        me.mixin('form');

        me.config = { type: 'Number' };

        me.on('mount', function(){
            $(me.root.querySelector('.selectpicker')).selectpicker();
        });

        me.clear = function () {
            me.config = {
                type: 'Number'
            };
        };

        me.getConfig = function () {
            me.config.type = 'Number';
            return me.config;
        };

        me.loadConfig = function(config) {
            me.config = Object.assign({}, config);
            me.update();
        }
    </script>
</config-view-number>
