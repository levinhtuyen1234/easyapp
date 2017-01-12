<content-view class="ui tab segment active simplebar" style="height: calc(100% - 95px); padding-left: 10px; padding-right: 20px; padding-top: 5px; overflow-y: hidden">
    <!--<form-editor site-name="{siteName}"></form-editor>-->
    <json-schema-form-editor site-name="{siteName}"></json-schema-form-editor>

    <div class="ui form" style="padding-top: 10px;">
        <div class="field" id="contentMarkDownEditorField">
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

        let contentFieldConfig;

        me.on('mount', function () {
            $(me.root).simplebar();
            $(me.root.querySelector('.simplebar-scroll-content'))
                    .css('padding-left', '10px')
                    .css('padding-right', '18px');
        });

        me.setContent = function (content, contentConfig) {
            console.log('me.tags', me.tags);
            // gen content form
            contentFieldConfig = contentConfig.properties['__content__'];
            console.log('contentFieldConfig', contentFieldConfig);

//            me.tags['form-editor'].genForm(content.metaData, contentConfig);
            // remove __content__ in metadata
            delete content.metaData['__content__'];
            delete contentConfig.properties['__content__'];
            me.tags['json-schema-form-editor'].genForm(content.metaData, contentConfig);

            if (contentFieldConfig.options && contentFieldConfig.options.hidden) {
                $(contentMarkDownEditorField).hide();
            } else {
                $(contentMarkDownEditorField).show();
            }

            me.tags['markdown-editor'].setValue(content.markDownData);
        };

        me.reset = function () {
            me.tags['json-schema-form-editor'].clear();
            me.tags['markdown-editor'].setValue('');
        };

        me.getContent = function () {
            let contentMarkdownData = me.tags['markdown-editor'].getValue();
            let metaData = me.tags['json-schema-form-editor'].getForm();
            metaData['__content__'] = contentMarkdownData;
            return {
//                metaData:     me.tags['form-editor'].getForm(),
                metaData:     metaData,
                markdownData: contentMarkdownData
            };
        }
    </script>
</content-view>
