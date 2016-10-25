<markdown-editor>
    <div class="markdown-editor-wrapper">
        <textarea style="display:none"></textarea>
    </div>

    <script>
        var me = this;
        me.value = me.opts.value || '';
        me.editor = null;
        me.viewOnly = me.opts.viewonly;

        var status = me.opts.status ? !(me.opts.status == 'false') : true;
        var height = me.opts.height || '300px';
        //        var toolbarIcons = me.opts.toolbarIcons || (function () {
        //                    return [
        //                        "undo", "redo", "|",
        //                        "bold", "del", "italic", "quote", "ucwords", "uppercase", "lowercase", "|",
        //                        "h1", "h2", "h3", "h4", "h5", "h6", "|",
        //                        "list-ul", "list-ol", "hr", "|",
        //                        "link", "reference-link", "image", "code", "table", "datetime", "html-entities", "pagebreak", "|",
        //                        "watch", "preview"
        //                    ];
        //                });

        var id = Math.random().toString(36).substr(2, 9);

        me.on('mount', function () {
            me.root.querySelector('.markdown-editor-wrapper').setAttribute('id', id);
            var config = {
                element:                 me.root.querySelector('textarea'),
                autoDownloadFontAwesome: false,
                spellChecker:            false,
                codeSyntaxHighlighting:  true,
                showIcons:               ['heading-1', 'link', 'image', "code", "table"],
                insertTexts:             {
                    horizontalRule: ["", "\n\n-----\n\n"],
                    image:          ["![](http://", ")"],
                    link:           ["[", "](http://)"],
                    table:          ["", "\n\n| Column 1 | Column 2 | Column 3 |\n| -------- | -------- | -------- |\n| Text     | Text      | Text     |\n\n"]
                }
            };
            if (!status) config.status = false;

            me.editor = new SimpleMDE(config);
//            me.editor = editormd(id, {
//                width:            '100%',
//                height:           height,
//                flowChart:        true,
//                sequenceDiagram:  true,
//                toolbarAutoFixed: false,
//                readOnly:         me.viewOnly,
//                imageUpload:      false,
//                watch:            true,
//                htmlDecode:       "style,script,iframe",
//                markdown:         me.value,
//                placeholder:      "",
//                path:             'assets/js/lib/',
//                imageFormats:     ["jpg", "jpeg", "gif", "png", "bmp", "webp"],
////                imageUploadURL:   "./php/upload.php?test=dfdf",
//                toolbarIcons:     toolbarIcons,
//                onload:           function () {
////                    loaded = true;
////                    me.setValue(me.value);
//                }
//            });

            $(me.root).keypress(function (event) {
                if (!(event.which == 115 && event.ctrlKey) && !(event.which == 19)) return true;
                riot.event.trigger('codeEditor.save');
                event.preventDefault();
                return false;
            });

            if (me.viewOnly) {
                setTimeout(function () {
                    me.editor.togglePreview();
                    me.root.querySelector('.editor-toolbar').style.display = 'none';
                }, 1);
            }
        });

        me.getValue = function () {
//            return me.editor.getMarkdown();
            return me.editor.value();
        };

        me.setValue = function (val) {
            if (me.editor) {
//                if (loaded) {
//                console.log('setValue val', val);
                me.editor.value(val);
//                } else {
//                    me.value = val;
//                }
            }
        };
    </script>
</markdown-editor>
