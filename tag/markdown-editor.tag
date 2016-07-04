<markdown-editor>
    <textarea></textarea>
    <script>
        var me = this;
        me.editor = null;

        me.on('mount', function () {
//            console.log('markdown editor mount');
            me.editor = new SimpleMDE({
                element:                 me.root.querySelector('textarea'),
                autoDownloadFontAwesome: false,
                spellChecker:            false,
                codeSyntaxHighlighting:  true
            });
        });

        me.value = function (val) {
            if (val === undefined)
                return me.editor.value();
            me.editor.value(val);
        };
    </script>
</markdown-editor>
