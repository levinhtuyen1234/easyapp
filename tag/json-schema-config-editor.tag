<json-schema-field-config-dialog class="ui modal">
    <div class="header">{modalTitle}</div>
    <div class="content">
        <div class="ui form">
            <div class="inline field">
                <label>Field type</label>
                <select id="fieldTypeDropDown" class="ui dropdown" onchange="{ShowFieldConfig}">
                    <option each="{field in fieldTypes}" value="{field.value}">{field.name}</option>
                </select>
            </div>
            <div class="editor"></div>
        </div>
    </div>
    <div class="actions">
        <div class="ui button deny">Close</div>
        <div class="ui button positive icon" disabled="{layoutName==''}" onclick="{saveConfig}">Set</div>
    </div>

    <script>
        var me = this;
        var modal, fieldTypeDropDown;
        var editor;
        me.curFieldType = '';

        var AllFieldTypes = [
            {name: 'String', value: 'string'},
            {name: 'Integer', value: 'integer'},
            {name: 'Number', value: 'number'},
            {name: 'Boolean', value: 'boolean'},
            {name: 'Object', value: 'object'},
            {name: 'Array', value: 'array'}
        ];

        me.fieldTypes = AllFieldTypes;

        me.saveConfig = function () {
            console.log('SAVE CONFIGGGG', editor.getValue());
            if (me.callback) {
                me.callback(editor.getValue());
            }
            modal.modal('hide');
//            var contentType = me.fieldTypeDropDown.value;
//            var formTag = formTags[contentType];
//            if (!formTag) return;
//
//            var newConfig = formTag.getConfig();
//
//            Object.assign(me.curConfig, newConfig);
//
//            me.parent.onFieldSettingChanged();
//            modal.modal('hide');
        };

        me.on('mount', function () {
            fieldTypeDropDown = $(me.root.querySelector('.ui.dropdown'));
            fieldTypeDropDown.dropdown();
//            editorElm = $(me.root).find('.editor');

            modal = $(me.root).modal({
                autofocus:      false,
                observeChanges: true
            });
        });

        me.ShowFieldConfig = function (e) {
            if (e.target.value == '') return;
//            console.debug('ShowFieldConfig', e.target.value);
            me.curFieldType = e.target.value;
            console.log('chosen field type', me.curFieldType, 'me.originalFieldType', me.originalFieldType);

            // set displayName khi chuyen sang Content type khac
            if (me.curFieldType !== me.originalFieldType) {
                editor.destroy();
                console.log('me.curContentConfig', me.curContentConfig);
                editor = new JsonSchemaEditor(me.curContentConfig);
                editor.loadSchema($(me.root).find('.editor')[0], me.curFieldType, me.configValue.path);
//                var configFieldTag = 'config-view-' + me.curFieldType.toLowerCase();
//                console.debug('configFieldTag', configFieldTag);
//                if (me.tags[configFieldTag]) {
//                    me.tags[configFieldTag].loadConfig({
//                        name:         me.curConfig.name,
//                        displayName:  me.curConfig.displayName,
//                        defaultValue: me.curConfig.defaultValue
//                    });
//                }
            }
//            me.update();
        };

        me.show = function (curContentConfig, configValue, callback) {
            console.log('curContentConfig', curContentConfig);
            console.log('configValue', configValue);

            me.curContentConfig = curContentConfig;
            me.configValue = configValue;
            me.callback = callback;

            if (editor && editor.destroy) {
                editor.destroy();
                editor = null;
            }



//            me.curConfig = config;
//
            var fieldName = configValue.path;
            var fieldType = configValue.schema.type;
//            console.log('showFieldSettingDialog', fieldName, 'fieldType');
            me.modalTitle = 'Configuration for ' + fieldName;
            me.curFieldType = fieldType;
            me.curConfigFieldName = fieldName;

            me.originalFieldType = fieldType;

//            console.log('set selected', fieldType);
            fieldTypeDropDown.dropdown('set selected', fieldType);

            // load schema and value to editor
            editor = new JsonSchemaEditor(me.curContentConfig);
            editor.loadSchema($(me.root).find('.editor')[0], fieldType, me.configValue.path);

//            formTags[fieldType].clear(); // clear form setting
//            formTags[fieldType].loadConfig(config);

            me.update();
            modal.modal('show');
        };

        me.hide = function () {
            modal.modal('hide');
        };
    </script>
</json-schema-field-config-dialog>

<json-schema-config-editor style="height: calc(100% - 88px); overflow-y: auto;" onkeypress="{checkSave}">
    <div name="editorElm" class="ui form" onkeypress="{checkSave}"></div>
    <json-schema-field-config-dialog></json-schema-field-config-dialog>
    <script>
        var me = this;
        var editor, curContentConfig;

        function getConfig(schema, configPath) {
            var parts = configPath.split('.');
            parts.shift(); // remove root
            var ret = schema;

            if (parts.some(function (key) {
                    if (!ret.properties && !ret.items) {
                        return true;
                    }
//                    console.log('key', key);
                    if (key === '0') {
                        ret = ret.items;
                        return false;
                    } else if (ret.properties[key]) {
                        ret = ret.properties[key];
                        return false;
                    } else {
                        return true;
                    }
                }) == false) {
//                console.log('found', ret);
                return ret;
            }
//            console.log('not found', ret);
            return null;
        }

        me.on('mount', function () {
            var addedProperties = [];
            var removedProperties = [];

            window.showJsonSchemaConfigDialog = function (options) {
                console.log('showJsonSchemaConfigDialog', 'options', options);
                me.tags['json-schema-field-config-dialog'].show(curContentConfig, options, function (newSchema) {
//                    console.log('TODO reload schema gen new form');
                    curContentConfig = newSchema;
                    schemaSetArrayFormat(curContentConfig, 'table');
                    me.loadContentConfig(curContentConfig);
                });
            };

            window.jsonSchemaOnAddProperty = function (name) {
                addedProperties.push(name);
                _.pull(removedProperties, name);
            };

            window.jsonSchemaOnRemoveProperty = function (name) {
                removedProperties.push(name);
                _.pull(addedProperties, name);
            };

            window.jsonSchemaOnShowAddProperty = function (configPath) {
                addedProperties = [];
                removedProperties = [];
            };

            window.jsonSchemaOnHideAddProperty = function (configPath) {
                // apply change to schema
                var fieldSchema = getConfig(curContentConfig, configPath);
                console.log('jsonSchemaOnHideAddProperty fieldSchema', configPath, fieldSchema);
                removedProperties.forEach(function (name) {
                    console.log('remove', name);
                    delete fieldSchema.properties[name];
                });

                addedProperties.forEach(function (name) {
                    console.log('add', name, fieldSchema.properties[name]);
                    if (fieldSchema.properties[name] === undefined)
                        fieldSchema.properties[name] = {type: 'string', default: ''};
                });

                schemaSetArrayFormat(curContentConfig, 'table');
                // refresh editor
                me.loadContentConfig(curContentConfig);
            };
        });

        me.on('unmount', function () {
            if (editor) {
                editor.destroy();
                editor = null;
            }
        });

        me.checkSave = function (e) {
            // check ctrl + S -> save
            if (!(e.which == 115 && e.ctrlKey) && !(e.which == 19)) return true;
            console.log('TODO Ctrl-S pressed');
            e.preventDefault();
            return false;
        };

        // insert maxItem config = 1 to every field with type == array
        const schemaLimitMaxItem = function (obj, max) {
            if (!typeof(obj) === 'object') return;
            if (obj && obj.type && obj.type === 'array') {
                obj.maxItems = max;
            }

            if (obj.properties) {
                _.forOwn(obj.properties, prop => {
                    schemaLimitMaxItem(prop, max);
                })
            }

            if (obj.items && obj.items.properties) {
                _.forOwn(obj.items.properties, prop => {
                    schemaLimitMaxItem(prop, max);
                });
            }
        };

        const schemaSetArrayFormat = function (obj, type) {
            if (typeof(obj) !== 'object') return;
            if (obj && obj.type && obj.type === 'array') {
                obj.format = type;
            }

            if (obj.properties) {
                _.forOwn(obj.properties, prop => {
                    schemaSetArrayFormat(prop, type);
                })
            }

            if (obj.items && obj.items.properties) {
                _.forOwn(obj.items.properties, prop => {
                    schemaSetArrayFormat(prop, type);
                });
            }
        };

        // gen default value for schema to keep array editor show
        const getFieldDefaultValue = function (fieldSchema) {
            fieldSchema.type = fieldSchema.type || 'string';
            switch (fieldSchema.type) {
                case 'string':
                    return '';
                case 'boolean':
                    return 'true';
                case 'number':
                case 'integer':
                    return 0;
            }
        };

        const getDefaultSchemaValue = function (schema, ret) {
            if (schema.properties) {
                _.forOwn(schema.properties, (prop, propKey) => {
                    ret[propKey] = getDefaultSchemaValue(prop, {});
                });
                return ret;
            } else if (schema.items) {
                if (schema.items.properties) {
                    _.forOwn(schema.items.properties, (prop, propKey) => {
                        ret[propKey] = getDefaultSchemaValue(prop, {});
                    });
                    return [ret];
                } else {
                    return [getFieldDefaultValue(schema.items)];
                }
            } else {
                return getFieldDefaultValue(schema);
            }
        };

        me.loadContentConfig = function (contentConfig) {
            curContentConfig = contentConfig;
            console.log('json-schema-config-editor loadContentConfig');
            if (editor) {
                editor.destroy();
                editor = null;
            }

            schemaSetArrayFormat(curContentConfig, 'tabs');

            editor = new JSONEditor(me.editorElm, {
                schema:                    curContentConfig,
                theme:                     'bootstrap3',
                iconlib:                   'fontawesome4',
                disable_config:            false,
                disable_edit_json:         true,
                disable_hidden:            true,
                disable_add_more_than_one: true
            });
            let defaultValue = getDefaultSchemaValue(curContentConfig, {});
            console.log('DEFAULT VALUE', defaultValue);
//            for (let key in config) {
//                console.log('key', key);
//                if (!config.hasOwnProperty(key)) continue;
//                if (config[key] != undefined) {
//                    defaultValue[key] = config[key];
//                }
//            }

            editor.setValue(defaultValue);
        };

        me.getContentConfig = function () {
            console.log('TODO json-schema-config-editor getContentConfig');
            schemaSetArrayFormat(curContentConfig, 'table');
            return curContentConfig;
        };


    </script>
</json-schema-config-editor>
