<content-view class="ui tab segment active simplebar" style="height: calc(100% - 88px); padding-left: 10px; padding-right: 20px; padding-top: 5px; overflow-y: scroll">
    <form-editor site-name="{siteName}"></form-editor>

    <div class="ui form" style="padding-top: 10px;">
        <div class="field">
            <label class="" style="text-align: left; font-weight: 700">Content</label>
            <markdown-editor site-name="{siteName}"></markdown-editor>
        </div>
    </div>

    <style>
        .simplebar-scroll-content {
            padding-top: 10px;
        }
    </style>

    <script>
        var me = this;

        me.formEditor = null;
        me.markdownEditor = null;
        me.siteName = me.opts.siteName;

        me.on('mount', function () {
            $(me.root).simplebar();
            $(me.root.querySelector('.simplebar-scroll-content'))
                    .css('padding-left', '10px')
                    .css('padding-right', '18px');
        });

        me.setContent = function (content, contentConfig) {
//            console.log('me.tags', me.tags);
//            console.log('contentConfig', contentConfig);
            // gen content form
            console.log('setContent', content.metaData);
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
