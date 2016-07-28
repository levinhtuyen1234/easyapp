<home>
    <new-content-dialog></new-content-dialog>
    <new-layout-dialog></new-layout-dialog>
    <progress-dialog></progress-dialog>
    <github-init-dialog></github-init-dialog>
    <nav class="navbar navbar-default">
        <br/>
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-4 pull-left">
                    <a href="#" onclick="{goToLandingPage}" class="btn btn-default btn-sm" aria-haspopup="true" aria-expanded="false">
                        <i class="fa fa-fw fa-home"></i>Home
                    </a>
                    <a href="#" onclick="{newContent}" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" title="Create new page using existing layout">
                        <i class="fa fa-fw fa-plus"></i> Add Page
                    </a>
                    <a href="#" onclick="{newLayout}" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" title="Create new layout that using for a page" hide="{User.accountType == 'user'}">
                        <i class="fa fa-fw fa-plus"></i> Add Layout
                    </a>
                </div>
                <div class="pull-right">
                    <div class="btn-group" data-toggle="buttons">
                        <a class="btn btn-default btn-sm" href="#watch-view" id="openWatchViewBtn" data-toggle="tab" role="tab" onclick="{openWatchView}" title="Build this website on local PC to preview">
                            <input type="radio" name="options"><i class="fa fa-fw fa-eye"></i> Build
                        </a>
                        <a class="btn btn-default btn-sm" href="#watch-view" id="openWatchViewDevBtn" data-toggle="tab" role="tab" onclick="{openWatchView.bind(this, 'dev')}" title="Build this website on local PC to preview (Dev mode)" hide="{User.accountType == 'user'}">
                            <input type="radio" name="options">Build Dev
                        </a>
                        <div class="btn-group" role="group">
                            <button type="button" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <span class="caret"></span>
                            </button>
                            <ul class="dropdown-menu">
                                <li><a href="#" onclick="{refreshWatchView}" title="restart to refresh preview website"><i class="fa fa-refresh"></i> Refresh</a></li>
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
                        <a class="btn btn-default navbar-btn btn-sm dropdown-toggle" href="#" onclick="{showGitHubSetting}" title="Init Cloud using github account" hide="{gitHubInited}">
                            Init
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <div class="container-fluid">
        <div class="row">
            <div class="col-xs-4 col-sm-4 col-md-4 col-lg-2" style="height: calc(100vh - 180px)">
                <side-bar site_name={opts.siteName}></side-bar>
            </div>

            <div class="tab-content">
                <div class="col-xs-8 col-sm-8 col-md-8 col-lg-10 tab-pane" id="editor-view" role="tabpanel">
                    <div class="btn-group" data-toggle="buttons">
                        <a class=" btn btn-default navbar-btn btn-sm" href="#content-view" data-toggle="tab" role="tab" onclick="{openContentTab}" show="{curTab == 'content-view' || ((curTab == 'code-view' || curTab == 'config-view') && currentFilePath.endsWith('.md'))}">
                            <input type="radio" name="options"><i class="fa fa-fw fa-newspaper-o"></i> Content
                        </a>
                        <a class=" btn btn-default navbar-btn btn-sm" show="{curTab == 'meta-view' || ((curTab == 'code-view' || curTab == 'config-view') && currentFilePath.endsWith('.json'))}" href="#meta-view" data-toggle="tab" role="tab" onclick="{openMetaTab}">
                            <input type="radio" name="options"><i class="fa fa-fw fa-newspaper-o"></i> Meta
                        </a>
                        <a class="btn btn-default navbar-btn btn-sm" href="#code-view" data-toggle="tab" role="tab" onclick="{openRawContentTab}">
                            <input type="radio" name="options">Raw
                        </a>
                        <a class="btn btn-default navbar-btn btn-sm" href="#layout-view" data-toggle="tab" role="tab" onclick="{openLayoutTab}" show="{
                            User.accountType == 'dev' && (
                                curTab == 'content-view' || (
                                    curTab == 'code-view' &&
                                    currentFilePath.endsWith('.md')
                                ) || (
                                    curTab == 'config-view' &&
                                    currentFilePath.endsWith('.md')
                                )
                            )}">
                            <input type="radio" name="options"><i class="fa fa-fw fa-code"></i> Layout
                        </a>
                        <a class="btn btn-default navbar-btn btn-sm" href="#config-view" data-toggle="tab" role="tab" onclick="{openConfigTab}" show="{
                            User.accountType == 'dev' && (
                                curTab == 'meta-view' ||
                                curTab == 'config-view' ||
                                curTab == 'content-view' || (
                                    curTab == 'code-view' && (
                                        currentFilePath.endsWith('.json') ||
                                        currentFilePath.endsWith('.md')
                                    )
                                )
                            )}">
                            <input type="radio" name="options"><i class="fa fa-fw fa-cog"></i> Config
                        </a>
                    </div>
                    <div class="pull-right">
                        <div class="btn-group" data-toggle="buttons">
                            <a class="btn btn-danger navbar-btn btn-sm" href="#" onclick="{deleteFile}">
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
                                <content-view id="content-view" role="tabpanel" class="tab-pane"></content-view>
                                <meta-view id="meta-view" role="tabpanel" class="tab-pane"></meta-view>
                                <code-editor id="code-view" role="tabpanel" class="tab-pane"></code-editor>
                                <code-editor id="layout-view" role="tabpanel" class="tab-pane"></code-editor>
                                <config-view id="config-view" role="tabpanel" class="tab-pane"></config-view>
                            </div>
                        </div>
                    </div>
                </div>
                <watch-view id="watch-view" site_name="{siteName}" role="tabpanel" class="tab-pane"></watch-view>
            </div>
        </div>
    </div>

    <script>
        var me = this;
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

        me.on('mount', function () {
//            riot.mount('side-bar', {siteName: opts.siteName});
//            riot.mount('breadcrumb', {path: opts.siteName});
            // open index.md file

            // check xem git chua
            BackEnd.isGhPageInitialized(me.opts.siteName + '/build').then(function (initialized) {
                console.log('home github initialized', initialized);
                me.gitHubInited = initialized;
                me.update();
            });
//            setTimeout(function () {
//                me.openFile('content/index.md');
//                me.tags['side-bar'].activeFile('content/index.md');
//            }, 1);
        });

        me.goToLandingPage = function () {
            me.unmount(true);
            riot.api.trigger('showLandingPage');
        };

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

        function getFileContent(filePath) {
            var fileContent = BackEnd.readFile(me.opts.siteName, filePath).trim();
            if (fileContent === null) return;
            // split content thanh meta va markdown
            return SplitContentFile(fileContent);
        }

        me.refreshWatchView = function () {
            me.openWatchView();
            riot.api.trigger('RefreshWatch');
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
            console.log('watch view', mode);
            $(me.root.querySelector('#editor-view')).hide();
            $(me.root.querySelector('#watch-view')).show();
            ShowTab('watch-view');
            if (mode === 'user')
                me.tags['watch-view'].watch();
            else if (mode === 'dev')
                me.tags['watch-view'].watchDev();
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

                me.tags['side-bar'].activeFile('content-file-list', me.currentFilePath);
                me.currentFileTitle = me.currentFilePath.split(/[/\\]/).pop();
                me.update();

                var meta = BackEnd.getMetaFile(me.opts.siteName, me.currentFilePath);
                var metaConfig = BackEnd.getMetaConfigFile(me.opts.siteName, me.currentFilePath);
                console.log('metaConfig', meta, metaConfig);
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
            console.log('meta content', content);
            var contentConfig = BackEnd.getMetaConfigFile(me.opts.siteName, me.currentFilePath);

            me.tags['config-view'].loadContentConfig(contentConfig);
            ShowTab('config-view');
            me.tags['config-view'].event.on('saveConfig', function (configFieldName, newConfig) {
                console.log('save meta config');
                newConfig.name = configFieldName;
                // ghi de` new setting vo contentConfig
                for (var i = 0; i < contentConfig.length; i++) {
                    if (contentConfig[i].name === configFieldName) {
                        contentConfig[i] = newConfig;
                        break;
                    }
                }
                BackEnd.saveMetaConfigFile(me.opts.siteName, me.currentFilePath, JSON.stringify(contentConfig, null, 4));
            });
        };

        me.openConfigTab = function () {
            if (me.currentFilePath.endsWith('.json'))
                me.openMetaConfigTab();
            else if (me.currentFilePath.endsWith('.md'))
                me.openContentConfigTab();
        };

        me.openContentConfigTab = function () {
            me.currentFileTitle = me.currentFilePath.split(/[/\\]/).pop();
            HideAllTab();

            var content = BackEnd.getContentFile(me.opts.siteName, me.currentFilePath);
            if (!content.metaData.layout) {
                alert('content missing layout attribute');
                return;
            }

            var contentConfig = BackEnd.getConfigFile(me.opts.siteName, me.currentFilePath, content.metaData.layout);

            me.tags['config-view'].loadContentConfig(contentConfig);
            ShowTab('config-view');
            me.tags['config-view'].event.on('saveConfig', function (configFieldName, newConfig) {
                console.log('save content config');
                newConfig.name = configFieldName;
                // ghi de` new setting vo contentConfig
                for (var i = 0; i < contentConfig.length; i++) {
                    if (contentConfig[i].name === configFieldName) {
                        contentConfig[i] = newConfig;
                        break;
                    }
                }
                BackEnd.saveConfigFile(me.opts.siteName, content.metaData.layout, JSON.stringify(contentConfig, null, 4));
            });
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
            $(me.root.querySelector('#watch-view')).hide();

            me.tags['breadcrumb'].setPath(filePath);
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
                console.log('filePath', filePath);
                if (filePath.startsWith('content/metadata')) {
                    console.log('openMetaTab');
                    me.openMetaTab();
                }
                // openMetaConfigTab
//                me.openRawContentTab();
            }
            me.update();
        };

        me.save = function () {
//            var curTabHref = $(me.root).find('[role="presentation"].active>a').attr('href');
            // TODO add meta, content's config file to git
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

        me.newContent = function () {
            var layoutList = BackEnd.getRootLayoutList(me.siteName);
            me.tags['new-content-dialog'].updateLayoutList(layoutList);
            me.tags['new-content-dialog'].show();
        };

        riot.api.on('addLayout', function (layoutFileName) {
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
        });

        riot.api.on('addContent', function (layoutFileName, contentTitle, contentFileName, isFrontPage) {
            try {
                var newFile = BackEnd.newContentFile(me.siteName, layoutFileName, contentTitle, contentFileName, isFrontPage);
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
        });

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
                }).catch(function (err) {
                    console.log(err);
                    me.tags['progress-dialog'].enableClose();
                });
            });
        };

        riot.api.on('copyAssetFile', function (localPath, targetPath) {
            // TODO detect target path đã ở trong asset thì không cần copy
            BackEnd.copyAssetFile(me.siteName, localPath, targetPath, function (err) {
            });
        });

        me.openExternalReview = function () {
            me.tags['watch-view'].openExternalBrowser();
        };

        riot.api.on('watchSuccess', function () {
            me.openExternalReviewBtn.disabled = false;
        });

        riot.api.on('watchFailed', function () {
            me.openExternalReviewBtn.disabled = true;
            $(openWatchViewBtn).removeClass('active');
            $(openWatchViewDevBtn).removeClass('active');
        });
    </script>
</home>
