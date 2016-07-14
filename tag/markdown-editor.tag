<markdown-editor>
    <textarea></textarea>
    <script>
        var me = this;
        me.value = me.opts.value || '';
        me.editor = null;
        me.viewOnly = me.opts.viewonly;

        me.on('mount', function () {
            var config = {
                element:                 me.root.querySelector('textarea'),
                autoDownloadFontAwesome: false,
                spellChecker:            false,
                codeSyntaxHighlighting:  true
            };

            me.editor = new SimpleMDE(config);

            if (me.viewOnly) {
                setTimeout(function () {
                    me.editor.togglePreview();
                    me.root.querySelector('.editor-toolbar').style.display = 'none';
                }, 1);
            }
        });

        me.value = function (val) {
            if (val === undefined)
                return me.editor.value();

            me.editor.value(val);
        };
    </script>
</markdown-editor>
