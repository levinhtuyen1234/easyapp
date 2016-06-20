<content-view>
    <form-editor></form-editor>
    <markdown-editor></markdown-editor>
    <script>
        var me = this;

        me.formEditor = null;
        me.markdownEditor = null;

        me.setContent = function(content, contentConfig) {
            console.log('me.tags', me.tags);
//            console.log('contentConfig', contentConfig);
            // gen form
            me.tags['form-editor'].genForm(content.metaData, contentConfig);
            // set markdown editor content
            me.tags['markdown-editor'].value(content.markDownData);
        };
    </script>
</content-view>
