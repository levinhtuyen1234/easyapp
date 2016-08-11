<code-editor>
    <h3 class="text-success">(?) Editor for designers and developers</h3>
    <p><span class="text-danger">Raw Form:</span> nội dung thực của Content files (md), front-matter sử dụng cú pháp Json để định nghĩa cấu trúc dữ liệu
   <br/><span class="text-danger">Layout Form:</span> nội dung của Layout files, chứa HTML, CSS, JS và cú pháp <a target="_blank" href="http://handlebarsjs.com/">HandlebarJS</a> để binding dữ liệu</p>
    <div class="CodeMirror" style="border: 0.1px; padding: 0px; margin-left:-15px; margin-right:-15px; margin-bottom:-15px;"></div>
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
