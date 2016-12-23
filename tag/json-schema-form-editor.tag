<json-schema-form-editor>
    <div name="editorElm" class="bootstrap-iso" onkeypress="{checkSave}"></div>

    <script>
        var me = this;
        var editor;

        me.on('mount', function () {

        });

        me.on('unmount', function () {

        });

        me.checkSave = function (e) {
            // check ctrl + S -> save
            if (!(e.which == 115 && e.ctrlKey) && !(e.which == 19)) return true;
            console.log('Ctrl-S pressed');
//            console.log('me.getForm', me.getForm());
            riot.event.trigger('codeEditor.save');
//            console.log('SAVE', me.getForm());
            e.preventDefault();
            return false;
        };

        me.getForm = function () {
            return editor.getValue();
        };

        me.clear = function () {
//            editor.setValue({});
            editor.destroy();
        };

        me.genForm = function (metaData, contentConfig) {
            console.log('GENFORM');
            if (editor) {
                editor.destroy();
                editor = null;
            }
            editor = new JSONEditor(me.editorElm, {
                schema:             contentConfig,
                theme:              'bootstrap3',
                iconlib:            'fontawesome4',
                disable_edit_json:  true,
                disable_properties: true,
                disable_config:     true
            });
            editor.setValue(metaData);
        }
    </script>
</json-schema-form-editor>
