<content-view stype="height:600px; overflow-x:scroll ; overflow-y: scroll;">
    <h3 class="text-success">(?) Sửa đổi giá trị cho từng thuộc tính bên dưới và bấm nút "Save" để áp dụng</h3>
    <h3 class="text-info"> (!) Bấm Sync: đồng bộ cập nhật lên Cloud, Deploy: cập nhật sửa đổi vào thực tế</h3>
    <form-editor site-name="{siteName}"></form-editor>
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
            setTimeout(function () {
                me.tags['markdown-editor'].value(content.markDownData);
            }, 1);
        };

        me.reset = function () {
            me.tags['form-editor'].clear();
            me.tags['markdown-editor'].value('');
        };

        me.getContent = function () {
            return {
                metaData:     me.tags['form-editor'].getForm(),
                markdownData: me.tags['markdown-editor'].value()
            };
        }
    </script>
</content-view>
