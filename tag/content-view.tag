<content-view stype="height:600px; overflow-x:scroll ; overflow-y: scroll;">
    <form-editor site-name="{siteName}"></form-editor>
    <label class="col-sm-12 control-label" style="text-align: left;">Content</label>
    <markdown-editor site-name="{siteName}"></markdown-editor>
    <script>
        var me = this;

        me.formEditor = null;
        me.markdownEditor = null;
        me.siteName = me.opts.siteName;

        me.setContent = function (content, contentConfig) {
//            console.log('me.tags', me.tags);
//            console.log('contentConfig', contentConfig);
            // gen content form
            me.tags['form-editor'].genForm(content.metaData, contentConfig);
            // set markdown editor content
//            setTimeout(function () {
                me.tags['markdown-editor'].setValue(content.markDownData);
//            }, 1);
        };

        me.reset = function () {
            me.tags['form-editor'].clear();
            me.tags['markdown-editor'].setValue('');
        };

        me.getContent = function () {
            return {
                metaData:     me.tags['form-editor'].getForm(),
                markdownData: me.tags['markdown-editor'].getValue()
            };
        }
    </script>
</content-view>
