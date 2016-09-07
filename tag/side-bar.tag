<side-bar>
    <div class="panel panel-default" style="border: 0">
        <!--<div class="panel-heading panel-heading-sm" style="padding: 0; border: 0;">-->
        <div class="btn-group" data-toggle="buttons">
            <a class="btn btn-default navbar-btn btn-sm active" href="#content-file-list" data-toggle="tab" role="tab" onclick="{activeTab}">
                <input type="radio" name="file-list-options">Content
            </a>
            <a class="btn btn-default navbar-btn btn-sm" href="#metadata-file-list" data-toggle="tab" role="tab" onclick="{activeTab}" hide="{User.accountType == 'user'}">
                <input type="radio" name="file-list-options">Meta
            </a>
            <a class="btn btn-default navbar-btn btn-sm" href="#layout-file-list" data-toggle="tab" role="tab" onclick="{activeTab}" hide="{User.accountType == 'user'}">
                <input type="radio" name="file-list-options">Layout
            </a>
            <!--<a class="btn btn-default navbar-btn btn-sm" href="#asset-file-list" data-toggle="tab" role="tab" onclick="{activeTab}" hide="{User.accountType == 'user'}">-->
                <!--<input type="radio" name="file-list-options">Asset-->
            <!--</a>-->

        </div>
        <!--</div>-->
        <div class="panel-body" style="padding: 0;">
            <div class="tab-content">
                <file-list-flat type="content" id="content-file-list" role="tabpanel" class="tab-pane active"></file-list-flat>
                <file-list-flat type="layout" id="layout-file-list" role="tabpanel" class="tab-pane"></file-list-flat>
                <file-list-flat type="metadata" id="metadata-file-list" role="tabpanel" class="tab-pane"></file-list-flat>
                <!--<file-list-flat type="asset" id="asset-file-list" role="tabpanel" class="tab-pane"></file-list-flat>-->
            </div>
        </div>
    </div>

    <script>
        var me = this;
        var $root = $(me.root);
        var curFilePath = '';

        var contentFileTag, layoutFileTag, assetFileTag, metadataFileTag;

        me.activeTab = function (e) {
            $(me.root).find('.navbar-btn').removeClass('active');
            if (typeof(e) === 'object') {
                $(e.target).addClass('active');
            } else {
                $(me.root.querySelector('a[href="#' + e + '"]')).addClass('active').tab('show');
            }
        };

        var onFileActivated = function(tabName) {
            // clear other tab active file
            console.trace('ACTIVE tab', tabName);
            switch (tabName) {
                case 'content-file-list':
                case 'content':
                    me.tags['file-list-flat'][1].clearActive();
                    me.tags['file-list-flat'][2].clearActive();
                    break;
                case 'layout-file-list':
                case 'layout':
                    me.tags['file-list-flat'][0].clearActive();
                    me.tags['file-list-flat'][2].clearActive();
                    break;
                case 'metadata-file-list':
                case 'metadata':
                    me.tags['file-list-flat'][0].clearActive();
                    me.tags['file-list-flat'][1].clearActive();
                    break;
            }
        };

        me.activeFile = function (tabName, filePath) {
            // active tab
            me.activeTab(tabName);
            onFileActivated(tabName);
            // highlight file
            switch (tabName) {
                case 'content-file-list':
                    me.tags['file-list-flat'][0].activeFile(filePath);
                    break;
                case 'layout-file-list':
                    me.tags['file-list-flat'][1].activeFile(filePath);
                    break;
                case 'metadata-file-list':
                    me.tags['file-list-flat'][2].activeFile(filePath);
                    break;
            }
        };

        me.reloadContentFileTab = function () {
            var files = BackEnd.getSiteContentFiles(opts.siteName);
            contentFileTag.loadFiles(files);
        };

        me.reloadLayoutFileTab = function () {
            var files = BackEnd.getSiteLayoutFiles(opts.siteName);
            layoutFileTag.loadFiles(files);
        };

        //        me.reloadAssetFileTab = function () {
        //            var files = BackEnd.getSiteAssetFiles(opts.siteName);
        //            assetFileTag.loadFiles(files);
        //        };

        me.reloadMetadataFileTab = function () {
            var files = BackEnd.getSiteMetadataFiles(opts.siteName);
//            console.log('metadata files', files);
            metadataFileTag.loadFiles(files);
        };

        me.reloadCurrentTab = function () {
            // get cur tab
            var activeTabHref = $(me.root.querySelector('a.navbar-btn.active')).attr('href');
            switch (activeTabHref) {
                case '#content-file-list':
                    me.reloadContentFileTab();
                    break;
                case '#layout-file-list':
                    me.reloadLayoutFileTab();
                    break;
//                case '#asset-file-list':
//                    me.reloadAssetFileTab();
//                    break;
                case '#metadata-file-list':
                    me.reloadMetadataFileTab();
                    break;
            }
        };

        var onAddContentFile = function (filePath) {
            me.reloadContentFileTab();
        };

        var onRemoveFile = function (filePath) {
            me.reloadCurrentTab();
        };

        var onAddLayout = function () {
            me.reloadLayoutFileTab();
        };

        var onAddCategory = function () {
            me.reloadMetadataFileTab();
        };

        var onAddTag = function () {
            me.reloadMetadataFileTab();
        };

        var onOpenFile = function () {
            // clear active from other tab
        };

        riot.api.on('addContentFile', onAddContentFile);
        riot.api.on('addCategory', onAddCategory);
        riot.api.on('addTag', onAddTag);
        riot.api.on('removeFile', onRemoveFile);
        riot.api.on('addLayout', onAddLayout);
        riot.api.on('fileActivated', onFileActivated);

        me.on('unmount', function () {
            riot.api.off('addCategory', onAddCategory);
            riot.api.off('addTag', onAddTag);
            riot.api.off('addContentFile', onAddContentFile);
            riot.api.off('removeFile', onRemoveFile);
            riot.api.off('addLayout', onAddLayout);
            riot.api.off('fileActivated', onFileActivated);
        });

        me.on('mount', function () {
            contentFileTag = me.tags['file-list-flat'][0];
            layoutFileTag = me.tags['file-list-flat'][1];
//            assetFileTag = me.tags['file-list-flat'][2];
            metadataFileTag = me.tags['file-list-flat'][2];

            me.reloadContentFileTab();
            me.reloadLayoutFileTab();
            me.reloadMetadataFileTab();
//            me.reloadAssetFileTab();

            contentFileTag.event.on('openFile', function (filePath) {
                me.parent.openFile(filePath);
            });

            layoutFileTag.event.on('openFile', function (filePath) {
                me.parent.openFile(filePath);
            });

//            assetFileTag.event.on('openFile', function (filePath) {
//                if (!me.parent.openAssetFile) {
//                    console.log('home tag need fn openAssetFile');
//                } else
//                    me.parent.openAssetFile(filePath);
//            });

            metadataFileTag.event.on('openFile', function (filePath) {
                me.parent.openMetadataFile(filePath);
            });
        });
    </script>
</side-bar>
