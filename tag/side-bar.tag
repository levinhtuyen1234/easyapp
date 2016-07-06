<side-bar>
    <div class="panel panel-default" style="border: 0">
        <!--<div class="panel-heading panel-heading-sm" style="padding: 0; border: 0;">-->
        <div class="btn-group" data-toggle="buttons">
            <a class="btn btn-default navbar-btn btn-sm active" href="#content-file-list" data-toggle="tab" role="tab" onclick="{activeTab}">
                <input type="radio" name="file-list-options">Content
            </a>
            <a class="btn btn-default navbar-btn btn-sm" href="#layout-file-list" data-toggle="tab" role="tab" onclick="{activeTab}">
                <input type="radio" name="file-list-options">Layout
            </a>
            <a class="btn btn-default navbar-btn btn-sm" href="#asset-file-list" data-toggle="tab" role="tab" onclick="{activeTab}">
                <input type="radio" name="file-list-options">Asset
            </a>
        </div>
        <!--</div>-->
        <div class="panel-body" style="padding: 0;">
            <div class="tab-content">
                <file-list-flat id="content-file-list" role="tabpanel" class="tab-pane active"></file-list-flat>
                <file-list-flat id="layout-file-list" role="tabpanel" class="tab-pane"></file-list-flat>
                <file-list-flat id="asset-file-list" role="tabpanel" class="tab-pane"></file-list-flat>
            </div>
        </div>
    </div>

    <script>
        var me = this;
        var $root = $(me.root);
        var curFilePath = '';

        var contentFileTag, layoutFileTag, assetFileTag;

        me.activeTab = function (e) {
            $(me.root).find('.navbar-btn').removeClass('active');
            $(e.target).addClass('active');
        };

        me.reloadContentFileTab = function () {
            var files = BackEnd.getSiteContentFiles(opts.site_name);
//            console.log('reloadContentFileTab files', files);
            contentFileTag.loadFiles(files);
        };

        me.reloadLayoutFileTab = function () {
            var files = BackEnd.getSiteLayoutFiles(opts.site_name);
            layoutFileTag.loadFiles(files);
        };

        me.reloadAssetFileTab = function () {
            var files = BackEnd.getSiteAssetFiles(opts.site_name);
            assetFileTag.loadFiles(files);
        };

        me.on('mount', function () {
            contentFileTag = me.tags['file-list-flat'][0];
            layoutFileTag = me.tags['file-list-flat'][1];
            assetFileTag = me.tags['file-list-flat'][2];


            me.reloadContentFileTab();
            me.reloadLayoutFileTab();
            me.reloadAssetFileTab();

            contentFileTag.event.on('openFile', function (filePath) {
                me.parent.openFile(filePath);
            });

            layoutFileTag.event.on('openFile', function (filePath) {
                console.log('filePath', filePath);
                me.parent.openFile(filePath);
            });

            assetFileTag.event.on('openFile', function (filePath) {
                if (!me.parent.openAssetFile) {
                    console.log('home tag need fn openAssetFile');
                } else
                    me.parent.openAssetFile(filePath);
            });

        });

    </script>
</side-bar>
