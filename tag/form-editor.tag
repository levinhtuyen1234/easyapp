<form-editor id="{opts.id}" role="tabpanel" class="tab-pane {opts.active ? 'active':''}">
    <form class="form-horizontal" style="padding: 5px;">
    </form>
    <script>
        var me = this;
        me.form = null;

        me.on('mount', function () {
            me.form = me.root.querySelector('form');
        });

        function genSimpleInput(display, name, type, value) {
            if (type === 'boolean') {
                return `<div class="form-group">
                    <label for="" class="col-sm-3 control-label" style="text-align: left;">${displayName}
                    </label>
                    <div class="col-sm-9">
                        <div class="checkbox">
                        <label>
                            <input type="checkbox" name="input-${name}" checked="${value}">
                        </label>
                        </div>
                    </div>
                </div>`;
            }
            return `<div class="form-group">
                <label for="" class="col-sm-3 control-label" style="text-align: left;">${displayName}

                </label>
                <div class="col-sm-9">
                    <input type="${type}" name="input-${name}" class="form-control" id="" placeholder="${value}" value="${value}">
                </div>
            </div>`;
        }

        function genTextInput(config, metaValue) {
            metaValue = metaValue ? metaValue : '';
            return `<div class="form-group">
                    <label for="" class="col-sm-3 control-label" style="text-align: left;">${config.displayName}

                    </label>
                    <div class="col-sm-9">
                        <input type="text" name="input-${config.name}" data-name="${config.name}" class="form-control" id="" value="${metaValue}">
                    </div>
                </div>`;
        }

        function genBooleanInput(config, metaValue) {
            metaValue = metaValue ? metaValue : '';
            return `<div class="form-group">
                    <label for="" class="col-sm-3 control-label" style="text-align: left;">${config.displayName}
                    </label>
                    <div class="col-sm-9">
                        <div class="checkbox">
                        <label>
                            <input type="checkbox" name="input-${config.name}" data-name="${config.name}" checked="${metaValue}">
                        </label>
                        </div>
                    </div>
                </div>`;
        }

        function genIntegerInput(config, metaValue) {
            metaValue = metaValue ? metaValue : '';
            return `<div class="form-group">
                    <label for="" class="col-sm-3 control-label" style="text-align: left;">${config.displayName}

                    </label>
                    <div class="col-sm-9">
                        <input type="number" name="input-${config.name}" data-name="${config.name}" class="form-control" id="" placeholder="${config.name}" value="${metaValue}">
                    </div>
                </div>`;
        }

        function genFormWithoutModel(form) {
            var innerForm = '';

            for (var key in form) {
                if (!form.hasOwnProperty(key)) continue;
                var value = form[key];
                switch (typeof value) {
                    case 'string':
                        innerForm += genSimpleInput(key, 'text', value);
                        break;
                    case 'number':
                        innerForm += genSimpleInput(key, 'number', value);
                        break;
                    case 'boolean':
                        innerForm += genSimpleInput(key, 'boolean', value);
                        break;
                }
            }
            return innerForm;
        }

        function getInputValue(input) {
            switch (input.type) {
                case 'checkbox':
                    return input.value === 'on';
                    break;
                case 'number':
                    return parseFloat(input.value);
                default:
                    return input.value;
            }
        }

        me.getForm = function () {
            var inputs = me.form.querySelectorAll('input[name^="input-"]');
            var ret = {};
            inputs.forEach(function (input) {
                ret[input.dataset.name] = getInputValue(input);
            });
            return ret;
        };

        me.clear = function () {
            me.form.innerHTML = '';
        };

        me.genForm = function (metaData, contentConfig) {
//            console.log('genForm', metaData, contentConfig);
            var innerForm = '';
            for (var i = 0; i < contentConfig.length; i++) {
                var fieldConfig = contentConfig[i];
                var metaValue = metaData[fieldConfig.name];
                switch (fieldConfig.type) {
                    case 'Text':
                        innerForm += genTextInput(fieldConfig, metaValue);
                        break;
                    case 'Number':
                        innerForm += genIntegerInput(fieldConfig, metaValue);
                        break;
                    case 'Boolean':
                        innerForm += genBooleanInput(fieldConfig, metaValue);
                        break;
                    case 'DateTime':
                        innerForm += genDateTimeInput(fieldConfig, metaValue);
                        break;
                }
            }
            me.form.innerHTML = innerForm;
        }
    </script>
</form-editor>
