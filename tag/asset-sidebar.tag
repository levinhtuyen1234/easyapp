<asset-sidebar>
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

    <div class="content" class="simplebar" style="margin: 10px; overflow-x: hidden; padding: 0; margin: 0; height: calc(100% - 80px)"></div>

    <script>
        var me = this;
        const Fs = require('fs');
        const Fse = require('fs-extra');
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
                url = url.join('/');
                urlInput.val('/' + url);
            },
            onOpen:    function () {
                var openedItem = $(this);
                window.openedItem = openedItem;
                curFullPath = openedItem.data('fullPath');
                me.curType = openedItem.data('type');
                curAccordion = openedItem;
//                    console.log('curFullPath', curFullPath);
//                    console.log('curType', curType);

                me.update();
            }
        };

        const readDirRecursive = function (dir, ret) {
            ret = ret || [];
            try {
                let items = Fs.readdirSync(dir);
                let ret = [];
                items.forEach(function (name) {
                    let fullPath = Path.join(dir, name);
                    let stat = Fs.statSync(fullPath);
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
                let accordion = $(`<div class="accordion"></div>`);
                root.append(title, content);
                content.append(accordion);

                if (item.type === 'folder' && item.children.length > 0) {
                    buildObjectTree(accordion, item.children);
                }
            });
        }

        // add file, add folder, delete btn
        // tree view file, folder
        // tree view expand, collapse node
        // delete key pressed on node
        // click open file open raw data, text, image... (optional)

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

        let onAddFileOrFolder = function (filePaths) {
            if (!filePaths) {
                return;
            }
            _.forEach(filePaths, function (filePath) {
                // copy file to selected folder
                try {

                    let fileName = Path.basename(filePath);
                    console.log('copy', filePath, curFullPath + '/' + fileName);
                    let dstFilePath = Path.join(curFullPath, fileName);
                    Fse.copySync(filePath, dstFilePath, {
                        overwrite:    true,
                        errorOnExist: false
                    });
                } catch (ex) {
                    console.log('copy asset failed', ex);
                }
            });

            window.curAccordion = curAccordion;
            // reload cur accordion folder
            let curAccordionFolderPath = curAccordion.data('fullPath');
            console.log('curAccordionFolderPath', curAccordionFolderPath);
            let curAccordionFileTree = [];
            curAccordionFileTree = readDirRecursive(curAccordionFolderPath, fileTree);
            console.log('curAccordionFileTree', curAccordionFileTree);

            let curAccordionContent = curAccordion.first('.accordion');
            curAccordionContent.empty();
            buildObjectTree(curAccordionContent, curAccordionFileTree);
//             TODO cheat to let accordion tree refresh
//            setTimeout(function () {
//                let curAccordionContent = curAccordion.find('.accordion');
//                curAccordionContent.empty();
//                buildObjectTree(curAccordionContent, curAccordionFileTree);
//            }, 200);
        };

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
            var content = $(me.root).find('.content');
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
            fileTree = readDirRecursive(rootPath, fileTree);

            content.empty(); // remove previous tree
            let title = $(`<div class="title"><i class="folder outline icon"></i>
                    <i class="dropdown icon"></i>asset
                    </div>`);
            let accordionContent = $(`<div class="content active" data-name="asset" data-full-path="${rootPath}" data-type="folder"></div>`);
            let accordion = $(`<div class="accordion transition active hidden"></div>`);
            accordionRoot.append(title, accordionContent);
            accordionContent.append(accordion);
            curAccordion = accordion;

            content.append(accordionRoot);
            buildObjectTree(accordionContent, fileTree);

            accordionRoot.accordion(accordionConfig);
        });

        me.on('unmount', function () {
        });
    </script>

    <style>

    </style>
</asset-sidebar>
