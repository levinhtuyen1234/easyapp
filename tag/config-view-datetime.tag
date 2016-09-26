<config-view-datetime>
    <div class="field">
        <label>Display name:</label>
        <input type="text" class="form-control" id="textDisplayName" value="{config.displayName}" onkeyup="{edit('config.displayName')}">
    </div>
    <!-- This field is required -->
    <div class="inline field">
        <label>Is required</label>
        <input type="checkbox" onchange="{edit('config.required')}" checked="{config.required}">
    </div>
    <!-- View Only Field -->
    <div class="inline field">
        <label>Only View</label>
        <input type="checkbox" onchange="{edit('config.viewOnly')}" checked="{config.viewOnly}">
    </div>

    <!-- DateTime type -->
    <div class="field">
        <label>Display type:</label>
        <select class="ui dropdown" onchange="{edit('config.displayType')}">
            <option value="Time">Time</option>
            <option value="Date">Date</option>
            <option value="DateTime">DateTime</option>
        </select>
    </div>


    <script>
        var me = this;
        me.mixin('form');

        me.config = {type: 'DateTime'};

        me.on('mount', function () {
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
                $(me.root.querySelector('.selectpicker')).selectpicker('val', me.config.displayType);
            }


            me.update();
        }
    </script>
</config-view-datetime>
