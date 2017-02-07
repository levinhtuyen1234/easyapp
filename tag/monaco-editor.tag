<monaco-editor style="margin-bottom: 0; padding: 0; height: calc(100% - 86px);">
    <div name="editorElm" class="editor" style="margin-right: 14px;width: 100%; height: 100%; background-color: #ffffff"></div>

    <script>
        var me = this;
        var layoutName = '';
        var actions = [];

        //        editor.addAction({
        //            id: 'my-unique-id',
        //            label: '[DATA] Test Label',
        //            keybindings: null,
        //            keybindingContext: null,
        //            contextMenuGroupId: null,
        //            run: function(ed) {
        //                console.log(ed.getSelection());
        //                editor.executeEdits("", [
        //                    { range: ed.getSelection(), text: "prepend" }
        //                ]);
        //                return null;
        //            }
        //        });
        const pathDelimiter = '.';

        function flatten(source, flattened = {}, keySoFar = '') {
            function getNextKey(key) {
                return `${keySoFar}${keySoFar ? pathDelimiter : ''}${key}`
            }

            if (typeof source === 'object') {
                for (const key in source) {
                    if (!source.hasOwnProperty(key)) continue;
                    flatten(source[key], flattened, getNextKey(key))
                }
            } else {
                flattened[keySoFar] = source
            }
            return flattened
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

        me.value = function (value, language, layout) {
            if (value === undefined) {
//                console.log('monaco editor getValue');
                return me.editor.getValue();
            } else {
//                console.log('monaco editor setValue', value);
                // TODO truong hop layout for category, tag ?
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
                    // create action
                    _.forOwn(allContent, (value, key) => {
                        actions.push(me.editor.addAction({
                                id:                 key,
                                label:              `[DATA] ${key}`,
                                keybindings:        null,
                                keybindingContext:  null,
                                contextMenuGroupId: null,
                                run:                function (ed) {
                                    me.editor.executeEdits("", [
                                        {range: ed.getSelection(), text: `{{${key}}}`}
                                    ]);
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

            window.testEditor = me.editor;

            me.editor.addCommand(monaco.KeyMod.CtrlCmd | monaco.KeyMod.Alt | monaco.KeyCode.KEY_F, function (ev) {
                me.editor.getAction('editor.action.format').run();
            });
        })
    </script>
    <style>

    </style>
</monaco-editor>
