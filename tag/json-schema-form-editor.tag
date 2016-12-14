<json-schema-form-editor>
    <div name="editorElm" class="bootstrap-iso"></div>

    <script>
        var me = this;

        me.on('mount', function () {

        });

        me.on('unmount', function () {

        });

        me.genForm = function (metaData, contentConfig) {
            console.log('GENFORM');
            var editor = new JSONEditor(me.editorElm, {
                schema:  contentConfig,
                theme:   'bootstrap3',
                iconlib: 'fontawesome4'
//                theme: 'semanticui'
            });
            editor.setValue(metaData);
        }
    </script>
</json-schema-form-editor>
