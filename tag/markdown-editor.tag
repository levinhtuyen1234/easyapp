<markdown-editor>
    <div class="markdown-editor-wrapper">
        <textarea style="display:none"></textarea>
    </div>

    <script>
        var me = this;
        me.value = me.opts.value || '';
        me.editor = null;
        me.viewOnly = me.opts.viewonly;
        var loaded = false;
        var height = me.opts.height || '480px';
        var toolbarIcons = me.opts.toolbarIcons || (function () {
                    return [
                        "undo", "redo", "|",
                        "bold", "del", "italic", "quote", "ucwords", "uppercase", "lowercase", "|",
                        "h1", "h2", "h3", "h4", "h5", "h6", "|",
                        "list-ul", "list-ol", "hr", "|",
                        "link", "reference-link", "image", "code", "table", "datetime", "html-entities", "pagebreak", "|",
                         "watch", "preview"
                    ];
                });

        var id = Math.random().toString(36).substr(2, 9);

        me.on('mount', function () {
            me.root.querySelector('.markdown-editor-wrapper').setAttribute('id', id);
//            var config = {
//                element:                 me.root.querySelector('textarea'),
//                autoDownloadFontAwesome: false,
//                spellChecker:            false,
//                codeSyntaxHighlighting:  true
//            };
//
//            me.editor = new SimpleMDE(config);
            me.editor = editormd(id, {
                width:           '100%',
                height:          height,
                flowChart:       true,
                sequenceDiagram: true,
                readOnly:        me.viewOnly,
                imageUpload:     false,
                watch:           true,
                markdown:        me.value,
                placeholder:     "",
                path:            'assets/js/lib/',
                imageFormats:    ["jpg", "jpeg", "gif", "png", "bmp", "webp"],
                imageUploadURL:  "./php/upload.php?test=dfdf",
                toolbarIcons:    toolbarIcons,
                onload:          function () {
                    loaded = true;
                    me.setValue(me.value);
                }
            });

            $(me.root).keypress(function (event) {
                if (!(event.which == 115 && event.ctrlKey) && !(event.which == 19)) return true;
                riot.api.trigger('codeEditor.save');
                event.preventDefault();
                return false;
            });

//            if (me.viewOnly) {
//                setTimeout(function () {
//                    me.editor.togglePreview();
//                    me.root.querySelector('.editor-toolbar').style.display = 'none';
//                }, 1);
//            }
        });

        me.getValue = function () {
            return me.editor.getMarkdown();
        };

        me.setValue = function (val) {
            if (me.editor) {
                if (loaded) {
                    me.editor.setValue(val);
                } else {
                    me.value = val;
                }
            }
        };
    </script>
</markdown-editor>
