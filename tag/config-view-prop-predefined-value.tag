<config-view-prop-predefined-value show="{parent.config.displayType === 'DropDown'}">
    <form class="col-sm-10 col-sm-offset-2 form-horizontal">
        <div class="field">
            <label class="" for="fieldPredefinedName">Name</label>
                <input type="text" class="form-control" id="fieldPredefinedName" placeholder="Name" onkeyup="{edit( 'predefinedName')}" value="{predefinedName}">
        </div>
        <div class="field">
            <label class="" for="fieldPredefinedValue">Value</label>
                <input type="{type}" class="form-control" id="fieldPredefinedValue" placeholder="Value" onkeyup="{edit( 'predefinedValue')}" value={predefinedValue}>
        </div>
        <div class="field">
                <button type="button" class="btn btn-default" disabled="{predefinedName.trim() === '' || predefinedValue.trim() === ''}" onclick="{addPredefined}">Add</button>
        </div>
        <ul class="field">
            <li class="list-group-item" each="{data, index in parent.config.predefinedData}">
                <span>{data.name} - {data.value}
                    <button class="btn btn-sm pull-right" onclick="{removePredefined.bind(this, index)}"><i class="fa fa-close"></i></button>
                </span>
            </li>
        </ul>
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
