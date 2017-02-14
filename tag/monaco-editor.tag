<monaco-editor style="margin-bottom: 0; padding: 0; height: calc(100% - 86px);">
    <div name="editorElm" class="editor" style="margin-right: 14px;width: 100%; height: 100%; background-color: #ffffff"></div>

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
                    flatten(source[key], flattened, getNextKey(key))
                }
            } else {
                flattened[keySoFar] = source
            }
            return flattened
        }

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
            console.log('monaco editor refresh');
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
                    let childSnippet = arrayItemKeys.reduce(function(ret, key) {
                        return ret + `    <div>{{${key}}}</div>\r\n`
                    }, '');
                    return `{{#each ${key}}}
${childSnippet}{{/each}}`;
                } else {
                    // object
                    let keys = Object.keys(value);
                    let childSnippet = keys.reduce(function(ret, key) {
                        return ret + `    <div>{{${key}}}</div>\r\n`
                    }, '');
                    return `{{#with ${key}}}
${childSnippet}{{/with}}`;
                }
            } else {
                return `{{${key}}}`;
            }
        }

        me.value = function (value, language, layout) {
            if (value === undefined) {
                return me.editor.getValue();
            } else {
                // reload actions for layout
                if (layoutName == '' || layoutName != layout) {
                    me.removeAllActions();

                    layoutName = layout;
                    // search content that use this layout
                    let contents = _.filter(siteContentIndexes, {layout: layoutName});
                    // flatten all key in content
                    let allContent = {};
                    _.forEach(contents, content => {
                        let flatContent = flatten(content);
                        _.assign(allContent, flatContent);
                    });

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

                    // create partial action
                    _.forOwn(sitePartialsIndexes, (value, key) => {
                        actions.push(me.editor.addAction({
                                id:                 key,
                                label:              `:PARTIAL] ${key}`,
                                keybindings:        null,
                                keybindingContext:  null,
                                contextMenuGroupId: null,
                                run:                function (ed) {
                                    me.editor.executeEdits("", [{range: ed.getSelection(), text: `{{>  ${key}}}`}]);
                                    return null;
                                }
                            })
                        );
                    });

                    // create meta global action
                    var flattenMeta = flatten(siteGlobalMetaIndexes);
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
                switch (language) {
                    case 'handlebars':
                        console.log('set language handlebars');
                        monaco.editor.setModelLanguage(me.editor.getModel(), 'text/html');
                        break;
                    case 'frontmatter':
                        monaco.editor.setModelLanguage(me.editor.getModel(), 'markdown');
                        break;
                }
                me.editor.setValue(value);
                setTimeout(function () {
                    me.refresh();
                }, 10);

//                setTimeout(function () {
//                    me.editor.refresh();
//                }, 10);
            }
        };

        me.on('mount', function () {
            me.editor = monaco.editor.create(me.editorElm, {
                value:    '',
                language: 'text/html',

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

            window.testEditor = me.editor;

            me.editor.addCommand(monaco.KeyMod.CtrlCmd | monaco.KeyMod.Alt | monaco.KeyCode.KEY_F, function (ev) {
                me.editor.getAction('editor.action.format').run();
            });
        })
    </script>
    <style>

    </style>
</monaco-editor>
