<code-editor style="margin: 0; padding: 0;">
    <div class="CodeMirror" style="border: none; margin: 0; height: calc(100vh - 160px);"></div>
    <script>
        var me = this;
        me.editor = null;

        me.refresh = function () {
            me.editor.refresh();
        };

        me.setOption = function (name, value) {
            me.editor.setOption(name, value);
        };

        me.value = function (value) {
            if (value === undefined) {
                return me.editor.getValue();
            } else {
                me.editor.setValue(value);

                setTimeout(function () {
                    me.editor.refresh();
                }, 10);
            }
        };

        me.on('mount', function () {
            var editorElm = me.root.querySelector('.CodeMirror');
            me.editor = CodeMirror(editorElm, {
                value:                   me.opts.content ? me.opts.content : '',
                rtlMoveVisually:         false,
                showCursorWhenSelecting: false,
                lineWrapping:            true,
                lineNumbers:             true,
                fixedGutter:             true,
                foldGutter:              true,
                matchBrackets:           true,
                styleActiveLine:         true,
                gutter:                  true,
                readOnly:                false,
                lint:                    true,
//                theme:                   'material',
                gutters:                 ['CodeMirror-linenumbers', 'CodeMirror-lint-markers'],
                mode:                    'handlebars',
//                mode:                    'mixedMode',
                firstLineNumber:         1,
                indentUnit:              4,
                extraKeys:               {
                    'Ctrl-Space': 'autocomplete',
                    'Ctrl-R':     'replace',
                    'Ctrl-S':     function () {
//                        parent.saveFile(editor.getValue());
//                        alert('Nop, not implemented yet')
                        riot.event.trigger('codeEditor.save');
                    }
                }
            });
//            me.editor.click();
//            console.log('me.editor', me.editor);
            me.editor.setSize('100%', window.innerHeight - 100);
        });
    </script>
</code-editor>
