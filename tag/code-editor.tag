<code-editor>
    <h3 class="text-success">(?) Sửa nhanh dành cho Front-end Developers</h3>
    <p><span class="text-danger">Raw:</span> sử dụng cú pháp Json để định nghĩa cấu trúc dữ liệu</p>
    <p><span class="text-danger">Layout:</span> sử dụng HTML, CSS, JS và thư viện <a target="_blank" href="http://handlebarsjs.com/">HandlebarJS</a> để định nghĩa layout</p>
    <div class="CodeMirror" style="border: 1px; padding: 0 0 15px 0;"></div>
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
                foldGutter:              false,
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
                        riot.api.trigger('codeEditor.save');
                    }
                }
            });
//            me.editor.click();
//            console.log('me.editor', me.editor);
//            me.editor.setSize('100%', window.innerHeight - 220);
        });
    </script>
</code-editor>
