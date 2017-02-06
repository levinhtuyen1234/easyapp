<monaco-editor style="margin-bottom: 0; padding: 0; height: calc(100% - 86px);">
    <div name="editorElm" class="editor" style="margin-right: 14px;width: 100%; height: 100%; background-color: #ffffff"></div>

    <script>
        var me = this;

        me.refresh = function () {
//            me.editor.refresh();
            console.log('monaco editor refresh');
            me.editor.layout();
        };

        me.setOption = function (name, value) {
//            me.editor.setOption(name, value);
        };

        me.value = function (value, language) {
            if (value === undefined) {
//                console.log('monaco editor getValue');
                return me.editor.getValue();
            } else {
//                console.log('monaco editor setValue', value);
                switch (language) {
                    case 'handlebars':
                        console.log('set language handlebars');
                        monaco.editor.setModelLanguage(me.editor.getModel(), 'handlebars');
                        break;
                    case 'frontmatter':
                        monaco.editor.setModelLanguage(me.editor.getModel(), 'json');
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
