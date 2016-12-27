<json-schema-config-editor style="height: calc(100% - 88px); overflow-y: auto;" onkeypress="{checkSave}">
    <div name="editorElm" class="bootstrap-iso" onkeypress="{checkSave}"></div>
    <script>
        var me = this;
        var editor, fieldSchemaEditor, curContentConfig;

        function getConfig(schema, configPath) {
            var parts = configPath.split('.');
            parts.shift(); // remove root
            var ret = schema;

            if (parts.some(function (key) {
                    if (!ret.properties) return false;
                    ret = ret.properties[key];
                    return typeof(config) !== 'object';
                })) {
                return ret;
            }
            return null;
        }

        me.on('mount', function () {
            var addedProperties = [];
            var removedProperties = [];

            window.showJsonSchemaConfigDialog = function (fieldType, options) {
                console.log('showJsonSchemaConfigDialog', 'fieldType', fieldType, 'options', options);
                fieldSchemaEditor.showConfigDialog(fieldType, options.path, function (newSchema) {
                    console.log('TODO reload schema gen new form');
                    curContentConfig = newSchema;
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
                console.log('jsonSchemaOnHideAddProperty fieldSchema', fieldSchema);
                removedProperties.forEach(function (name) {
                    console.log('remove', name);
                    delete fieldSchema.properties[name];
                });

                addedProperties.forEach(function (name) {
                    console.log('add', name, fieldSchema.properties[name]);
                    if (fieldSchema.properties[name] === undefined)
                        fieldSchema.properties[name] = {type: 'string', default: ''};
                });

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

        // gen default value for schema to keep array editor show
        const getFieldDefaultValue = function (fieldSchema) {
            fieldSchema.type = fieldSchema.type || 'string';
            switch (fieldSchema.type) {
                case 'string':
                    return '';
                case 'boolean':
                    return '';
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
                if (fieldSchemaEditor) fieldSchemaEditor.destroy();
            }

            fieldSchemaEditor = new JsonSchemaEditor(curContentConfig);

            schemaLimitMaxItem(curContentConfig, 1);
//            console.log('DEFAULT VALUE', getDefaultSchemaValue(curContentConfig, {}));
            editor = new JSONEditor(me.editorElm, {
                schema:            curContentConfig,
                theme:             'bootstrap3',
                iconlib:           'fontawesome4',
                disable_config:    false,
                disable_edit_json: true,
            });

            editor.setValue(getDefaultSchemaValue(curContentConfig, {}));
        };

        me.getContentConfig = function () {
            console.log('TODO json-schema-config-editor getContentConfig');
            return curContentConfig;
        };


    </script>
</json-schema-config-editor>
