<home>
    <new-tag-dialog site-name={opts.siteName}></new-tag-dialog>
    <new-category-dialog site-name={opts.siteName}></new-category-dialog>
    <new-content-dialog site-name={opts.siteName}></new-content-dialog>
    <new-layout-dialog site-name={opts.siteName}></new-layout-dialog>
    <progress-dialog site-name={opts.siteName}></progress-dialog>
    <github-init-dialog site-name={opts.siteName}></github-init-dialog>
    <deploy-ftp-dialog site-name={opts.siteName}></deploy-ftp-dialog>

    <div class="ui fluid tiny inverted menu" style="margin-top: 0; border-radius: 0;">
        <div class="item">
            <a href="#goto-home" onclick="{goToLandingPage}" class="ui primary button">
                <i class="ui icon home" style="margin: 0"></i>
            </a>
        </div>
        <div class="item">
            <div href="#add-page" onclick="{newContent}" class="ui button" data-position="bottom left" data-tooltip="Create new page using existing layout">
                <i class="add icon"></i>Page
            </div>
        </div>
        <div class="item">
            <a href="#add-category" onclick="{newCategory}" class="ui button" data-position="bottom left" data-tooltip="Create new category" hide="{User.accountType == 'user'}">
                <i class="add icon"></i>Category
            </a>
        </div>

        <div class="item">
            <a href="#add-tag" onclick="{newTag}" class="ui  button" data-position="bottom left" data-tooltip="Create new tag" hide="{User.accountType == 'user'}">
                <i class="add icon"></i>Tag
            </a>
        </div>

        <div class="item">
            <a href="#add-layout" onclick="{newLayout}" class="ui  button" data-position="bottom left" data-tooltip="Create new layout that using for a page" hide="{User.accountType == 'user'}">
                <i class="add icon"></i>Layout
            </a>
        </div>


        <div class="right menu">
            <a class="item" href="#build" id="openWatchViewBtn" onclick="{openWatchView.bind(this, 'user')}" title="Build this website on local PC to preview">
                <i class="fitted icon eye"></i> Build
            </a>

            <div class="ui dropdown icon item">
                <i class="dropdown icon fitted" style="margin: 0"></i>
                <div class="menu">
                    <div class="item" hide="{User.accountType == 'user'}" data-value="watchDev" onclick="{openWatchView.bind(this, 'dev')}">
                        <i class="fitted icon cubes"></i>
                        <span title="Build this website on local PC to preview (Dev mode)">Build Dev</span>
                    </div>
                    <div class="item" data-value="refreshWatch" onclick="{refreshWatchView}">
                        <i class="fitted icon refresh"></i>
                        <span title="restart to refresh preview website">Refresh</span>
                    </div>
                </div>
            </div>
            <a class="item" data-toggle="tab" title="Show Preview" disabled onclick="{toggleReview}">
                <i class="fitted icon external"></i>Preview
            </a>
            <!--  <a class="item" data-toggle="tab" ref="openExternalReviewBtn" title="Open on browser (IE, Firefox, Chrome,...) to Preview" onclick="{openExternalReview}" disabled>
                <i class="fitted icon external"></i> Browser
            </a> -->
            <div class="item" onclick="{syncToGitHub}" title="Synchronize to Cloud" show="{gitHubInited}">
                <i class="fa fa-fw fa-github"></i> Sync
            </div>
            <div class="item" onclick="{deployToGitHub}" title="Deploy website to live domain" show="{gitHubInited}">Deploy</div>
            <div class="ui dropdown right icon item" show="{gitHubInited}">
                <i class="dropdown icon fitted" style="margin: 0"></i>
                <div class="menu">
                    <div class="item">
                        <span onclick="{showFtpDialog}" title="Upload to Ftp server">To FTP server</span>
                    </div>
                    <div class="item">
                        <i class="fitted icon globe"></i>
                        <span onclick="{showSetDomainDialog}" title="Set domain for website">Set Domain</span>
                    </div>
                </div>
            </div>
            <a class="item" href="#" onclick="{showGitHubSetting}" title="Init Cloud using github account" hide="{gitHubInited}">Request</a>
        </div>
    </div>

    <div class="ui one column grid" style="height: calc(100vh - 45px)">
        <div class="stretched row" style="padding-bottom: 0; padding-top: 0;">
            <div class="column" id="outer-layout" style="padding-right: 0">
                <div id="inner-center" class="ui-layout-center">
                    <div class="ui-layout-west" style="overflow: hidden;">
                        <side-bar site-name={opts.siteName} style="overflow-y: hidden"></side-bar>
                    </div>
                    <div class="ui-layout-center" style="overflow-y: hidden">
                        <div class="ui pointing secondary menu">
                            <a class="item active" data-tab="content-view" onclick="{openContentTab}" show="{isShowContentTab()}">Form</a>
                            <a class="item" data-tab="meta-view" onclick="{openMetaTab}" show="{isShowMetaTab()}">Form</a>
                            <a class="item" data-tab="code-view" onclick="{openRawContentTab}" show="{isShowRawTab()}">Raw</a>
                            <a class="item" data-tab="layout-view" onclick="{openLayoutTab}" show="{isShowLayoutTab()}">Layout</a>
                            <a class="item" data-tab="config-view" onclick="{openConfigTab}" show="{isShowConfigTab()}">Config</a>
                            <div class="ui mini right menu" style="border: none">
                                <div style="padding: 4px 16px 3px 0">
                                    <div class="ui mini buttons" style="border: none">
                                        <div class="ui red icon button" onclick="{deleteFile}" hide="{curTab === 'meta-view'}">
                                            <i class="delete icon"></i>
                                            Delete
                                        </div>
                                        <div class="ui blue icon button" data-tooltip="'Ctrl+S' to save" data-position="bottom right" onclick="{save}">
                                            <i class="save icon"></i>
                                            Save (Ctrl+S)
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <breadcrumb site_name="{opts.siteName}"></breadcrumb>

                        <!--<div style="height: calc(100vh - 40px)">-->
                        <content-view site-name="{siteName}" data-tab="content-view"></content-view>
                        <meta-view site-name="{siteName}" data-tab="meta-view" class="ui tab segment"></meta-view>
                        <!--<code-editor site-name="{siteName}" data-tab="code-view" class="ui tab segment"></code-editor>-->
                        <!--<code-editor site-name="{siteName}" data-tab="layout-view" class="ui tab segment"></code-editor>-->
                        <code-editor site-name="{siteName}" data-tab="code-view" class="ui tab segment"></code-editor>
                        <monaco-editor site-name="{siteName}" data-tab="layout-view" class="ui tab segment"></monaco-editor>
                        <!--<config-view site-name="{siteName}" data-tab="config-view" class="ui tab segment"></config-view>-->
                        <json-schema-config-editor site-name="{siteName}" data-tab="config-view" class="ui tab segment"></json-schema-config-editor>
                    </div>

                </div>

                <div class="ui-layout-north">
                    <bottom-bar site-name={opts.siteName} site-review-url="{opts.siteReviewUrl}"></bottom-bar>
                </div>
            </div>
        </div>
    </div>

    <script>
        var me = this;
        var dialog = require('electron').remote.dialog;
        var Path = require('path');
        me.test = true;
        me.tabBar;
        me.contentView = null;
        me.configView = null;
        me.layoutView = null;
        me.codeView = null;
        me.watchView = null;
        me.curTab = '';
        me.currentFilePath = '';
        me.currentLayout = '';
        me.currentFileTitle = '';
        me.gitHubInited = true;
        me.siteName = me.opts.siteName;

        var outerLayout, innerLayout;

        // handler onSave content config view
        var onSaveContentConfigView, onSaveMetaConfigView;

        me.toggleReview = function () {
            console.log('toggleReview');
            outerLayout.toggle('north');
        };

        me.openReview = function () {
            outerLayout.open('north');
        };

        me.isShowContentTab = function () {
//            console.log('isShowContentTab me.curTab', me.curTab);
            return me.curTab == 'content-view' ||
                ((me.curTab == 'code-view' || me.curTab == 'config-view') && me.currentFilePath.endsWith('.md'));

        };

        me.isShowMetaTab = function () {
            return me.curTab == 'meta-view' ||
                ( me.curTab == 'config-view' && me.currentFilePath.endsWith('.json')) ||
                (
                    me.curTab == 'code-view' &&
                    me.currentFilePath.endsWith('.json') && !me.currentFilePath.startsWith('content/metadata/category') && !me.currentFilePath.startsWith('content/metadata/tag')
                );

        };

        me.isShowRawTab = function () {
//            console.log('isShowLayoutTab me.curTab', me.curTab);
            return User.accountType == 'dev' &&
                (
                    me.curTab == 'code-view' ||
                    me.curTab == 'config-view' ||
                    me.curTab == 'content-view' ||
                    me.curTab == 'meta-view'
                )
        };

        me.isShowLayoutTab = function () {
//            console.log('isShowLayoutTab me.curTab', me.curTab);
            return User.accountType == 'dev' &&
                (
                    me.curTab == 'content-view' ||
                    me.curTab == 'layout-view' ||
                    ( me.curTab == 'code-view' && me.currentFilePath.endsWith('.md') ) ||
                    ( me.curTab == 'config-view' && me.currentFilePath.endsWith('.md') )
                )
        };

        me.isShowConfigTab = function () {
//            console.log('isShowConfigTab me.curTab', me.curTab);
            return User.accountType === 'dev' &&
                (
                    me.curTab === 'meta-view' ||
                    me.curTab === 'config-view' ||
                    me.curTab === 'content-view' ||
                    ( me.curTab === 'code-view' && me.currentFilePath.endsWith('.md') ) ||
                    ( me.curTab === 'code-view' && !me.currentFilePath.startsWith('content/metadata/category/') && !me.currentFilePath.startsWith('content/metadata/tag/') && me.currentFilePath.endsWith('.json'))
                )
        };

        me.checkGhPageStatus = function () {
            BackEnd.isGhPageInitialized(me.opts.siteName + '/build').then(function (initialized) {
                console.log('home github initialized', initialized);
                me.gitHubInited = initialized;
                me.update();
            }).catch(function (ex) {
                if (ex.message.indexOf('ENOENT') !== -1) {
                    // build folder not exists
                    me.gitHubInited = false;
                    me.update();
                }
            });
        };

        me.saveByKeyboard = function () {
            console.log('saveByKeyboard', me.cur);
            me.save();
        };

        let onOpenAssetFile = function (assetFilePath) {
            let parts = assetFilePath.split(/[\\\/]/g);
            parts.shift(); // remove siteName
            parts.shift(); // remove conte
            let relativeAssetFilePath = parts.join('/');
            me.openAssetFile(relativeAssetFilePath);
        };

        me.on('unmount', function () {
            console.trace('unmount home tag');
            riot.event.off('chooseMediaFile', onChooseMediaFile);
            riot.event.off('addLayout', onAddLayout);
            riot.event.off('addContent', onAddContent);
            riot.event.off('addCategory', onAddCategory);
            riot.event.off('addTag', onAddTag);
            riot.event.off('openAssetFile', onOpenAssetFile);

            riot.event.off('codeEditor.save', me.saveByKeyboard);
            riot.event.off('watchFailed', me.deactiveWatchBtn);
        });

        me.on('mount', function () {
            window.editor1 = me.tags['monaco-editor'];
            console.trace('mount home tag');
            me.tabBar = $(me.root.querySelectorAll('.menu .item')).tab({
                onLoad: function (tabPath) {
//                    console.log('tab onload', tabPath);
//                    if (tabPath == 'config-view') {
//                        me.openConfigTab();
//                    }
                }
            });
            me.checkGhPageStatus();

            $(me.root.querySelectorAll('.ui.dropdown')).dropdown({
                onChange: function (value, text) {
                    if (value === '') return;
                    $(this).dropdown('clear');
                }
            }); // init dropdown

            outerLayout = $('#outer-layout').layout({
                center: {
                    size: '60%'
                },
                north:  {
                    size:           '40%',
                    spacing_open:   1,
                    spacing_closed: 10,
                    initClosed:     true
                }
            });

            innerLayout = $('#inner-center').layout({
                west:   {
                    size:           '35%',
                    spacing_open:   1,
                    spacing_closed: 10
                },
                center: {}
            });

            // create 1px resizer + large click area
            var resizer = $(me.root.querySelectorAll('.ui-layout-resizer-west')).css({overflow: "visible"});
            $("<div></div>").css({
//                background: "#F00",
                width:      "100%",
                height:     "100%",
                padding:    "0 5px",
                marginLeft: "0px",
                opacity:    .20
            }).prependTo(resizer);

            resizer = $(me.root.querySelectorAll('.ui-layout-resizer-north')).css({overflow: "visible"});
            $("<div></div>").css({
//                background: "#F00",
                width:      "100%",
                height:     "100%",
                padding:    "5px 0",
                marginLeft: "0px",
                opacity:    .20
            }).prependTo(resizer);

            riot.event.on('codeEditor.save', me.saveByKeyboard);
            riot.event.on('watchFailed', me.deactiveWatchBtn);
            riot.event.on('openAssetFile', onOpenAssetFile);

            setTimeout(function () {
                var indexFilePath = 'sites/' + me.siteName + '/content/index.md';
                if (BackEnd.fileExists(indexFilePath) === true) {
                    me.openFile('content/index.md');
                }
            }, 1);
        });

        me.goToLandingPage = function () {
            me.unmount(true);
            riot.event.trigger('showLandingPage');
        };

        function HideAllTab() {
//            console.trace('HideAllTab', $(me.root).find('a[role="tab"]'));
            $(me.root).find('a[role="tab"]').removeClass('active');

//            me.tags['config-view'].off('saveConfig', onSaveContentConfigView);
//            me.tags['config-view'].off('saveConfig', onSaveMetaConfigView);
            me.tags['json-schema-config-editor'].off('saveConfig', onSaveContentConfigView);
            me.tags['json-schema-config-editor'].off('saveConfig', onSaveMetaConfigView);
        }

        function ShowTab(name) {
//            console.log('ShowTab', name);
            me.curTab = name;
            me.tabBar.tab('change tab', name);
//            var elm = $(me.root).find('a[href="#' + name + '"]');
//            console.trace('ShowTab', elm);
//            elm.tab('show');
//            elm.addClass('active');
        }

        function UnmountAll() {
            if (me.contentView) me.contentView.unmount(true);
            if (me.configView) me.configView.unmount(true);
            if (me.layoutView) me.layoutView.unmount(true);
            if (me.codeView) me.codeView.unmount(true);
        }

        function getFileContent(filePath) {
            var fileContent = BackEnd.readFile(me.opts.siteName, filePath).trim();
            if (fileContent === null) return;
            // split content thanh meta va markdown
            return SplitContentFile(fileContent);
        }

        me.showSetDomainDialog = function () {
            bootbox.prompt("New domain", function (domain) {
                if (domain == null) return;
                var isDomainValid = /^((?:(?:(?:\w[.\-+]?)*)\w)+)((?:(?:(?:\w[.\-+]?){0,62})\w)+)\.(\w{2,6})$/.test(domain);
                if (!isDomainValid) {
                    bootbox.alert({
                        title:   'Alert',
                        message: 'Invalid domain'
                    });
                    return false;
                }
                BackEnd.setDomain(me.opts.siteName, domain);
            });
        };

        me.refreshWatchView = function (e) {
            me.openWatchView();
            console.log('refreshWatchView');
            riot.event.trigger('refreshWatch');
            setTimeout(function () {
                $(e.srcElement).closest('.item').removeClass('active');
            }, 1);
        };

        me.openLayoutTab = function () {
            me.currentFileTitle = me.currentFilePath.split(/[/\\]/).pop();
            me.update();

            me.tags['breadcrumb'].setPath('layout/' + me.currentLayout);
            var fileContent = BackEnd.getLayoutFile(me.opts.siteName, me.currentLayout);
            me.tags['side-bar'].activeFile('layout', 'layout/' + me.currentLayout);
            me.tags['monaco-editor'].value(fileContent, 'handlebars', me.currentLayout);
            me.tags['monaco-editor'].setOption('readOnly', false);
            ShowTab('layout-view');
        };

        me.openWatchView = function (mode) {
            if (mode) {
                me.lastMode = mode;
            } else {
                if (!me.lastMode) return;
                mode = me.lastMode;
            }
            console.log('watch view', mode);
            $(me.openWatchViewBtn).addClass('active');
//            me.tabBar.tab('change tab', 'bottom-bar');
//            $(me.root.querySelector('#watch-view')).show();
//            setTimeout(function () {
//                $(me.root.querySelector('#editor-view')).show(); // fix
//            }, 1);

//            ShowTab('watch-view');
            me.openReview();
            if (mode === 'user')
                me.tags['bottom-bar'].watch();
            else if (mode === 'dev')
                me.tags['bottom-bar'].watchDev();
        };

        me.deactiveWatchBtn = function () {
            $(me.openWatchViewBtn).removeClass('active');
        };

        me.openAssetFile = function (filePath) {
            $(me.root.querySelector('#editor-view')).show();
            ShowTab('code-view');
            if (filePath.endsWith('.ico') || filePath.endsWith('.jpg') || filePath.endsWith('.png') || filePath.endsWith('.min.js')) {
                alert('not supported open image or .min.js yet');
            } else {
                me.currentFilePath = filePath;
            }
            me.openRawContentTab({
                mode:         'auto',
                lineWrapping: false
            });
            me.update();
        };

        me.openContentTab = function () {
            try {
                HideAllTab();
                me.tags['side-bar'].activeFile('content', me.currentFilePath);
                me.currentFileTitle = me.currentFilePath.split(/[/\\]/).pop();
                me.update();

//            var content = getFileContent(me.currentFilePath);
                var content = BackEnd.getContentFile(me.opts.siteName, me.currentFilePath);
                if (!content || !content.metaData || !content.metaData.layout) {
                    me.tags['content-view'].reset();
//                return;
                } else {
                    me.currentLayout = content.metaData.layout;
                    var contentConfig = BackEnd.getConfigFile(me.opts.siteName, me.currentFilePath, content.metaData.layout);
                    me.tags['content-view'].setContent(content, contentConfig);
                }

                ShowTab('content-view');
            } catch (ex) {
                console.log(ex);
                bootbox.alert('Open content failed, error ' + ex.message || ex, function () {
                });
                me.openRawContentTab({
                    readOnly: false,
                    mode:     'json-frontmatter'
                });
            }
        };

        me.openMetaTab = function () {
            try {
                HideAllTab();

                me.tags['side-bar'].activeFile('meta', me.currentFilePath);
                me.currentFileTitle = me.currentFilePath.split(/[/\\]/).pop();
                me.update();

                var meta = BackEnd.getMetaFile(me.opts.siteName, me.currentFilePath);
                var metaConfig = BackEnd.getMetaConfigFile(me.opts.siteName, me.currentFilePath);
//                console.log('metaConfig', meta, metaConfig);
//                if (!content || !content.metaData || !content.metaData.layout) {
//                    me.tags['content-view'].reset();
//                return;
//                } else {
//                    me.currentLayout = content.metaData.layout;
//                    var contentConfig = BackEnd.getConfigFile(me.opts.siteName, me.currentFilePath, content.metaData.layout);
                me.tags['meta-view'].setContent(JSON.parse(meta), metaConfig);
//                }

                ShowTab('meta-view');
            } catch (ex) {
                console.log(ex);
                bootbox.alert('Open meta failed, error ' + ex.message, function () {
                });
                me.openRawContentTab({
                    readOnly: false,
                    mode:     'json'
                });
            }
        };

        me.openMetaConfigTab = function () {
            me.currentFileTitle = me.currentFilePath.split(/[/\\]/).pop();
            HideAllTab();

            var content = BackEnd.getMetaFile(me.opts.siteName, me.currentFilePath);
            content = JSON.parse(content);
//            console.log('meta content', content);
            var contentConfig = BackEnd.getMetaConfigFile(me.opts.siteName, me.currentFilePath);

            me.tags['json-schema-config-editor'].loadContentConfig(contentConfig);
            ShowTab('config-view');

            onSaveMetaConfigView = function (newConfig) {
                console.log('save meta config');
                BackEnd.saveMetaConfigFile(me.opts.siteName, me.currentFilePath, JSON.stringify(newConfig, null, 4));
            };

            me.tags['json-schema-config-editor'].off('saveConfig');
            me.tags['json-schema-config-editor'].on('saveConfig', onSaveMetaConfigView);
        };

        me.openConfigTab = function () {
            if (me.currentFilePath.endsWith('.json'))
                me.openMetaConfigTab();
            else if (me.currentFilePath.endsWith('.md'))
                me.openContentConfigTab();
        };


        //        var contentConfigSaveEventHooked = false;
        me.openContentConfigTab = function () {

            HideAllTab();

            me.currentFileTitle = me.currentFilePath.split(/[/\\]/).pop();
            var content = BackEnd.getContentFile(me.opts.siteName, me.currentFilePath);
            if (!content.metaData.layout) {
                alert('content missing layout attribute');
                return;
            }

            var contentConfig = BackEnd.getConfigFile(me.opts.siteName, me.currentFilePath, content.metaData.layout);

            me.tags['json-schema-config-editor'].loadContentConfig(contentConfig);
            ShowTab('config-view');

            onSaveContentConfigView = function (newConfig) {
                console.log('save content config');
                BackEnd.saveConfigFile(me.opts.siteName, content.metaData.layout, JSON.stringify(newConfig, null, 4));
            };
            me.tags['json-schema-config-editor'].off('saveConfig');
            me.tags['json-schema-config-editor'].on('saveConfig', onSaveContentConfigView);
        };

        me.openRawContentTab = function (options) {
//            me.tags['side-bar'].activeFile('content', me.currentFilePath);
            me.currentFileTitle = me.currentFilePath.split(/[/\\]/).pop();
            me.tags['breadcrumb'].setPath(me.currentFilePath);
            options = options || {};
//            HideAllTab();

            var rawStr = BackEnd.getRawContentFile(me.opts.siteName, me.currentFilePath);
            // CHEAT fix front matter codemirror error
            if (rawStr.endsWith('---')) {
                rawStr += '\n';
            }
            var contentCodeEditor = me.tags['code-editor'];
            contentCodeEditor.value(rawStr, 'frontmatter');

            // todo detect file type set mode
            contentCodeEditor.setOption('mode', 'json-frontmatter');
            for (var key in options) {
                if (!options.hasOwnProperty(key)) continue;
                contentCodeEditor.setOption(key, options[key]);
            }
            ShowTab('code-view');
        };

        me.openFile = function (filePath) {
//            $(me.root.querySelector('#editor-view')).show();
            me.tabBar.tab('change tab', 'editor-view', 'home openFile', filePath);
            //$(me.root.querySelector('#watch-view')).hide();
            if (!me.tags['breadcrumb']) {
                console.log('breadcrumb', me.tags);
                console.trace('bug');
            } else {
                me.tags['breadcrumb'].setPath(filePath);
            }
            me.currentFilePath = filePath;


            if (filePath.endsWith('.md')) {
//                console.log('openContentTab');
                me.openContentTab();
//            } else if (filePath.endsWith('.schema.json')) {
//                me.openConfigTab();
            } else if (filePath.endsWith('.html')) {
                me.currentLayout = me.currentFilePath.split(/[/\\]/);
                me.currentLayout.shift();
                me.currentLayout = me.currentLayout.join('/');
                me.openLayoutTab();
            } else if (filePath.endsWith('.json')) {
//                console.log('filePath', filePath);
//                if (filePath.startsWith('content/metadata/category') || filePath.startsWith('content/metadata/tag')) {
//                    console.log('open category config file');
//                    me.openRawContentTab();
//                } else if (filePath.startsWith('content/metadata')) {
//                    console.log('openMetaTab');
                me.openMetaTab();
//                }
                // openMetaConfigTab
//                me.openRawContentTab();
            }
            me.update();
        };

        me.openMetadataFile = function (filePath) {
            me.openFile(filePath);
        };

        me.save = function () {
//            var curTabHref = $(me.root).find('[role="presentation"].active>a').attr('href');
            let filePath;
            switch (me.curTab) {
                case 'content-view':
                    console.log('save content data');
                    let content = me.tags['content-view'].getContent();
                    filePath = me.currentFilePath;
                    BackEnd.saveContentFile(me.opts.siteName, me.currentFilePath, content.metaData, content.markdownData);

                    let parts = me.currentFilePath.split(/\//g);
                    parts.shift(); // remove /content
                    let key = parts.join('/');
                    window.siteContentIndexes[key] = content.metaData;
                    riot.event.trigger('contentMetaDataUpdated', key, content.metaData);
                    break;
                case 'meta-view':
                    console.log('save meta data', me.currentFilePath);
                    var meta = me.tags['meta-view'].getContent();
                    filePath = me.currentFilePath;
                    BackEnd.saveMetaFile(me.opts.siteName, me.currentFilePath, meta);
                    if (me.currentFilePath.startsWith('content/metadata/category/')) {
                        // category udpated
                        let fileName = me.currentFilePath.split(/\//g).pop();
                        let parts = fileName.split('.');
                        parts.pop();
                        let key = parts.join('.');
                        window.siteCategoryIndexes[key] = meta;
                    }
                    break;
                case 'code-view':
                    let rawContent = me.tags['code-editor'].value();
                    filePath = me.currentFilePath;
                    // TODO this code view open not just only raw content file but also asset
                    BackEnd.saveRawContentFile(me.opts.siteName, me.currentFilePath, rawContent);
                    break;
                case 'layout-view':
                    var layoutContent = me.tags['monaco-editor'].value();
                    filePath = me.currentLayout;
                    BackEnd.saveLayoutFile(me.opts.siteName, me.currentLayout, layoutContent);
                    break;
                case 'config-view':
                    var contentConfig = me.tags['json-schema-config-editor'].getContentConfig();
                    filePath = me.currentFilePath;
                    filePath = me.currentFilePath.split('.');
                    filePath.pop();
                    filePath.join('.');
                    if (me.currentFilePath.endsWith('.json')) {
                        console.log('save meta config');
                        filePath += '.meta-schema.json';
                        BackEnd.saveMetaConfigFile(me.opts.siteName, me.currentFilePath, JSON.stringify(contentConfig, null, 4));
                    } else if (me.currentFilePath.endsWith('.md')) {
                        console.log('save content config');
                        filePath += '.schema.json';
                        BackEnd.saveConfigFile(me.opts.siteName, me.currentLayout, JSON.stringify(contentConfig, null, 4));
                    }
                    break;
                default:
                    // no commit
                    return;
            }
            BackEnd.gitGenMessage(me.opts.siteName).then(function (msg) {
                return BackEnd.gitCommit(me.opts.siteName, msg);
            });
        };

        me.deleteFile = function () {
//            var curTabHref = $(me.root).find('[role="presentation"].active>a').attr('href');
            switch (me.curTab) {
                case 'content-view':
                case 'code-view':
                    var contentFilePath = me.currentFilePath;
                    if (contentFilePath.startsWith('content')) {
                        var parts = contentFilePath.split(/[\\\/]/);
                        parts.shift();
                        contentFilePath = parts.join('/');
                    }
                    bootbox.confirm({
                        title:    'Delete',
                        message:  `Are you sure you want to delete content "${contentFilePath}" ?`,
                        buttons:  {
                            'cancel':  {
                                label:     'Cancel',
                                className: 'ui button default'
                            },
                            'confirm': {
                                label:     'Delete',
                                className: 'ui button red'
                            }
                        },
                        callback: function (result) {
                            if (result) {
                                BackEnd.softDeleteContentFile(me.opts.siteName, contentFilePath);

                                riot.event.trigger('removeFile');
                                me.curTab = '';
                                me.tags['breadcrumb'].setPath('');
                                me.update();
                                me.tags['content-view'].reset();
                                me.currentFilePath = '';
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
            me.tags['new-layout-dialog'].show();
        };

        me.newCategory = function () {
            me.tags['new-category-dialog'].show();
        };

        me.newTag = function () {
            me.tags['new-tag-dialog'].show();
        };

        me.newContent = function () {
            var layoutList = BackEnd.getRootLayoutList(me.siteName);
            me.tags['new-content-dialog'].updateLayoutList(layoutList);
            me.tags['new-content-dialog'].show();
        };

        var onAddLayout = function (layoutFileName) {
            try {
                var newFile = BackEnd.newLayoutFile(me.siteName, layoutFileName);
                BackEnd.gitAdd(me.siteName, newFile.path);
                riot.event.trigger('closeNewLayoutDialog');
                setTimeout(function () {
                    me.tags['side-bar'].activeFile('layout', 'layout/' + layoutFileName);
                }, 300);
            } catch (ex) {
                console.log('addLayout', ex);
                bootbox.alert('create layout failed, error ' + ex.message);
            }
        };

        var onAddContent = function (layoutFileName, contentTitle, contentFileName, contentCategory, contentTag, isFrontPage) {
            try {
                var newFile = BackEnd.newContentFile(me.siteName, layoutFileName, contentTitle, contentFileName, contentCategory, contentTag, isFrontPage);
                var newContentFilePath = newFile.path;
                // reload sidebar file list
                riot.event.trigger('addContentFile', newContentFilePath);
                riot.event.trigger('closeNewContentDialog');
                me.openFile(newContentFilePath);
                me.tags['side-bar'].activeFile('content', newContentFilePath);
                // run git add
                BackEnd.gitAdd(me.siteName, newContentFilePath);
            } catch (ex) {
                console.log('addContent', ex);
                bootbox.alert('create content failed, error ' + ex.message);
            }
        };

        var onAddCategory = function (categoryName, categoryFileName) {
            try {
                var newFile = BackEnd.newCategory(me.siteName, categoryName, categoryFileName);
                BackEnd.gitAdd(me.siteName, newFile.path);

                var metaConfig = BackEnd.getMetaConfigFile(me.siteName, newFile.path);
                window.siteCategoryIndexes[categoryName] = newFile.data;
                riot.event.trigger('closeNewCategoryDialog');
            } catch (ex) {
                console.log('addCategory failed', ex);
                bootbox.alert('create category failed, error ' + ex.message);
            }
        };

        var onAddTag = function (tagName, tagFileName) {
            try {
                var newFile = BackEnd.newTag(me.siteName, tagName, tagFileName);
                BackEnd.gitAdd(me.siteName, newFile.path);
                // gen meta config add to cache
                var metaConfig = BackEnd.getMetaConfigFile(me.siteName, newFile.path);
                window.siteTagIndexes[tagName] = newFile.data;

                riot.event.trigger('closeNewTagDialog');
            } catch (ex) {
                console.log('addTag failed', ex);
                bootbox.alert('create tag failed, error ' + ex.message);
            }
        };

        var onChooseMediaFile = function (cb) {
            dialog.showOpenDialog({
                properties: ['openFile'],
                filters:    [
                    {name: 'All Media Files', extensions: ['*']}
                ]
            }, function (filePaths) {
                console.log('onChooseMediaFile callback');
                if (!filePaths || filePaths.length !== 1) return;
                var filePath = filePaths[0];
                BackEnd.addMediaFile(me.siteName, filePath, function (error, relativePath) {
                    if (error) {
                        console.log('addMediaFile', error);
                    } else {
                        cb(relativePath);
                    }
                })
            });
        };

        riot.event.on('chooseMediaFile', onChooseMediaFile);
        riot.event.on('addLayout', onAddLayout);
        riot.event.on('addContent', onAddContent);
        riot.event.on('addCategory', onAddCategory);
        riot.event.on('addTag', onAddTag);

        me.deployToGitHub = function () {
            me.tags['progress-dialog'].show('Deploy to EasyWeb hosting');
            BackEnd.gitPushGhPages(me.siteName, me.tags['progress-dialog'].appendText).then(function () {
                me.tags['progress-dialog'].enableClose();
//                var text = me.tags['progress-dialog'].getText();
//                var matches = text.split(/https?:\/\/github\.com\/([^\/]+)\/(.+)/);
//                if (matches.length > 1) {
//                    var ghPageUrl = 'https://' + matches[1] + '.github.io/' + matches[2] + '/';
//                    var msg = 'Deployed Url <a href="' + ghPageUrl + '" target="_blank">' + ghPageUrl + '</a>';
//                    me.tags['progress-dialog'].showMessage(msg);
//                }
                var msg = 'Deployed Url <a href="http://' + me.opts.siteReviewUrl + '" target="_blank">' + me.opts.siteReviewUrl + '</a>';
                me.tags['progress-dialog'].showMessage(msg);
            }).catch(function (err) {
                console.log(err);
                me.tags['progress-dialog'].enableClose();
            });
        };

        me.syncToGitHub = function () {
            // TODO detect .git folder exists if not show init dialog
            console.log('syncToGitHub', __dirname);
//            try {
//                var siteGitPath =;
//                var stat = Fs.statSync(fullPath);
//                if (stat.isDirectory())
//            } catch(ex) {}

            me.tags['progress-dialog'].show('Sync to EasyWeb');
            BackEnd.gitPushGitHub(me.siteName, me.tags['progress-dialog'].appendText).then(function () {
                me.tags['progress-dialog'].enableClose();
                // refresh current file to load new changes
                if (me.currentFilePath) {
                    switch (me.curTab) {
                        case 'content-view':
                        case 'meta-view':
                        case 'code-view':
                        case 'layout-view':
                            me.openFile(me.currentFilePath);
                            break;
                        default:
                            return;
                    }
                }
            }).catch(function (err) {
                console.log(err);
                me.tags['progress-dialog'].enableClose();
            });
        };

        me.showGitHubSetting = function () {
            me.tags['github-init-dialog'].show();
            me.tags['github-init-dialog'].event.one('save', function (info) {
                me.tags['github-init-dialog'].hide();
                var repoUrl = 'https://' + encodeURIComponent(info.username) + ':' + encodeURIComponent(info.password) + '@' + (info.url.split('https://')[1]);
                me.tags['progress-dialog'].show('Init GitHub Setting');
                BackEnd.gitInitSite(me.siteName, repoUrl, me.tags['progress-dialog'].appendText).then(function () {
                    me.tags['progress-dialog'].enableClose();
                    me.checkGhPageStatus();
                }).catch(function (err) {
                    console.log(err);
                    me.tags['progress-dialog'].enableClose();
                });
            });
        };

        me.showFtpDialog = function () {
            me.tags['deploy-ftp-dialog'].show();
        };
    </script>
</home>
