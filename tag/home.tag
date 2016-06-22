<home>
    <div class="row">
        <side-bar site_name={opts.siteName} class="col-md-4"></side-bar>
        <div class="col-md-8">
            <button type="button" class="btn btn-danger btn-sm pull-right" style="margin-left: 10px;">
                <i class="fa fa-save"></i> Public
            </button>
            <button type="button" class="btn btn-primary btn-sm pull-right" style="margin-left: 10px;">
                <i class="fa fa-save"></i> View Demo
            </button>
            <breadcrumb site_name="{opts.siteName}"></breadcrumb>
            <!-- EDITOR PANEL -->
            <div class="panel panel-default">
                <div class="panel-heading panel-heading-sm">
                    <h3 class="panel-title pull-left">{currentFile}</h3>

                    <div role="separator" class="divider"></div>

                    <button type="button" class="btn btn-primary btn-sm pull-right" style="margin-left: 10px;">
                        <i class="fa fa-save"></i> Save
                    </button>


                    <div class="btn-group pull-right">
                        <button type="button" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Action <span class="caret"></span>
                        </button>
                        <ul class="dropdown-menu" role="tablist">
                            <li role="presentation">
                                <a href="#content-view" data-toggle="tab" role="tab" onclick="{openContentTab}">
                                    <i class="fa fa-fw fa-newspaper-o"></i> Edit content
                                </a>
                            </li>
                            <li role="presentation">
                                <a href="#layout-view" data-toggle="tab" role="tab" onclick="{openLayoutTab}">
                                    <i class="fa fa-fw fa-code"></i> Edit layout
                                </a>
                            </li>
                            <li role="presentation">
                                <a href="#config-view" data-toggle="tab" role="tab" onclick="{openConfigTab}">
                                    <i class="fa fa-fw fa-cog"></i> Edit config
                                </a>
                            </li>
                            <li role="separator" class="divider"></li>
                            <li>
                                <a href="#" class="alert-danger">
                                    <i class="fa fa-fw fa-remove"></i> Delete
                                </a>
                            </li>
                        </ul>
                    </div>
                    <div class="clearfix"></div>
                </div>
                <div class="panel-body">
                    <div class="tab-content">
                        <content-view id="content-view" role="tabpanel" class="tab-pane"></content-view>
                        <layout-view id="layout-view" role="tabpanel" class="tab-pane"></layout-view>
                        <config-view id="config-view" role="tabpanel" class="tab-pane"></config-view>
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
        me.currentFilePath = '';
        me.currentFile = '';

        me.on('mount', function () {
//            riot.mount('side-bar', {siteName: opts.siteName});
//            riot.mount('breadcrumb', {path: opts.siteName});
        });

        function HideAllTab() {
            $(me.root).find('li[role="presentation"]').removeClass('active');
        }

        function ShowTab(name) {
            $(me.root).find('ul[role="tablist"] li a[href="#' + name + '"]').tab('show');
        }

        function UnmountAll() {
            if (me.contentView) me.contentView.unmount(true);
            if (me.configView) me.configView.unmount(true);
            if (me.layoutView) me.layoutView.unmount(true);
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

        function getConfigFile(contentFilePath) {

        }

        me.openLayoutTab = function () {
            HideAllTab();
//            me.tags['layout-view'];
            ShowTab('layout-view');
        };

        me.openContentTab = function () {
            HideAllTab();
            me.currentFile = me.currentFilePath.split(/[/\\/]/).pop();
            me.update();

//            var content = getFileContent(me.currentFilePath);
            var content = BackEnd.getContentFile(me.opts.siteName, me.currentFilePath);
            if (!content.metaData.layout) {
                alert('content missing layout attribute');
                return;
            }

            var contentConfig = BackEnd.getConfigFile(me.opts.siteName, me.currentFilePath, content.metaData.layout);
            console.log('content', content);

            me.tags['content-view'].setContent(content, contentConfig);
            ShowTab('content-view');
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

        me.openFile = function (filePath) {
//            console.log('home openFile', filePath);
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
//            mainView = riot.mount('#main-view', 'main-view', {
//                filePath: filePath
//            })[0];
        }
    </script>

</home>
