<home>
    <div class="row">
        <side-bar dir={opts.sitePath} class="col-md-4"></side-bar>
        <div class="col-md-8">
            <breadcrumb></breadcrumb>
            <!-- EDITOR PANEL -->
            <div class="panel panel-default">
                <div class="panel-heading panel-heading-sm">
                    <h3 class="panel-title pull-left">Ten file</h3>

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
                                <a href="#content-view" data-toggle="tab" role="tab" onclick="{openContent}">
                                    <i class="fa fa-fw fa-newspaper-o"></i> Edit content
                                </a>
                            </li>
                            <li role="presentation">
                                <a href="#layout-view" data-toggle="tab" role="tab" onclick="{openLayout}">
                                    <i class="fa fa-fw fa-code"></i> Edit layout
                                </a>
                            </li>
                            <li role="presentation">
                                <a href="#config-view" data-toggle="tab" role="tab" onclick="{openConfig}">
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
                        <div id="content-view" role="tabpanel" class="tab-pane"></div>
                        <div id="layout-view" role="tabpanel" class="tab-pane"></div>
                        <div id="config-view" role="tabpanel" class="tab-pane"></div>
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

        me.on('mount', function () {

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

        me.openLayout = function (filePath) {
            HideAllTab();
            UnmountAll();
            me.layoutView = riot.mount('#layout-view', 'layout-view', {
                filePath: filePath
            })[0];
            ShowTab('layout-view');
        };

        me.openContent = function (filePath) {
            HideAllTab();
            UnmountAll();
            me.contentView = riot.mount('#content-view', 'content-view', {
                filePath: filePath
            })[0];
            ShowTab('content-view');
        };

        me.openConfig = function (filePath) {
            HideAllTab();
            UnmountAll();
            me.configView = riot.mount('#config-view', 'config-view', {
                filePath: filePath
            })[0];
            ShowTab('config-view');
        };

        me.newContent = function () {
            alert('todo newContent');
        };

        me.newLayout = function () {
            alert('todo newLayout');
        };

        me.newConfig = function () {
            alert('todo newConfig');
        };

        me.openFile = function (filePath) {
//            console.log('home openFile', filePath);
            me.tags['breadcrumb'].setPath(filePath);

            HideAllTab();

            // read file content

            if (filePath.endsWith('.md')) {
                me.openContent(filePath);
            } else if (filePath.endsWith('.config.json')) {
                me.openConfig(filePath);
            } else if (filePath.endsWith('.html')) {
                me.openLayout(filePath);
            }
//            mainView = riot.mount('#main-view', 'main-view', {
//                filePath: filePath
//            })[0];
        }
    </script>

</home>
