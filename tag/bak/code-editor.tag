<code-editor role="tabpanel" class="tab-pane {opts.active ? 'active':''}" style="width: 100%;">
    <div class="code-editor" style="border: 1px; padding: 0 0 15px 0;"></div>
    <script>
        var me = this;
        var editor;

        me.refresh = function () {
            editor.refresh();
        };

        //        window.onresize = function (e) {
        //            if (editor)
        //                editor.setSize('100%', window.innerHeight - 120);
        //        };

        me.setOption = function (name, value) {
            editor.setOption(name, value);
        };

        me.value = function (value) {
            if (value === undefined) {
                return editor.getValue();
            } else {
                editor.setValue(value);
            }
        };

        me.on('mount', function () {
            var editorElm = me.root.querySelector('.code-editor');
            editor = CodeMirror(editorElm, {
                value:                   '',
                rtlMoveVisually:         false,
                showCursorWhenSelecting: false,
                lineWrapping:            true,
                lineNumbers:             true,
                fixedGutter:             true,
                foldGutter:              false,
                matchBrackets:           true,
                styleActiveLine:         true,
                gutter:                  true,
                readOnly:                false,
                lint:                    true,
//                theme:                   'material',
                gutters:                 ['CodeMirror-linenumbers', 'CodeMirror-lint-markers'],
                mode:                    {name: "javascript", json: true},
                firstLineNumber:         1,
                indentUnit:              4,
                extraKeys:               {
                    'Ctrl-Space': 'autocomplete',
                    'Ctrl-R':     'replace',
                    'Ctrl-S':     function () {
//                        parent.saveFile(editor.getValue());
                        alert('Nop, not implemented')
                    }
                }
            });
//            editor.setSize('100%', window.innerHeight - 180);
        });
    </script>
</code-editor>
