<home>
    <new-content-dialog></new-content-dialog>
    <new-layout-dialog></new-layout-dialog>
    <div class="row">
        <side-bar site_name={opts.siteName} class="col-md-4"></side-bar>
        <div class="col-md-8">
            <breadcrumb site_name="{opts.siteName}"></breadcrumb>
            <!-- EDITOR PANEL -->
            <div class="panel panel-default" hide="{curTab === ''}">
                <div class="panel-heading panel-heading-sm">
                    <h3 class="panel-title pull-left" style="width: 250px;">{currentFileTitle}</h3>

                    <div class="btn-group pull-right" data-toggle="buttons" style="margin-left: 10px;">
                        <a class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <i class="fa fa-fw fa-github"></i>
                            <span class="caret"></span>
                        </a>
                        <ul class="dropdown-menu" role="tablist">
                            <li role="presentation">
                                <a href="#" onclick="{syncToGitHub}" title="Sync project to GitHub">
                                    <i class="fa fa-fw fa-cloud-upload"></i> Sync
                                </a>
                            </li>
                            <li role="presentation">
                                <a href="#" onclick="{deployToGitHub}" title="Deploy to gh-pages">
                                    <i class="fa fa-fw fa-globe"></i> Deploy
                                </a>
                            </li>
                            <li role="presentation">
                                <a href="#" onclick="{deployToGitHub}" title="Deploy to gh-pages">
                                    <i class="fa fa-fw fa-gear"></i> Option
                                </a>
                            </li>
                        </ul>
                    </div>

                    <div class="btn-group pull-right" data-toggle="buttons" style="margin-left: 10px;">
                        <a class="btn btn-primary btn-sm" style="margin-left: 10px;" onclick="{save}">
                            <i class="fa fa-save"></i> Save
                        </a>
                    </div>

                    <div class="btn-group pull-right" data-toggle="buttons">
                        <a class="btn btn-default btn-sm" href="#content-view" data-toggle="tab" role="tab" onclick="{openContentTab}">
                            <input type="radio" name="options"><i class="fa fa-fw fa-newspaper-o"></i> Content
                        </a>
                        <a class="btn btn-default btn-sm" href="#code-view" data-toggle="tab" role="tab" onclick="{openRawContentTab}">
                            <input type="radio" name="options">Raw
                        </a>
                        <a class="btn btn-default btn-sm" href="#layout-view" data-toggle="tab" role="tab" onclick="{openLayoutTab}">
                            <input type="radio" name="options"><i class="fa fa-fw fa-code"></i> Layout
                        </a>
                        <a class="btn btn-default btn-sm" href="#config-view" data-toggle="tab" role="tab" onclick="{openConfigTab}">
                            <input type="radio" name="options"><i class="fa fa-fw fa-cog"></i> Config
                        </a>
                        <a class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" show="{curTab === 'content-view' || curTab === 'code-view'}">
                            <span class="caret"></span>
                        </a>
                        <ul class="dropdown-menu" role="tablist">
                            <li role="presentation">
                                <a class="bg-danger" href="#" onclick="{deleteFile}">
                                    <i class="fa fa-fw fa-remove"></i> Delete
                                </a>
                            </li>
                        </ul>
                        <a class="btn btn-default btn-sm" href="#watch-view" data-toggle="tab" role="tab" onclick="{openWatchView}">
                            <input type="radio" name="options"><i class="fa fa-fw fa-eye"></i>
                        </a>
                    </div>
                    <!--<div class="clearfix"></div>-->
                    <div class="clearfix"></div>
                </div>
                <div class="panel-body">
                    <div class="tab-content">
                        <content-view id="content-view" role="tabpanel" class="tab-pane"></content-view>
                        <code-editor id="code-view" role="tabpanel" class="tab-pane"></code-editor>
                        <code-editor id="layout-view" role="tabpanel" class="tab-pane"></code-editor>
                        <config-view id="config-view" role="tabpanel" class="tab-pane"></config-view>
                        <watch-view id="watch-view" site_name="{siteName}" role="tabpanel" class="tab-pane"></watch-view>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        var me = this;
        me.contentView = null;
        me.configView = null;
        me.layoutView = null;
        me.codeView = null;
        me.watchView = null;
        me.curTab = '';
        me.currentFilePath = '';
        me.currentLayout = '';
        me.currentFileTitle = '';
        me.siteName = me.opts.siteName;

        me.on('mount', function () {
//            riot.mount('side-bar', {siteName: opts.siteName});
//            riot.mount('breadcrumb', {path: opts.siteName});
        });

        function HideAllTab() {
            $(me.root).find('a[role="tab"]').removeClass('active');
        }

        function ShowTab(name) {
            me.curTab = name;
            var elm = $(me.root).find('a[href="#' + name + '"]');
            elm.tab('show');
            elm.addClass('active');
        }

        function UnmountAll() {
            if (me.contentView) me.contentView.unmount(true);
            if (me.configView) me.configView.unmount(true);
            if (me.layoutView) me.layoutView.unmount(true);
            if (me.codeView) me.codeView.unmount(true);
        }

        function createDefaultConfigFile(metaData) {
            var config = [];
            for (var key in metaData) {
                if (!metaData.hasOwnProperty(key)) continue;
                var value = form[key];
                switch (typeof value) {
                    case 'string':
                        config.push({
                            name:        key,
                            type:        'text',
                            required:    true,
                            validations: []
                        });
                        break;
                    case 'number':
                        config.push({
                            name:        key,
                            type:        'integer',
                            required:    true,
                            validations: []
                        });
                        break;
                    case 'boolean':
                        config.push({
                            name:        key,
                            type:        'boolean',
                            required:    true,
                            validations: []
                        });
                        break;
                }
            }
            return config;
        }

        function getFileContent(filePath) {
            var fileContent = BackEnd.readFile(me.opts.siteName, filePath).trim();
            if (fileContent === null) return;
            // split content thanh meta va markdown
            return SplitContentFile(fileContent);
        }

        me.openLayoutTab = function () {
            HideAllTab();
            me.currentFileTitle = me.currentFilePath.split(/[/\\/]/).pop();
            me.update();

            var fileContent = BackEnd.getLayoutFile(me.opts.siteName, me.currentLayout);
            me.tags['code-editor'][1].value(fileContent);
            me.tags['code-editor'][1].setOption('readOnly', false);
            ShowTab('layout-view');
        };

        me.openContentTab = function () {
            try {
                HideAllTab();
                me.currentFileTitle = me.currentFilePath.split(/[/\\/]/).pop();
                me.update();

//            var content = getFileContent(me.currentFilePath);
                var content = BackEnd.getContentFile(me.opts.siteName, me.currentFilePath);
                if (!content || !content.metaData || !content.metaData.layout) {
                    console.log('content missing meta or layout attribute');
                    me.tags['content-view'].reset();
//                return;
                } else {
                    me.currentLayout = content.metaData.layout;
                    var contentConfig = BackEnd.getConfigFile(me.opts.siteName, me.currentFilePath, content.metaData.layout);
                    console.log('content', content);
                    me.tags['content-view'].setContent(content, contentConfig);
                }

                ShowTab('content-view');
            } catch (ex) {
                bootbox.alert('Open content failed, error ' + ex.message, function () {
                });
                me.openRawContentTab({
                    readOnly: false,
                    mode:     'json-frontmatter'
                });
            }
        };

        me.openConfigTab = function () {
            console.log('openConfig', me.currentFilePath);
            HideAllTab();

            var content = BackEnd.getContentFile(me.opts.siteName, me.currentFilePath);
            if (!content.metaData.layout) {
                alert('content missing layout attribute');
                return;
            }

            var contentConfig = BackEnd.getConfigFile(me.opts.siteName, me.currentFilePath, content.metaData.layout);

            me.tags['config-view'].loadContentConfig(contentConfig);
            ShowTab('config-view');
        };

        me.openRawContentTab = function (options) {
            options = options || {};
            console.log('openRawContentTab', me.currentFilePath);
            HideAllTab();

            var rawStr = BackEnd.getRawContentFile(me.opts.siteName, me.currentFilePath);
            var contentCodeEditor = me.tags['code-editor'][0];
            contentCodeEditor.value(rawStr);

            contentCodeEditor.setOption('mode', 'json-frontmatter');
            for (var key in options) {
                if (!options.hasOwnProperty(key)) continue;
                console.log('set editor option', key, options[key]);
                contentCodeEditor.setOption(key, options[key]);
            }
            ShowTab('code-view');
        };

        me.openFile = function (filePath) {
            console.log('home openFile', filePath);
            me.tags['breadcrumb'].setPath(filePath);
            me.currentFilePath = filePath;
            HideAllTab();

            if (filePath.endsWith('.md')) {
                me.openContentTab();
            } else if (filePath.endsWith('.config.json')) {
                me.openConfigTab();
            } else if (filePath.endsWith('.html')) {
                me.openLayoutTab();
            }
            me.update();
        };

        me.save = function () {
//            var curTabHref = $(me.root).find('[role="presentation"].active>a').attr('href');
            switch (me.curTab) {
                case 'content-view':
                    var content = me.tags['content-view'].getContent();
                    BackEnd.saveContentFile(me.opts.siteName, me.currentFilePath, content.metaData, content.markdownData);
                    break;
                case 'code-view':
                    var rawContent = me.tags['code-editor'][0].value();
                    BackEnd.saveRawContentFile(me.opts.siteName, me.currentFilePath, rawContent);
                    break;
                case 'layout-view':
                    var layoutContent = me.tags['code-editor'][1].value();
                    BackEnd.saveLayoutFile(me.opts.siteName, me.currentLayout, layoutContent);
                    break;
                case 'config-view':
                    var contentConfig = me.tags['config-view'].getContentConfig();
                    BackEnd.saveConfigFile(me.opts.siteName, me.currentLayout, JSON.stringify(contentConfig, null, 4));
                    break;
            }
        };

        me.deleteFile = function () {
//            var curTabHref = $(me.root).find('[role="presentation"].active>a').attr('href');
            switch (me.curTab) {
                case 'content-view':
                    var contentFilePath = me.currentFilePath;
                    if (contentFilePath.startsWith('content')) {
                        var parts = contentFilePath.split(/[\\\/]/);
                        parts.shift();
                        contentFilePath = parts.join('/');
                    }
//                    console.log('contentFilePath', contentFilePath);
                    bootbox.confirm({
                        title:    'Delete',
                        message:  `Are you sure you want to delete content "${contentFilePath}" ?`,
                        buttons:  {
                            'cancel':  {
                                label:     'Cancel',
                                className: 'btn-default'
                            },
                            'confirm': {
                                label:     'Delete',
                                className: 'btn-danger'
                            }
                        },
                        callback: function (result) {
                            if (result) {
                                BackEnd.deleteContentFile(me.opts.siteName, contentFilePath);
                                me.tags['side-bar'].loadFiles(me.opts.siteName); // reload sidebar file list
                                // hide rightCol
                                me.curTab = '';
                                me.tags['breadcrumb'].setPath('');
                                me.update();
                            }
                        }
                    });
                    break;
                case 'layout-view':
                    console.log('TODO delete layout', me.currentLayout);

                    break;
                case 'config-view':
                    console.log('TODO delete config', me.currentFilePath);
                    break;
            }
        };

        me.newLayout = function () {
            console.log('newLayout');
            me.tags['new-layout-dialog'].show();
        };

        me.newContent = function () {
            console.log('newContent');
            var layoutList = BackEnd.getLayoutList(me.siteName);
            console.log('layoutList', layoutList);
            me.tags['new-content-dialog'].updateLayoutList(layoutList);
            me.tags['new-content-dialog'].show();
        };

        me.openWatchView = function () {
            console.log('openWatchView');
        };

        riot.api.on('addLayout', function (layoutFileName) {
            try {
                var newFile = BackEnd.newLayoutFile(me.siteName, layoutFileName);
                console.log('trigger closeNewContentDialog');
                riot.api.trigger('closeNewLayoutDialog');
            } catch (ex) {
                console.log('addLayout', ex);
                bootbox.alert('create layout failed, error ' + ex.message);
            }
        });

        riot.api.on('addContent', function (layoutFileName, contentTitle, contentFileName, isFrontPage) {
            try {
                var newFile = BackEnd.newContentFile(me.siteName, layoutFileName, contentTitle, contentFileName, isFrontPage);
                var newContentFilePath = newFile.path;
                // reload sidebar file list
                me.tags['side-bar'].loadFiles(me.opts.siteName);
                riot.api.trigger('closeNewContentDialog');
                console.log('open file', newContentFilePath);
                me.openFile(newContentFilePath);
                me.tags['side-bar'].activeFile(newContentFilePath);
            } catch (ex) {
                console.log('addContent', ex);
                bootbox.alert('create content failed, error ' + ex.message);
            }
        });

        me.deployToGitHub = function () {
//            BackEnd.deployToGitHub(me.siteName, );

        };

        me.syncToGitHub = function () {

        };

    </script>
</home>
