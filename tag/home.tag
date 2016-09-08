<home>
    <new-tag-dialog site-name={opts.siteName}></new-tag-dialog>
    <new-category-dialog site-name={opts.siteName}></new-category-dialog>
    <new-content-dialog site-name={opts.siteName}></new-content-dialog>
    <new-layout-dialog site-name={opts.siteName}></new-layout-dialog>
    <progress-dialog site-name={opts.siteName}></progress-dialog>
    <github-init-dialog site-name={opts.siteName}></github-init-dialog>
    <deploy-ftp-dialog site-name={opts.siteName}></deploy-ftp-dialog>
    <nav class="navbar navbar-default navbar-fixed-top" style="padding-top: 5px; height: 38px; min-height: 38px;">
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-6 pull-left">
                    <a href="#goto-home" onclick="{goToLandingPage}" class="btn btn-default btn-sm" aria-haspopup="true" aria-expanded="false">
                        <i class="fa fa-fw fa-home"></i>Home
                    </a>
                    <a href="#add-page" onclick="{newContent}" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" title="Create new page using existing layout">
                        <i class="fa fa-fw fa-plus"></i> Page
                    </a>
                    <a href="#add-category" onclick="{newCategory}" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" title="Create new category" hide="{User.accountType == 'user'}">
                        <i class="fa fa-fw fa-plus"></i> Category
                    </a>
                    <a href="#add-tag" onclick="{newTag}" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" title="Create new tag" hide="{User.accountType == 'user'}">
                        <i class="fa fa-fw fa-plus"></i> Tag
                    </a>
                    <a href="#add-layout" onclick="{newLayout}" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" title="Create new layout that using for a page" hide="{User.accountType == 'user'}">
                        <i class="fa fa-fw fa-plus"></i> Layout
                    </a>
                </div>
                <div class="pull-right">
                    <div class="btn-group" data-toggle="buttons">
                        <a class="btn btn-default btn-sm" href="#build" id="openWatchViewBtn" onclick="{openWatchView.bind(this, 'user')}" title="Build this website on local PC to preview">
                            <i class="fa fa-fw fa-eye"></i> Build
                        </a>

                        <div class="btn-group" role="group">
                            <button type="button" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <span class="caret"></span>
                            </button>
                            <ul class="dropdown-menu">
                                <li hide="{User.accountType == 'user'}"><a href="#" onclick="{openWatchView.bind(this, 'dev')}" title="Build this website on local PC to preview (Dev mode)"><i class="fa fa-fw fa-cubes"></i> Build Dev</a></li>
                                <li><a href="#" onclick="{refreshWatchView}" title="restart to refresh preview website"><i class="fa fa-fw fa-refresh"></i> Refresh</a></li>
                            </ul>
                        </div>
                        <button class="btn btn-default btn-sm" data-toggle="tab" id="openExternalReviewBtn" role="tab" title="Open on browser (IE, Firefox, Chrome,...) to Preview" onclick="{openExternalReview}" disabled>
                            <i class="fa fa-fw fa-external-link"></i> On Browser
                        </button>
                    </div>
                    <div class="btn-group" data-toggle="buttons">
                        <a href="#" class="btn btn-default navbar-btn btn-sm" onclick="{syncToGitHub}" title="Synchronize to Cloud">
                            <i class="fa fa-fw fa-github"></i> Sync
                        </a>
                        <a href="#" class="btn btn-default navbar-btn btn-sm" onclick="{deployToGitHub}" title="Deploy website to live domain">
                            Deploy
                        </a>
                        <div class="btn-group" role="group">
                            <button type="button" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <span class="caret"></span>
                            </button>
                            <ul class="dropdown-menu pull-right">
                                <li><a href="#" onclick="{showFtpDialog}" title="Upload to Ftp server">To FTP server</a></li>
                                <li><a href="#" onclick="{showSetDomainDialog}" title="Set domain for website"><i class="fa fa-fw fa-globe"></i> Set Domain</a></li>
                            </ul>
                        </div>
                        <a class="btn btn-default navbar-btn btn-sm dropdown-toggle" href="#" onclick="{showGitHubSetting}" title="Init Cloud using github account" hide="{gitHubInited}">
                            Init
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <div class="container-fluid" style="padding-top: 40px;">
        <div class="row">
            <div class="col-xs-4 col-sm-4 col-md-3 col-lg-3" style="height: calc(100vh - 700px)">
                <side-bar site-name={opts.siteName}></side-bar>
            </div>

            <div class="tab-content col-xs-8 col-sm-8 col-md-9 col-lg-9">
                <watch-view id="watch-view" site-name="{siteName}" style="display:none;"></watch-view>
                <div class="tab-pane" id="editor-view" role="tabpanel" style="height: {getFormEditorHeight()}; overflow: auto;">
                    <div class="btn-group" data-toggle="buttons">
                        <a class=" btn btn-default navbar-btn btn-sm" href="#content-view" data-toggle="tab" role="tab" onclick="{openContentTab}" show="{
                            curTab == 'content-view' ||
                            ((curTab == 'code-view' || curTab == 'config-view') && currentFilePath.endsWith('.md'))
                            }">
                            <input type="radio" name="options"><i class="fa fa-fw fa-newspaper-o"></i> Content
                        </a>
                        <a class=" btn btn-default navbar-btn btn-sm" show="{isShowMetaTab()}" href="#meta-view" data-toggle="tab" role="tab" onclick="{openMetaTab}">
                            <input type="radio" name="options"><i class="fa fa-fw fa-newspaper-o"></i> Meta
                        </a>
                        <a class="btn btn-default navbar-btn btn-sm" href="#code-view" data-toggle="tab" role="tab" onclick="{openRawContentTab}" show="{User.accountType == 'dev'}">
                            <input type="radio" name="options">Raw
                        </a>
                        <a class="btn btn-default navbar-btn btn-sm" href="#layout-view" data-toggle="tab" role="tab" onclick="{openLayoutTab}" show="{isShowLayoutTab()}">
                            <input type="radio" name="options"><i class="fa fa-fw fa-code"></i> Layout
                        </a>
                        <a class="btn btn-default navbar-btn btn-sm" href="#config-view" data-toggle="tab" role="tab" onclick="{openConfigTab}" show="{isShowConfigTab()}">
                            <input type="radio" name="options"><i class="fa fa-fw fa-cog"></i> Config
                        </a>
                    </div>
                    <div class="pull-right">
                        <div class="btn-group" data-toggle="buttons">
                            <a class="btn btn-danger navbar-btn btn-sm" href="#" onclick="{deleteFile}" hide="{
                            curTab === 'meta-view' && User.accountType == 'user'
                            }">
                                <i class="fa fa-fw fa-remove"></i>Delete
                            </a>
                            <a class="btn btn-primary navbar-btn btn-sm" onclick="{save}"><i class="fa fa-save"></i> Save</a>
                        </div>
                    </div>
                    <!-- EDITOR PANEL -->
                    <div class="panel panel-default">
                        <div class="panel-heading panel-heading-sm">
                            <breadcrumb site_name="{opts.siteName}"></breadcrumb>
                        </div>
                        <div class="panel-body">
                            <div class="tab-content">
                                <content-view site-name="{siteName}" id="content-view" role="tabpanel" class="tab-pane"></content-view>
                                <meta-view site-name="{siteName}" id="meta-view" role="tabpanel" class="tab-pane"></meta-view>
                                <code-editor site-name="{siteName}" id="code-view" role="tabpanel" class="tab-pane"></code-editor>
                                <code-editor site-name="{siteName}" id="layout-view" role="tabpanel" class="tab-pane"></code-editor>
                                <config-view site-name="{siteName}" id="config-view" role="tabpanel" class="tab-pane"></config-view>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <script>
        var me = this;
        var dialog = require('electron').remote.dialog;
        var Path = require('path');
        me.test = true;
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

        // handler onSave content config view
        var onSaveContentConfigView, onSaveMetaConfigView;

        me.getFormEditorHeight = function () {
            // TODO handle case console build success and failure
            // show both watch and editor
            if ($(me.openWatchViewBtn).hasClass('active') && me.curFilePath != '') {
                return 'calc(50vh - 30px); margin-top: 20px; padding: 0;';
            } else {
                return 'calc(100vh - 60px)';
            }
        };

        me.isShowMetaTab = function () {
            return me.curTab == 'meta-view' ||
                    ( me.curTab == 'config-view' && me.currentFilePath.endsWith('.json')) ||
                    (
                            me.curTab == 'code-view' &&
                            me.currentFilePath.endsWith('.json') && !me.currentFilePath.startsWith('content/metadata/category') && !me.currentFilePath.startsWith('content/metadata/tag')
                    );

        };

        me.isShowLayoutTab = function () {
            return User.accountType == 'dev' &&
                    ( me.curTab == 'content-view' ||
                            ( me.curTab == 'code-view' && me.currentFilePath.endsWith('.md') ) ||
                            ( me.curTab == 'config-view' && me.currentFilePath.endsWith('.md') )
                    )
        };

        me.isShowConfigTab = function () {
            return User.accountType == 'dev' &&
                    (
                            me.curTab == 'meta-view' ||
                            me.curTab == 'config-view' ||
                            me.curTab == 'content-view' ||
                            ( me.curTab == 'code-view' && me.currentFilePath.endsWith('.md') ) ||
                            ( me.curTab == 'code-view' && !me.currentFilePath.startsWith('content/metadata/category/') && !me.currentFilePath.startsWith('content/metadata/tag/') && me.currentFilePath.endsWith('.json'))
                    )
        };

        me.checkGhPageStatus = function () {
            BackEnd.isGhPageInitialized(me.opts.siteName + '/build').then(function (initialized) {
                console.log('home github initialized', initialized);
                me.gitHubInited = initialized;
                me.update();
            }).catch(function (ex) {
                if (ex.message.indexOf('ENOENT') != -1) {
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

        me.on('unmount', function () {
            riot.api.off('watchSuccess', onWatchSuccess);
            riot.api.off('watchFailed', onWatchFailed);
            riot.api.off('chooseMediaFile', onChooseMediaFile);
            riot.api.off('addLayout', onAddLayout);
            riot.api.off('addContent', onAddContent);
            riot.api.off('addCategory', onAddCategory);
            riot.api.off('addTag', onAddTag);

            riot.api.off('codeEditor.save', me.saveByKeyboard);
            riot.api.off('watchFailed', me.deactiveWatchBtn);
        });

        me.on('mount', function () {
            me.checkGhPageStatus();

            riot.api.on('codeEditor.save', me.saveByKeyboard);
            riot.api.on('watchFailed', me.deactiveWatchBtn);

            setTimeout(function () {
                var indexFilePath = 'sites/' + me.siteName + '/content/index.md';
                if (BackEnd.fileExists(indexFilePath) == true) {
                    me.openFile('content/index.md');
                }
            }, 1);
        });

        me.goToLandingPage = function () {
            me.unmount(true);
            riot.api.trigger('showLandingPage');
        };

        function HideAllTab() {
//            console.trace('HideAllTab', $(me.root).find('a[role="tab"]'));
            $(me.root).find('a[role="tab"]').removeClass('active');

            me.tags['config-view'].event.off('saveConfig', onSaveContentConfigView);
            me.tags['config-view'].event.off('saveConfig', onSaveMetaConfigView);
        }

        function ShowTab(name) {
            me.curTab = name;
            var elm = $(me.root).find('a[href="#' + name + '"]');
//            console.trace('ShowTab', elm);
            elm.tab('show');
            elm.addClass('active');
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
                    bootbox.alert('Invalid domain', function () {
                        setTimeout(function () {
                            $('.bootbox-input.bootbox-input-text.form-control').focus();
                        }, 1);
                    });
                    return false;
                }
                BackEnd.setDomain(me.opts.siteName, domain);
            });
        };

        me.refreshWatchView = function () {
            me.openWatchView();
            riot.api.trigger('refreshWatch');
        };

        me.openLayoutTab = function () {
            me.currentFileTitle = me.currentFilePath.split(/[/\\]/).pop();
            me.update();

            me.tags['breadcrumb'].setPath('layout/' + me.currentLayout);
            var fileContent = BackEnd.getLayoutFile(me.opts.siteName, me.currentLayout);
            me.tags['side-bar'].activeFile('layout-file-list', 'layout/' + me.currentLayout);
            me.tags['code-editor'][1].value(fileContent);
            me.tags['code-editor'][1].setOption('readOnly', false);
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
            $(me.root.querySelector('#watch-view')).show();
            setTimeout(function () {
                $(me.root.querySelector('#editor-view')).show(); // fix
            }, 1);

//            ShowTab('watch-view');
            if (mode === 'user')
                me.tags['watch-view'].watch();
            else if (mode === 'dev')
                me.tags['watch-view'].watchDev();
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
                me.tags['side-bar'].activeFile('content-file-list', me.currentFilePath);
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
                bootbox.alert('Open content failed, error ' + ex.message, function () {
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

                me.tags['side-bar'].activeFile('metadata-file-list', me.currentFilePath);
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

            me.tags['config-view'].loadContentConfig(contentConfig);
            ShowTab('config-view');

            onSaveMetaConfigView = function (configFieldName, newConfig) {
                console.log('save meta config');
                me.tags['config-view'].event.off('saveConfig', onSaveMetaConfigView);

                newConfig.name = configFieldName;
                // ghi de` new setting vo contentConfig
                for (var i = 0; i < contentConfig.length; i++) {
                    if (contentConfig[i].name === configFieldName) {
                        contentConfig[i] = newConfig;
                        break;
                    }
                }
                BackEnd.saveMetaConfigFile(me.opts.siteName, me.currentFilePath, JSON.stringify(contentConfig, null, 4));
                // refresh config view
                me.openMetaConfigTab();
            };

            me.tags['config-view'].event.on('saveConfig', onSaveMetaConfigView);
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

            me.tags['config-view'].loadContentConfig(contentConfig);
            ShowTab('config-view');

            onSaveContentConfigView = function (configFieldName, newConfig) {
                console.log('save content config');
                var contentConfig = BackEnd.getConfigFile(me.opts.siteName, me.currentFilePath, content.metaData.layout);
                newConfig.name = configFieldName;
                // ghi de` new setting vo contentConfig
                for (var i = 0; i < contentConfig.length; i++) {
                    if (contentConfig[i].name === configFieldName) {
                        contentConfig[i] = newConfig;
                        break;
                    }
                }
                BackEnd.saveConfigFile(me.opts.siteName, content.metaData.layout, JSON.stringify(contentConfig, null, 4));
                me.openContentConfigTab(); // refresh view
            };

            me.tags['config-view'].event.on('saveConfig', onSaveContentConfigView);
        };

        me.openRawContentTab = function (options) {
//            me.tags['side-bar'].activeFile('content-file-list', me.currentFilePath);
            me.currentFileTitle = me.currentFilePath.split(/[/\\]/).pop();
            me.tags['breadcrumb'].setPath(me.currentFilePath);
            options = options || {};
//            HideAllTab();

            var rawStr = BackEnd.getRawContentFile(me.opts.siteName, me.currentFilePath);
            var contentCodeEditor = me.tags['code-editor'][0];
            contentCodeEditor.value(rawStr);

            // todo detect file type set mode
            contentCodeEditor.setOption('mode', 'json-frontmatter');
            for (var key in options) {
                if (!options.hasOwnProperty(key)) continue;
                contentCodeEditor.setOption(key, options[key]);
            }
            ShowTab('code-view');
        };

        me.openFile = function (filePath) {
            $(me.root.querySelector('#editor-view')).show();
            //$(me.root.querySelector('#watch-view')).hide();
            if (me.tags['breadcrumb'] == null) {
                console.log('breadcrumb', me.tags);
                console.trace('bug');
            } else {
                me.tags['breadcrumb'].setPath(filePath);
            }
            me.currentFilePath = filePath;


            if (filePath.endsWith('.md')) {
                me.openContentTab();
//            } else if (filePath.endsWith('.config.json')) {
//                me.openConfigTab();
            } else if (filePath.endsWith('.html')) {
                me.currentLayout = me.currentFilePath.split(/[/\\]/);
                me.currentLayout.shift();
                me.currentLayout = me.currentLayout.join('/');
                me.openLayoutTab();
            } else if (filePath.endsWith('.json')) {
//                console.log('filePath', filePath);
                if (filePath.startsWith('content/metadata/category') || filePath.startsWith('content/metadata/tag')) {
//                    console.log('open category config file');
                    me.openRawContentTab();
                } else if (filePath.startsWith('content/metadata')) {
//                    console.log('openMetaTab');
                    me.openMetaTab();
                }
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
            var filePath;
            switch (me.curTab) {
                case 'content-view':
                    console.log('save content data');
                    var content = me.tags['content-view'].getContent();
                    filePath = me.currentFilePath;
                    BackEnd.saveContentFile(me.opts.siteName, me.currentFilePath, content.metaData, content.markdownData);
                    break;
                case 'meta-view':
                    console.log('save meta data');
                    var meta = me.tags['meta-view'].getContent();
                    filePath = me.currentFilePath;
                    BackEnd.saveMetaFile(me.opts.siteName, me.currentFilePath, meta);
                    break;
                case 'code-view':
                    var rawContent = me.tags['code-editor'][0].value();
                    filePath = me.currentFilePath;
                    // TODO this code view open not just only raw content file but also asset
                    BackEnd.saveRawContentFile(me.opts.siteName, me.currentFilePath, rawContent);
                    break;
                case 'layout-view':
                    var layoutContent = me.tags['code-editor'][1].value();
                    filePath = me.currentLayout;
                    BackEnd.saveLayoutFile(me.opts.siteName, me.currentLayout, layoutContent);
                    break;
                case 'config-view':
                    var contentConfig = me.tags['config-view'].getContentConfig();
                    filePath = me.currentFilePath;
                    filePath = me.currentFilePath.split('.');
                    filePath.pop();
                    filePath.join('.');
                    if (me.currentFilePath.endsWith('.json')) {
                        console.log('save meta config');
                        filePath += '.meta.json';
                        BackEnd.saveMetaConfigFile(me.opts.siteName, me.currentFilePath, JSON.stringify(contentConfig, null, 4));
                    } else if (me.currentFilePath.endsWith('.md')) {
                        console.log('save content config');
                        filePath += '.config.json';
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
                                riot.api.trigger('removeFile');
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
                riot.api.trigger('closeNewLayoutDialog');
                setTimeout(function () {
                    me.tags['side-bar'].activeFile('layout-file-list', 'layout/' + layoutFileName);
                }, 100);
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
                riot.api.trigger('addContentFile', newContentFilePath);
                riot.api.trigger('closeNewContentDialog');
                me.openFile(newContentFilePath);
                me.tags['side-bar'].activeFile('content-file-list', newContentFilePath);
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
                riot.api.trigger('closeNewCategoryDialog');
            } catch (ex) {
                console.log('addCategory failed', ex);
                bootbox.alert('create category failed, error ' + ex.message);
            }
        };

        var onAddTag = function (tagName, tagFileName) {
            try {
                var newFile = BackEnd.newTag(me.siteName, tagName, tagFileName);
                BackEnd.gitAdd(me.siteName, newFile.path);
                riot.api.trigger('closeNewTagDialog');
            } catch (ex) {
                console.log('addTag failed', ex);
                bootbox.alert('create tag failed, error ' + ex.message);
            }
        };

        var onWatchSuccess = function () {
            me.openExternalReviewBtn.disabled = false;
        };

        var onWatchFailed = function () {
            me.openExternalReviewBtn.disabled = true;
//            $(openWdatchViewBtn).removeClass('active');
        };

        var onChooseMediaFile = function (cb) {
            dialog.showOpenDialog({
                properties: ['openFile'],
                filters:    [
                    {name: 'All Media Files', extensions: ['*']}
                ]
            }, function (filePaths) {
                if (!filePaths || filePaths.length != 1) return;
                var filePath = filePaths[0];
                BackEnd.addMediaFile(me.siteName, filePaths[0], function (error, relativePath) {
                    if (error) {
                        console.log('addMediaFile', error);
                    } else {
                        cb(relativePath);
                    }
                })
            });
        };

        riot.api.on('watchSuccess', onWatchSuccess);
        riot.api.on('watchFailed', onWatchFailed);
        riot.api.on('chooseMediaFile', onChooseMediaFile);
        riot.api.on('addLayout', onAddLayout);
        riot.api.on('addContent', onAddContent);
        riot.api.on('addCategory', onAddCategory);
        riot.api.on('addTag', onAddTag);

        me.deployToGitHub = function () {
            me.tags['progress-dialog'].show('Deploy to GitHub');
            BackEnd.gitPushGhPages(me.siteName, me.tags['progress-dialog'].appendText).then(function () {
                me.tags['progress-dialog'].enableClose();
                var text = me.tags['progress-dialog'].getText();
                var matches = text.split(/https:\/\/github\.com\/([^\/]+)\/(.+)/);
                if (matches.length > 1) {
                    var ghPageUrl = 'https://' + matches[1] + '.github.io/' + matches[2] + '/';
                    var msg = 'GitHub page url <a href="' + ghPageUrl + '" target="_blank">' + ghPageUrl + '</a>';
                    me.tags['progress-dialog'].showMessage(msg);
                }
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

            me.tags['progress-dialog'].show('Sync to GitHub');
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

        me.openExternalReview = function () {
            me.tags['watch-view'].openExternalBrowser();
        };

        me.showFtpDialog = function () {
            me.tags['deploy-ftp-dialog'].show();
        };
    </script>
</home>
