<config-view-prop-predefined-value show="{parent.config.displayType === 'DropDown'}">
    <form class="ui form">
        <div class="ui grid">
            <div class="fourteen wide column">
                <div class="two fields">
                    <div class="inline field">
                        <label class="" for="fieldPredefinedName">Name</label>
                        <input style="width: calc(100% - 50px);" type="text" class="form-control" id="fieldPredefinedName" placeholder="Name" onkeyup="{edit( 'predefinedName')}" value="{predefinedName}">
                    </div>
                    <div class="inline field">
                        <label class="" for="fieldPredefinedValue">Value</label>
                        <input style="width: calc(100% - 50px);" type="{type}" class="form-control" id="fieldPredefinedValue" placeholder="Value" onkeyup="{edit( 'predefinedValue')}" value={predefinedValue}>
                    </div>
                </div>
            </div>
            <div class="two wide column" style="padding-right: 0;">
                <div class="ui button" disabled="{predefinedName.trim() === '' || predefinedValue.trim() === ''}" onclick="{addPredefined}">Add</div>
            </div>
        </div>

        <div class="ui middle aligned divided list">
            <div class="item" each="{data, index in parent.config.predefinedData}">
                <div class="right floated content">
                    <div class="ui tiny button " onclick="{removePredefined.bind(this, index)}"><i class="fa fa-close"></i></div>
                </div>
                <div class="content">
                    {data.name} - {data.value}
                </div>
            </div>
        </div>
    </form>
    <script>
        // TODO not allow duplicate dropdown value
        var me = this;
        me.mixin('form');
        me.type = opts.type || 'text';

        me.predefinedName = '';
        me.predefinedValue = me.type === 'text' ? '' : 0;


        me.on('mount', function () {
            me.parent.config.predefinedData = me.parent.config.predefinedData === undefined ? [] : me.parent.config.predefinedData;
        });

        me.addPredefined = function () {
            console.log('addPredefined', me.parent.config);
            me.parent.config.predefinedData = me.parent.config.predefinedData === undefined ? [] : me.parent.config.predefinedData;
            me.parent.config.predefinedData.push({
                name:  me.predefinedName.trim(),
                value: me.predefinedValue.trim()
            });
            me.predefinedName = '';
            me.predefinedValue = '';
            me.update();
            $(me.fieldPredefinedValue).focus();
        };

        me.removePredefined = function (index) {
            me.parent.config.predefinedData.splice(index, 1);
            me.update();
        };
    </script>
</config-view-prop-predefined-value>
