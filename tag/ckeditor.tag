<ckeditor>
    <textarea ref="ckeditorInput" style="display:none"></textarea>

    <script>
        var me = this;
        me.value = me.opts.value || '';
        me.editor = null;
        me.viewOnly = me.opts.viewonly;

        var defaultToolbarGroups = [
            {name: 'clipboard', groups: ['clipboard', 'undo']},
            {name: 'links'},
            {name: 'insert'},
            {name: 'document', groups: ['mode', 'document', 'doctools']},
            '/',
            {name: 'basicstyles', groups: ['basicstyles', 'cleanup']},
            {name: 'paragraph', groups: ['list', 'indent', 'blocks', 'align', 'bidi']},
            {name: 'styles'},
            {name: 'colors'}
        ];
        me.toolbarGroups = me.opts.toolbarGroups || defaultToolbarGroups;

        me.on('mount', function () {
            var ckeditorElm = $(me.root).find('[ref="ckeditorInput"]');
            me.editor = $(ckeditorElm).ckeditor({
                toolbarGroups: me.toolbarGroups
            });
        });

        me.on('unmount', function () {
            try {
                CKEDITOR.instances[me.editor[0].name].destroy(false);
            } catch (err) {
                console.log('unmount ckeditor error', err);
            }
        });

        me.getValue = function () {
            if (!me.editor) return '';
            return me.editor.val();
        };

        me.setValue = function (val) {
            if (!me.editor) return;
            me.editor.val(val);
        };
    </script>

    <style>

    </style>
</ckeditor>
