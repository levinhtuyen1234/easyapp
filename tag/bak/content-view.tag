<content-view>
    <!-- Nav tabs -->
    <ul class="nav nav-tabs" role="tablist">
        <li role="presentation" class="active"><a href="#content-form-editor" aria-controls="form-editor" role="tab" data-toggle="tab" data-name="form">Form</a></li>
        <li role="presentation"><a href="#content-code-editor" aria-controls="raw-editor" role="tab" data-toggle="tab" data-name="raw">Raw</a></li>
        <li role="presentation" class="pull-right">
            <button class="btn btn-danger" onclick="{deleteFile}"><i class="fa fa-fw fa-remove"></i> Delete</button>
            |
            <div class="btn-group">
                <button class="btn btn-default" onclick="{openLayout}"><i class="fa fa-fw fa-code"></i> Layout</button>
                <button class="btn btn-default" onclick="{openConfig}"><i class="fa fa-fw fa-cog"></i> Config</button>
            </div>
            |
            <div class="btn-group">
                <button class="btn btn-default" onclick="{save}"><i class="fa fa-fw fa-save"></i> Save</button>
                <button class="btn btn-primary" onclick="{publish}"><i class="fa fa-fw fa-upload"></i> Publish</button>
            </div>
        </li>

    </ul>
    <!-- Tab panes -->
    <div class="tab-content" style="height: calc(50vh - 10vh);">
        <div id="content-form-editor" active="{'true'}"></div>
        <div id="content-code-editor"></div>
    </div>
    <div id="content-markdown-editor"></div>
    <script>
        var me = this;

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

        me.on('mount', function () {
            var fileContent = BackEnd.getFileContent(opts.filePath);
            fileContent = fileContent.trim();
            if (fileContent === null) return;
            var content = SplitContentFile(fileContent);
//            console.log('mount fileContent', content);

            me.markdownEditor = riot.mount('#content-markdown-editor', 'markdown-editor')[0];
            me.markdownEditor.value(content.markDownData);

            me.formEditor = riot.mount('#content-form-editor', 'form-editor')[0];

            me.codeEditor = riot.mount('#content-code-editor', 'code-editor')[0];
            me.codeEditor.value(content.metaData);
            me.codeEditor.setOption('readOnly', true);

            $(me.root).find('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                if (e.target.dataset.name === 'raw') {
                    me.codeEditor.refresh();
                }
            })
        });

        me.deleteFile = function() {
            console.log('delete File');
        };

        me.publish = function () {
            console.log('publish');
        };

        me.save = function () {
            console.log('save');
        };

        me.openConfig = function () {
            console.log('openConfig');
        };

        me.openLayout = function () {
            console.log('openLayout');
        };
    </script>
</content-view>
