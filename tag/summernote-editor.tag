<summernote-editor>
    <div class="bootstrap-iso">
        <div name="summerNote"></div>
    </div>

    <script>
        var me = this;
        me.value = me.opts.value || '';
        me.editor = null;
        me.viewOnly = me.opts.viewonly;

        me.on('mount', function () {

            console.log('me.summerNote', me.summerNote);
            me.editor = $(me.summerNote).summernote({
                minHeight: 200,
                focus:     false
            });

            console.log('me.editor', me.editor);
            me.editor.summernote('code', me.value);

            if (me.viewOnly)
                me.editor.summernote('disable');

            $(me.root.querySelector('.note-editable.panel-body')).keypress(function (event) {
                if (!(event.which == 115 && event.ctrlKey) && !(event.which == 19)) return true;
                riot.event.trigger('codeEditor.save');
                event.preventDefault();
                return false;
            });
        });

        me.on('unmount', function () {
            if (me.editor && me.editor.summernote)
                me.editor.summernote('destroy');
        });

        me.getValue = function () {
            return me.editor.summernote('code');
        };

        me.setValue = function (val) {
            me.editor.summernote('code', val);
        };
    </script>
</summernote-editor>
