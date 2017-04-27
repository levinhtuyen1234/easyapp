<monaco-editor style="margin-bottom: 0; padding: 0; height: calc(100% - 86px);">
    <div name="editorElm" class="editor" style="margin-right: 14px;width: 100%; height: 100%; background-color: #ffffff"></div>
    <tree-view-dialog></tree-view-dialog>

    <script>
        var me = this;
        var layoutName = '';
        var actions = [];

        const pathDelimiter = '.';

        function flatten(source, flattened = {}, keySoFar = '') {
            function getNextKey(key) {
                return `${keySoFar}${keySoFar ? pathDelimiter : ''}${key}`
            }

            if (typeof source === 'object') {
                if (keySoFar) flattened[keySoFar] = source;
                for (const key in source) {
                    if (!source.hasOwnProperty(key)) continue;
                    flatten(source[key], flattened, getNextKey(key));
                    if (Array.isArray(source)) return;
                }
            } else {
                flattened[keySoFar] = source
            }
            return flattened
        }

        var getJsonSchemaValue = function (key, value, ret) {
            if (!value.type) return;
            switch (value.type) {
                case 'object': {
                    if (!value.properties) return;
                    let child = {};
                    if (key === null || key === undefined)
                        ret = child;
                    else
                        ret[key] = child;
                    // chi add cac key ma` value co type la object hoac array
                    _.map(value.properties, (childValue, childKey) => {
                        getJsonSchemaValue(childKey, childValue, child);
                    });
                    break;
                }
                case 'array': {
                    if (value.items && value.items.type === 'object' && value.items.properties) {
                        var child = [];
                        getJsonSchemaValue(0, value.items, child);
                        ret[key] = child;
                        break;
                    }
                }
                case 'number':
                case 'integer':
                    ret[key] = 0;
                    break;
                default:
                    ret[key] = '';
                    break;
            }
            return ret;
        };

        function lookupDisplayName(schema, configPath) {
            var parts = configPath.split('.');
            parts.shift(); // remove root
            var ret = schema;

            if (parts.some(function (key) {
                    if (!ret.properties && !ret.items) {
                        return true;
                    }
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
                if (ret.title == undefined || ret.title == '')
                    return null;
                return ret.title;
            }
            return null;
        }

        me.refresh = function () {
//            me.editor.refresh();
//            console.log('monaco editor refresh');
            me.editor.layout();
        };

        me.removeAllActions = function () {
            actions.forEach(action => action.dispose());
        };

        me.setOption = function (name, value) {
//            me.editor.setOption(name, value);
        };

        function getReplacement(key, value) {
            let displayName = key;

            if (typeof(value) === 'object') {
                if (Array.isArray(value)) {
                    // array
                    let arrayItemKeys = [];
                    if (value.length > 0)
                        arrayItemKeys = Object.keys(value[0]);
                    let childSnippet = arrayItemKeys.reduce(function (ret, key) {
                        return ret + `    <div>{{${key}}}</div>\r\n`
                    }, '');
                    return `{{#each ${key}}}
${childSnippet}{{/each}}`;
                } else {
                    // object
                    let keys = Object.keys(value);
                    let childSnippet = keys.reduce(function (ret, key) {
                        return ret + `    <div>{{${key}}}</div>\r\n`
                    }, '');
                    return `{{#with ${key}}}
${childSnippet}{{/with}}`;
                }
            } else {
                return `{{${key}}}`;
            }
        }

        function setupActions() {
            if (!layoutName) return;
            // search content that use this layout
//            console.log('layoutName', layoutName);
            // remove .html from layoutName, add .schema.json
            let parts = layoutName.split('.');
            if (layoutName.endsWith('.html')) {
                parts.pop();
            }

            let contentConfigFileName = parts.join('.') + '.schema.json';
//            console.log('contentConfigFileName', contentConfigFileName);
//            let contents = _.filter(siteContentIndexes, {layout: layoutName});
            let content = siteContentConfigIndexes[contentConfigFileName];
//            console.log('content', content);
            // flatten all key in content
            if (content) {
                let contentSchemaValue = {};
                contentSchemaValue = getJsonSchemaValue(null, content, contentSchemaValue);
                let allContent = flatten(contentSchemaValue);
//                console.log('flatContent', allContent);

                // create data action
                // TODO lookup config for displayName of global content

                _.forOwn(allContent, (value, key) => {
                    var replacement = getReplacement(key, value);
                    actions.push(me.editor.addAction({
                            id:                 key,
                            label:              `:DATA] ${key}`,
                            keybindings:        null,
                            keybindingContext:  null,
                            contextMenuGroupId: null,
                            run:                function (ed) {
                                me.editor.executeEdits("", [{range: ed.getSelection(), text: replacement}]);
                                return null;
                            }
                        })
                    );
                });
            }

            // create partial action
            _.forOwn(sitePartialsIndexes, (value, key) => {
                actions.push(me.editor.addAction({
                        id:                 key,
                        label:              `:PARTIAL] ${key}`,
                        keybindings:        null,
                        keybindingContext:  null,
                        contextMenuGroupId: null,
                        run:                function (ed) {
                            me.editor.executeEdits("", [{range: ed.getSelection(), text: `{{> ${key} }}`}]);
                            return null;
                        }
                    })
                );
            });

            // create meta global action
            let flattenMeta = {};

            _.forOwn(siteGlobalConfigIndexes, function(schema, configFileName) {
                let parts = configFileName.split('.');
                if (configFileName.endsWith('.meta-schema.json')) {
                    parts.pop();
                    parts.pop();
                }
                configFileName = parts.join('.');
                let tmp = {};
                flattenMeta[configFileName] = getJsonSchemaValue(null, schema, tmp);
            });

            flattenMeta = flatten(flattenMeta);
            // TODO lookup config for displayName of global meta
            _.forOwn(flattenMeta, (value, key) => {
                var replacement = getReplacement(key, value);
                actions.push(me.editor.addAction({
                        id:                 key,
                        label:              `:META] ${key}`,
                        keybindings:        null,
                        keybindingContext:  null,
                        contextMenuGroupId: null,
                        run:                function (ed) {
                            me.editor.executeEdits("", [{range: ed.getSelection(), text: replacement}]);
                            return null;
                        }
                    })
                );
            });
        }

        me.value = function (value, language, layout) {
            if (value === undefined) {
                return me.editor.getValue();
            } else {
                // reload actions for layout
                me.removeAllActions();

                layoutName = layout;
                setupActions();
                switch (language) {
                    case 'handlebars':
                        monaco.editor.setModelLanguage(me.editor.getModel(), 'text/html');
                        break;
                    case 'javascript':
                        monaco.editor.setModelLanguage(me.editor.getModel(), 'javascript');
                        break;
                    case 'css':
                        monaco.editor.setModelLanguage(me.editor.getModel(), 'css');
                        break;
                    case 'frontmatter':
                        monaco.editor.setModelLanguage(me.editor.getModel(), 'markdown');
                        break;
                }

                me.editor.setValue(value);
                setTimeout(function () {
                    me.refresh();
                }, 10);

                // set tree-view-dialog value
                // lookup config in siteContentConfigIndexes of this layout
                let configFileName = (() => {
                    let parts = layout.split('.');
                    parts.pop();
                    return parts.join('.') + '.schema.json';
                })();
                let contentConfig = siteContentConfigIndexes[configFileName];
                if (contentConfig) {
                    me.tags['tree-view-dialog'].value(contentConfig);
                } else {
                    // find 1 content have this layout
                    contentConfig = BackEnd.createDefaultConfigFile(me.opts.siteName, layout);
//                    let contentFileName = _.findKey(siteContentIndexes, {layout: layout});
//                    if (createDefaultConfigFile)
                    // gen default content config
//                    contentConfig = BackEnd.getConfigFile(me.opts.siteName, contentFilePath, layout);
                    me.tags['tree-view-dialog'].value(contentConfig);
//                    console.log('NOT found content config', contentFileName);
                }

            }
        };

        me.focus = function () {
            if (me.editor) {
                me.editor.focus();
            }
        };

        // ugly split case code
        me.addField = function (dstType, fileName, fieldName, parentFieldConfig, updatedSchema, objectPath) {
            let curSelection = me.editor.getSelection();

            // lay selected text set as default value of fieldConfig in case of text field
            let selectedValue = me.editor.getModel().getValueInRange(curSelection);
            if (!selectedValue) selectedValue = '';
            if (parentFieldConfig.type === 'array') {
                parentFieldConfig.items.properties[fieldName]['default'] = selectedValue;
            } else {
                parentFieldConfig.properties[fieldName]['default'] = selectedValue;
            }

            // luu schema vao dia
            if (dstType == 'content') {
                BackEnd.saveConfigFile(me.opts.siteName, layoutName, JSON.stringify(updatedSchema, null, 4));

                // replace cur selected text bang snippet
                // remove 'root' from objectPath
                objectPath = (() => {
                    let parts = objectPath.split('.');
                    parts.shift();
                    return parts.join('.');
                })();
                let replacement = objectPath == '' ? fieldName : `${objectPath}.${fieldName}`;
                me.editor.executeEdits("", [{range: curSelection, text: `{{${replacement}}}`}]);

                // insert new field to all content affected
                // TODO change value based on content type
                let contents = _.filter(siteContentIndexes, {layout: layoutName});
                console.log('contents affected', contents, 'replacement', replacement);
                _.forEach(contents, content => {
                    let props = replacement.split('.');
                    let lastProp = props.pop();
                    let current = content;
                    while (props.length) {
                        if (typeof current !== 'object') break;
                        current = current[props.shift()];
                    }
                    if (current && typeof current == 'object') {
                        console.log('update lastProp success, lastProp', lastProp);
                        current[lastProp] = ''; // TODO other value type (object ?)
                    }
                });

                // update schema trong index
                let configFileName = (() => {
                    let parts = layoutName.split('.');
                    parts.pop();
                    return parts.join('.') + '.schema.json';
                })();
                siteContentConfigIndexes[configFileName] = updatedSchema;
            } else if (dstType == 'globalMeta') {
                BackEnd.saveMetaConfigFile(me.opts.siteName, fileName, JSON.stringify(updatedSchema, null, 4));
                // add place holder in editor
                me.editor.executeEdits("", [{range: curSelection, text: `{{${objectPath}.${fieldName}}}`}]);
                // update schema trong index
                console.log('update schema trong index', 'fileName', fileName, updatedSchema);
                siteGlobalConfigIndexes[fileName] = updatedSchema;
            } else {
                return;
            }

            // reload actions
            me.removeAllActions();
            setupActions();
        };

        let onCreateNewPartial = function () {
            let curSelection = me.editor.getSelection();
            let curSelectionText = me.editor.getModel().getValueInRange(curSelection);

            if (curSelectionText == '') return;
            bootbox.prompt("New partial name", function (newPartialName) {
                if (newPartialName == null) return;
                BackEnd.savePartialFile(me.opts.siteName, newPartialName, curSelectionText);
                // update cache index
                sitePartialsIndexes[newPartialName] = true;
                // add replacement text
                me.editor.executeEdits("", [{range: curSelection, text: `{{> ${newPartialName} }}`}]);
                // reload actions
                me.removeAllActions();
                setupActions();
            });
        };

        me.on('mount', function () {
            me.editor = monaco.editor.create(me.editorElm, {
                value:    '',
                language: 'text/html',
                folding:  false,

                lineNumbers:          true,
                roundedSelection:     true,
                scrollBeyondLastLine: true,
                trimAutoWhitespace:   true,
                readOnly:             false,
                theme:                'vs-light'
            });

            me.editor.addCommand(monaco.KeyMod.CtrlCmd | monaco.KeyCode.KEY_S, function () {
                riot.event.trigger('codeEditor.save');
            });

            me.editor.addCommand(monaco.KeyCode.F2, function () {
                me.tags['tree-view-dialog'].show();
            });

            me.editor.addCommand(monaco.KeyCode.F3, onCreateNewPartial);

            window.testEditor = me.editor;

            me.editor.addCommand(monaco.KeyMod.CtrlCmd | monaco.KeyMod.Alt | monaco.KeyCode.KEY_F, function (ev) {
                me.editor.getAction('editor.action.format').run();
            });
        })
    </script>
    <style>

    </style>
</monaco-editor>
