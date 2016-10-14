<config-view-text>
    <div class="field">
        <label>Display name:</label>
        <input type="text" value="{config.displayName}" onkeyup="{edit('config.displayName')}">
    </div>

    <div class="field">
        <label>Default value:</label>
        <input type="text" value="{config.defaultValue}" onkeyup="{edit('config.defaultValue')}">
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
    <br>

    <!-- Display Type -->
    <div class="inline field">
        <label class="">Display type:</label>
        <select id="displayTypeDropDown" class="ui dropdown" onchange="{edit('config.displayType'); tags['config-view-prop-predefined-value'].update()}">
            <option value="ShortText">Short Text</option>
            <option value="LongText">Long Text</option>
            <option value="MarkDown">Markdown</option>
            <option value="DropDown">DropDown</option>
        </select>
    </div>

    <config-view-prop-predefined-value type="text"></config-view-prop-predefined-value>
    <script>
        var me = this;
        me.mixin('form');

        me.config = {type: 'Text', displayType: 'ShortText'};
        me.textNumOfCharType = 'Between';
        me.textMatchPatternType = '';

        var dropdown;

        me.on('mount', function () {
            dropdown = $(me.displayTypeDropDown).dropdown();
//            console.log('displayTypeDropDown', dropdown);
            if (me.config.displayType) {
                dropdown.dropdown('set selected', me.config.displayType);
            }
        });

        me.clear = function () {
            me.config = {
                type: 'Text'
            };
        };

        me.getConfig = function () {
            me.config.type = 'Text';
            return me.config;
        };

        me.loadConfig = function (config) {
            me.config = Object.assign({type: 'Text', displayType: 'ShortText'}, config);
            // select current displayType
            if (me.config.displayType) {
                dropdown.dropdown('set selected', me.config.displayType);
            }
            me.update();
        };
    </script>
</config-view-text>
