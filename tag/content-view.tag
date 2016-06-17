<content-view>
    <div id="form-editor"></div>
    <div id="markdown-editor"></div>
    <script>
        var me = this;

        me.formEditor = null;
        me.markdownEditor = null;

        var FORM_START = '---json';
        var FORM_END = '---';
        function SplitContentFile(fileContent) {
            var start = fileContent.indexOf(FORM_START);
            if (start == -1) return null;
            start += FORM_START.length;

            var end = fileContent.indexOf(FORM_END, start);
            if (end == -1) return null;

            return {
                metaData:     fileContent.substr(start, end - start).trim(),
                markDownData: fileContent.substr(end + FORM_END.length).trim()
            }
        }

        me.on('mount', function(){
            me.markdownEditor = riot.mount('#markdown-editor', 'markdown-editor')[0];
//            console.log('content-view', opts.filePath);
            var fileContent = BackEnd.getFileContent(opts.filePath);
            fileContent = fileContent.trim();
            if (fileContent === null) return;
            var content = SplitContentFile(fileContent);
            console.log('mount fileContent', content);
            console.log("me.tags['markdown-editor']", me.markdownEditor);
            me.markdownEditor.value(content.markDownData);

//            me.formEditor = riot.mount('#content-form-editor', 'form-editor')[0];
//
//            me.codeEditor = riot.mount('#content-code-editor', 'code-editor')[0];
//            me.codeEditor.value(content.metaData);
//            me.codeEditor.setOption('readOnly', true);

//            $(me.root).find('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
//                if (e.target.dataset.name === 'raw') {
//                    me.codeEditor.refresh();
//                }
//            })
        });
    </script>
</content-view>
