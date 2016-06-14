<code-editor id="{opts.id}" role="tabpanel" class="tab-pane {opts.active ? 'active':''}">
    <div class="code-editor" style="border: 1px; padding: 5px;"></div>
    <script>
        var me = this;
        me.editor = null;

        me.setValue = function (content) {
            me.editor.setValue(content);
        };

        me.refresh = function () {
            me.editor.refresh();
        };

        window.onresize = function (e) {
            me.editor.setSize('100%', window.innerHeight - 120);
        };

        me.setOption = function(name, value) {
            me.editor.setOption(name, value);
        };

        me.on('mount', function () {
            var editorElm = me.root.querySelector('.code-editor');
            me.editor = CodeMirror(editorElm, {
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
                theme:                   'material',
                gutters:                 ['CodeMirror-linenumbers', 'CodeMirror-lint-markers'],
//                mode:                    {name: "javascript", json: true},
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
            me.editor.setSize('100%', window.innerHeight - 180);
        });
    </script>
</code-editor>
