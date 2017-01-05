<json-schema-form-editor>
    <div name="editorElm" class="bootstrap-iso" onkeypress="{checkSave}"></div>

    <script>
        var me = this;
        var editor;
        me.siteName = me.opts.siteName;

        me.on('mount', function () {

        });

        me.on('unmount', function () {

        });

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

        me.checkSave = function (e) {
            // check ctrl + S -> save
            if (!(e.which == 115 && e.ctrlKey) && !(e.which == 19)) return true;
            console.log('Ctrl-S pressed');
//            console.log('me.getForm', me.getForm());
            riot.event.trigger('codeEditor.save');
//            console.log('SAVE', me.getForm());
            e.preventDefault();
            return false;
        };

        me.getForm = function () {
            return editor.getValue();
        };

        me.clear = function () {
//            editor.setValue({});
            editor.destroy();
        };

        me.genForm = function (metaData, contentConfig) {
            console.log('GENFORM, metaData', metaData);
            if (editor) {
                editor.destroy();
                editor = null;
            }
            editor = new JSONEditor(me.editorElm, {
                schema:             contentConfig,
                theme:              'bootstrap3',
                iconlib:            'fontawesome4',
                disable_hidden:     false,
                disable_edit_json:  true,
                disable_properties: true,
                disable_config:     true,
                upload:                    function (filePath, file, callback) {
//                    console.log('start upload', filePath, file);
//                    if (!filePaths || filePaths.length != 1) return;
//                    var filePath = filePaths[0];
                    console.log('me.siteName', me.siteName, 'filePath', filePath, 'file', file);
                    BackEnd.addMediaFile(me.siteName, file.path, function (error, relativePath) {
                        if (error) {
                            console.log('addMediaFile', error);
                        } else {
                            callback.success(relativePath);
                        }
                    });
                }
            });

            let defaultValue = getDefaultSchemaValue(contentConfig, {});
            let mergedMetaData = _.merge(defaultValue, metaData);
            console.log('mergedMetaData',mergedMetaData);

            editor.setValue(mergedMetaData);
        }
    </script>
</json-schema-form-editor>
