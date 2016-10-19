<code-editor style="margin-bottom: 0; padding: 0; height: calc(100% - 86px); overflow-y: scroll;">
    <div class="CodeMirror" style="border: none; margin: 0; height: 100%"></div>
    <script>
        var me = this;
        var editorElm = me.root.querySelector('div.CodeMirror');


        me.refresh = function () {
            me.editor.refresh();
        };

        me.setOption = function (name, value) {
            me.editor.setOption(name, value);
        };

        me.value = function (value) {
//            console.log('code editor setvalue', value);
            if (value === undefined) {
                return me.editor.getValue();
            } else {
                console.log('me.editor.setValue');
                me.editor.setValue(value);

                setTimeout(function () {
                    me.editor.refresh();
                }, 10);
            }
        };

        me.on('mount', function () {
            if (me.opts.dataTab == "layout-view") {
                window.layoutView = me;
            } else {
                window.codeView = me;
            }
            me.editor = CodeMirror(me.root.querySelector('div.CodeMirror'), {
                value:                   me.opts.content ? me.opts.content : '',
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
                scrollPastEnd:           true,
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
            me.editor.setSize('100%', '100%');
        });
    </script>
</code-editor>
