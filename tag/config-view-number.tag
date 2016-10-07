<config-view-number>
    <div class="field">
        <label class="">Display name:</label>
        <input type="text" class="form-control" id="textDisplayName" value="{config.displayName}" onkeyup="{edit('config.displayName')}">
    </div>
    <!-- This field is required -->
    <div class="inline field ui checkbox">
        <label class="title">Is required</label>
        <input type="checkbox" onchange="{edit('config.required')}" checked="{config.required}">
    </div>
    <br>
    <!-- View Only Field -->
    <div class="inline field ui checkbox">
        <label class="label">Only View</label>
        <input type="checkbox" onchange="{edit('config.viewOnly')}" checked="{config.viewOnly}">
    </div>

    <!-- Display Type -->
    <div class="field">
        <label class="">Display type:</label>
        <select class="ui dropdown" onchange="{edit('config.displayType'); tags['config-view-prop-predefined-value'].update()}">
            <option value="Number">Number</option>
            <option value="DropDown">DropDown</option>
        </select>
    </div>
    <config-view-prop-predefined-value type="number"></config-view-prop-predefined-value>

    <script>
        var me = this;
        me.mixin('form');

        me.config = {type: 'Number', displayType: 'Number'};

        me.on('mount', function () {
            $(me.root.querySelector('ui dropdown')).dropdown();

            $(me.root.querySelector('.selectpicker')).selectpicker();// select current displayType
            if (me.config.displayType) {
                $(me.root.querySelector('.selectpicker')).selectpicker('val', me.config.displayType);
            }
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

        me.loadConfig = function (config) {
            me.config = Object.assign({type: 'Number', displayType: 'Number'}, config);
            if (me.config.displayType) {
                $(me.root.querySelector('.selectpicker')).selectpicker('val', me.config.displayType);
            }
            me.update();
        }
    </script>
</config-view-number>
