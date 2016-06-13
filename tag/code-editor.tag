<code-editor id="{opts.id}" role="tabpanel" class="tab-pane {opts.active ? 'active':''}">
    <div class="code-editor"></div>
    <script>
        var me = this;
        var editor;

        me.setValue = function (content) {
            editor.setValue(content);
        };

        me.refresh = function () {
            editor.refresh();
        };

        window.onresize = function (e) {
            editor.setSize('100%', window.innerHeight - 120);
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
                theme:                   'material',
                gutters:                 ['CodeMirror-linenumbers'],
                mode:                    'javascript',
                firstLineNumber:         1,
                indentUnit:              4,
                extraKeys:               {
                    'Ctrl-Space': 'autocomplete',
                    'Ctrl-R':     'replace',
                    'Ctrl-S':     function () {
//                        parent.saveFile(editor.getValue());
                        alert('Nop, read')
                    }
                }
            });
            editor.setSize('100%', window.innerHeight - 120);
        });
    </script>
</code-editor>
