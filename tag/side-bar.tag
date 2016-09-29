<side-bar>
    <div class="ui pointing secondary menu" style="margin-bottom: 0; overflow: hidden">
        <a class="item active" data-tab="content">Content</a>
        <a class="item" data-tab="meta">Meta</a>
        <a class="item" data-tab="layout">Layout</a>
    </div>

    <file-list-flat class="ui bottom attached tab segment active" type="content" data-tab="content" style="margin-bottom: 0;padding: 0 0 0 0;height: 100%;"></file-list-flat>
    <file-list-flat class="ui bottom attached tab segment" type="layout" data-tab="layout" style="margin-bottom: 0;padding: 0 0 0 0;height: 100%;"></file-list-flat>
    <file-list-flat class="ui bottom attached tab segment" type="meta" data-tab="meta" style="margin-bottom: 0;padding: 0 0 0 0;height: 100%;"></file-list-flat>

    <!--<div class="btn-group" data-toggle="buttons">-->
    <!--<button class="ui button active" href="#content-file-list" data-toggle="tab" role="tab" onclick="{activeTab}">-->
    <!--<input type="radio" name="file-list-options">Content-->
    <!--</button>-->
    <!--<button class="btn btn-default navbar-btn btn-sm" href="#metadata-file-list" data-toggle="tab" role="tab" onclick="{activeTab}" hide="{User.accountType == 'user'}">-->
    <!--<input type="radio" name="file-list-options">Meta-->
    <!--</button>-->
    <!--<button class="btn btn-default navbar-btn btn-sm" href="#layout-file-list" data-toggle="tab" role="tab" onclick="{activeTab}" hide="{User.accountType == 'user'}">-->
    <!--<input type="radio" name="file-list-options">Layout-->
    <!--</button>-->
    <!--&lt;!&ndash;<a class="btn btn-default navbar-btn btn-sm" href="#asset-file-list" data-toggle="tab" role="tab" onclick="{activeTab}" hide="{User.accountType == 'user'}">&ndash;&gt;-->
    <!--&lt;!&ndash;<input type="radio" name="file-list-options">Asset&ndash;&gt;-->
    <!--&lt;!&ndash;</a>&ndash;&gt;-->

    <!--</div>-->

    <!--<div class="panel-body" style="padding: 0;">-->
    <!--<div class="tab-content">-->
    <!---->
    <!--</div>-->
    <!--</div>-->
    <!--</div>-->

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

        var onFileActivated = function (tabName) {
            // clear other tab active file
//            console.trace('ACTIVE tab', tabName);
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

        riot.event.on('addContentFile', onAddContentFile);
        riot.event.on('addCategory', onAddCategory);
        riot.event.on('addTag', onAddTag);
        riot.event.on('removeFile', onRemoveFile);
        riot.event.on('addLayout', onAddLayout);
        riot.event.on('fileActivated', onFileActivated);

        me.on('unmount', function () {
            riot.event.off('addCategory', onAddCategory);
            riot.event.off('addTag', onAddTag);
            riot.event.off('addContentFile', onAddContentFile);
            riot.event.off('removeFile', onRemoveFile);
            riot.event.off('addLayout', onAddLayout);
            riot.event.off('fileActivated', onFileActivated);
        });

        me.on('mount', function () {
            $(me.root.querySelectorAll('.menu .item')).tab();

            contentFileTag = me.tags['file-list-flat'][0];
            layoutFileTag = me.tags['file-list-flat'][1];
//            assetFileTag = me.tags['file-list-flat'][2];
            metadataFileTag = me.tags['file-list-flat'][2];

            me.reloadContentFileTab();
            me.reloadLayoutFileTab();
            me.reloadMetadataFileTab();
//            me.reloadAssetFileTab();

            contentFileTag.on('openFile', function (filePath) {
                console.log('side-bar on openFile', filePath);
                me.parent.openFile(filePath);
            });

            layoutFileTag.on('openFile', function (filePath) {
                me.parent.openFile(filePath);
            });

//            assetFileTag.event.on('openFile', function (filePath) {
//                if (!me.parent.openAssetFile) {
//                    console.log('home tag need fn openAssetFile');
//                } else
//                    me.parent.openAssetFile(filePath);
//            });

            metadataFileTag.on('openFile', function (filePath) {
                me.parent.openMetadataFile(filePath);
            });
        });
    </script>
</side-bar>
