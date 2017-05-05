<asset-sidebar>
    <div data-is="copy-progress-dialog"></div>
    <div class="ui icon mini menu">
        <div class="item" style="width: calc(100% - 130px); font-size: 15px;">
            <div class="ui transparent input">
                <input placeholder="" type="text" class="url-input" readonly>
            </div>
        </div>

        <div class="right menu">
            <a class="item {curType === 'file' ? 'disabled' : ''}" title="Add File" onclick="{addFile}">
                <i class="large icons">
                    <i class="file icon"></i>
                    <i class="inverted corner add icon"></i>
                </i>
            </a>
            <a class="item {curType === 'file' ? 'disabled' : ''}" title="Add Folder" onclick="{addFolder}">
                <i class="large icons">
                    <i class="folder icon"></i>
                    <i class="inverted corner add icon"></i>
                </i>
            </a>
            <a class="item" title="Remove" onclick="{delete}">
                <i class="red remove large icon"></i>
            </a>
        </div>
    </div>

    <div class="content sidebar-content" style="overflow-x: hidden; padding: 0; margin: 0; height: calc(100% - 80px)"></div>

    <script>
        var me = this;
        const Promise = require('bluebird');
        const Fs = require('fs');
        const Fse = Promise.promisifyAll(require('fs-extra'));
        const Path = require('path');

        const dialog = require('electron').remote.dialog;

        var rootPath, curFullPath, curAccordion, fileTree, urlInput;
        let accordionRoot = $('<div class="ui styled accordion root-accordion treemenu"></div>');
        me.curType;

        var accordionConfig = {
//            exclusive: true,
//            closeNested: true,
            onOpening: function () {
                var openedItem = $(this);
                accordionRoot.find('.selected-accordion').removeClass('selected-accordion');
                openedItem.prev().addClass('selected-accordion');
                curFullPath = openedItem.data('fullPath');

                let url = curFullPath.split(/[\\\/]/g);
                url.shift(); // remove 'sites'
                url.shift(); // remove site name
                url.shift(); // remove asset
                url = url.join('/');
                urlInput.val('/' + url);
            },
            onOpen:    function () {
                var openedItem = $(this);
                window.openedItem = openedItem;
                curFullPath = openedItem.data('fullPath');
                me.curType = openedItem.data('type');
                curAccordion = openedItem;

                if (me.curType === 'file') {
                    riot.event.trigger('openAssetFile', curFullPath);
                }
                me.update();
            }
        };

        const readDirFlatRecursive = function (dir, ret) {
            ret = ret || [];
            try {
                var items = Fs.readdirSync(dir);
                items.forEach(function (name) {
                    var fullPath = Path.join(dir, name);
                    var stat = Fs.statSync(fullPath);
                    if (stat.isFile()) {
                        ret.push({
                            name:     name,
                            type:     'file',
                            fullPath: fullPath
                        });
                    } else if (stat.isDirectory()) {
                        readDirFlatRecursive(fullPath, ret);
                    }
                });
                return ret;
            } catch (ex) {
                console.log(ex);
                return [];
            }
        };

        const readDirRecursive = function (dir, ret) {
            ret = ret || [];
            try {
                var items = Fs.readdirSync(dir);
                items.forEach(function (name) {
                    var fullPath = Path.join(dir, name);
                    var stat = Fs.statSync(fullPath);
                    if (stat.isFile()) {
                        ret.push({
                            name:     name,
                            type:     'file',
                            fullPath: fullPath
                        });
                    } else if (stat.isDirectory()) {
                        let node = {
                            name:     name,
                            type:     'folder',
                            fullPath: fullPath,
                            children: []
                        };
                        ret.push(node);
                        node.children = readDirRecursive(fullPath, node.children);
                    }
                });
                return ret;
            } catch (ex) {
                console.log(ex);
                return [];
            }
        };

        function buildObjectTree(root, items) {
            _.forEach(items, function (item) {
                let title = $(`<div class="title">
                    ${item.type === 'folder' ? '<i class="folder icon"></i>' : '<i class="file outline icon"></i>'}
                    <i class="dropdown icon"></i>${item.name}
                    </div>`);
                let content = $(`<div class="content" data-name="${item.name}" data-full-path="${item.fullPath}" data-type="${item.type}"></div>`);
                let accordion = $(`<div class="accordion transition hidden" data-full-path="${item.fullPath}"></div>`);
                root.append(title, content);
                content.append(accordion);

                if (item.type === 'folder' && item.children.length > 0) {
                    buildObjectTree(accordion, item.children);
                }
            });
        }

        me.delete = function () {
            bootbox.confirm({
                title:    'Delete',
                message:  `Are you sure you want to delete ${me.curType} ${curFullPath} ?`,
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
                    if (!result) return;
                    try {
                        Fse.removeSync(curFullPath);
                    } catch (ex) {
                        console.log(ex);
                    }
                    // remove cur accordion
                    var titleElm = curAccordion.prev();
                    titleElm.remove();
                    curAccordion.remove();
                }
            });
        };

        let onAddFileOrFolder = Promise.coroutine(function *(filePaths) {
            if (!filePaths) {
                return;
            }

            var progressDialog = me.tags['copy-progress-dialog'];
            window.progressDialog = progressDialog;
            progressDialog.show('Copying file');
            // wait a bit for dialog show up

            // collect to be copied files
            for (let i = 0; i < filePaths.length; ++i) {
                let filePath = filePaths[i];
                try {
                    let stat = Fs.statSync(filePath);
                    if (stat.isDirectory()) {
//                        console.log('copy folder');
                        let srcFiles = [];
                        let dstNewFolder = filePath.split(/[\/\\]/g).pop();
                        console.log('dstNewFolder', dstNewFolder);
                        srcFiles = readDirFlatRecursive(filePath, srcFiles);
//                        console.log('srcFiles', srcFiles);
                        for (let j = 0; j < srcFiles.length; j++) {
                            let fileInfo = srcFiles[j];
                            progressDialog.step(fileInfo.fullPath);
                            // create dst path
                            let dstPath = Path.join(curFullPath, dstNewFolder, fileInfo.fullPath.replace(filePath, ''));
                            console.log('copy from', fileInfo.fullPath, 'to', dstPath);
                            yield Fse.copyAsync(fileInfo.fullPath, dstPath, {overwrite: true, errorOnExist: false});
//                            console.log('copy done one', fileInfo.fullPath);
                        }
                    } else if (stat.isFile()) {
                        progressDialog.step(filePath);
                        let fileName = Path.basename(filePath);
                        let dstFilePath = Path.join(curFullPath, fileName);
                        yield Fse.copyAsync(filePath, dstFilePath, {overwrite: true, errorOnExist: false});
                    }
                } catch (ex) {
                    console.log('copy asset failed', ex);
                }
            }
            progressDialog.hide();

            window.curAccordion = curAccordion;
            // reload cur accordion folder
            let curAccordionFolderPath = curAccordion.data('fullPath');
//            console.log('curAccordionFolderPath', curAccordionFolderPath);
            let curAccordionFileTree = [];
//            console.log('AAA curAccordionFolderPath', curAccordionFolderPath);
            readDirRecursive(curAccordionFolderPath, curAccordionFileTree);
//            console.log('curAccordionFileTree', curAccordionFileTree);

            let curAccordionContent = curAccordion.first('.accordion');
            console.log('curAccordionContent', curAccordionContent);
            window.curAccordionContent = curAccordionContent;
            curAccordionContent.empty();
            buildObjectTree(curAccordionContent, curAccordionFileTree);

        });

        me.addFile = function (e) {
            if (!curFullPath) return;
            if ($(e.target).hasClass('disabled') || $(e.target).parent().parent().hasClass('disabled')) return;
            dialog.showOpenDialog({properties: ['multiSelections', 'openFile']}, onAddFileOrFolder);
        };

        me.addFolder = function (e) {
            if (!curFullPath) return;
            if ($(e.target).hasClass('disabled') || $(e.target).parent().parent().hasClass('disabled')) return;
            dialog.showOpenDialog({properties: ['multiSelections', 'openDirectory']}, onAddFileOrFolder);
        };

        me.on('mount', function () {
            var content = $(me.root).find('.sidebar-content');
            urlInput = $(me.root).find('.url-input');

            // handle auto select url input first time click only
            urlInput.on('focus input', function (e) {
                $(this).one('mouseup', function () {
                    $(this).select();
                    return false;
                }).select();
            });

            fileTree = [];
            rootPath = `sites/${me.opts.siteName}/asset`;
            curFullPath = rootPath;
            me.curType = 'folder';
            readDirRecursive(rootPath, fileTree);

            content.empty(); // remove previous tree
            let title = $(`<div class="title"><i class="folder icon"></i>
                    <i class="dropdown icon"></i>asset
                    </div>`);
            let accordionContent = $(`<div class="active content" data-name="asset" data-full-path="${rootPath}" data-type="folder"></div>`);
            let accordion = $(`<div class="active accordion transition visible" data-full-path="${rootPath}"></div>`);
            accordionRoot.append(title, accordionContent);
            accordionContent.append(accordion);
            curAccordion = accordion;

            content.append(accordionRoot);
            buildObjectTree(accordion, fileTree);

            accordionRoot.accordion(accordionConfig);
        });

        me.on('unmount', function () {
        });
    </script>

    <style>

    </style>
</asset-sidebar>
