<config-view-datetime>
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

    <!-- DateTime type -->
    <div class="form-group">
        <label class="col-sm-2 control-label">DateTime type:</label>
        <div class="col-sm-10">
            <select class="selectpicker" onchange="{edit.bind(this,'config.dateTimeType')}">
                <option value="Time">Time</option>
                <option value="Date">Date</option>
                <option value="DateTime">DateTime</option>
            </select>
        </div>
    </div>


    <script>
        var me = this;
        me.mixin('form');

        me.config = {type: 'DateTime'};

        me.on('mount', function(){
            $(me.root.querySelector('.selectpicker')).selectpicker();
        });

        me.clear = function () {
            me.config = {
                type: 'DateTime'
            };
        };

        me.getConfig = function () {
            me.config.type = 'DateTime';
            return me.config;
        };

        me.loadConfig = function (config) {
            me.config = Object.assign({}, config);
            if (me.config.dateTimeType) {
                console.log('select picker date time type', me.config.dateTimeType);
                $(me.root.querySelector('.selectpicker')).selectpicker('val', me.config.dateTimeType);
            }


            me.update();
        }
    </script>
</config-view-datetime>
