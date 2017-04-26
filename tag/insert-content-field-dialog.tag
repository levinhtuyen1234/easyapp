<tree-view-dialog class="ui modal">
    <div class="container-fluid" style="display: none; overflow-y: scroll; height: 100%;">
        <div class="ui fluid input" style="margin: 6px;">
            <input class="new-field-name" placeholder="Field name" type="text">
        </div>
        <div class="content" style="margin: 10px">

        </div>

        <div style="position: absolute; bottom: 4px; right: 18px;">
            <button class="ui primary button add-field-btn" disabled>Add</button>
            <button class="ui button close-add-field-dialog">Close</button>
        </div>
    </div>

    <script>
        var me = this;
        var tree;
        var dialog, container, content, selectedAccordionItem;

        function buildObjectTree(root, obj, objectPath) {
            objectPath = objectPath || '';
            for (let prop in obj) {
                if (!obj.hasOwnProperty(prop)) return;
                var curObjectPath;
                if (objectPath === '') curObjectPath = prop;
                else curObjectPath = objectPath + '.' + prop;

                let value = obj[prop];
                let title, content;

                switch (typeof(value)) {
                    case 'object': {
                        let title = $(`<div class="title"><i class="dropdown icon"></i>${prop}</div>`);
                        let content = $(`<div class="content" data-path="${curObjectPath}"></div>`);
                        let accordion = $(`<div class="accordion transition hidden"></div>`);
                        root.append(title, content);
                        content.append(accordion);

                        if (Array.isArray(value)) {
                            // array
                            value.forEach(function (arrayItem, index) {
                                var tmpPath = curObjectPath + '.' + index;
                                let childTitle = $(`<div class="title"><i class="dropdown icon"></i>${index}</div>`);
                                let childContent = $(`<div class="content" data-path="${tmpPath}"></div>`);
                                let childAccordion = $(`<div class="accordion"></div>`);
                                childContent.append(childAccordion);
                                accordion.append(childTitle, childContent);

                                buildObjectTree(childAccordion, arrayItem, tmpPath);
                            });
                        } else {
                            // object
                            buildObjectTree(accordion, value, curObjectPath);
                        }
                        break;
                    }
                    default: {
                        // don't allow select primitive type node so not create
                    }
                }
            }
        }

        // get value output of a json schema
        var getSchemaValueView = function (key, value, ret) {
            if (!value.type) return;
            switch (value.type) {
                case 'object': {
                    if (!value.properties) return;
                    let child = {};
                    if (!key) key = 'root';
                    ret[key] = child;
                    // chi add cac key ma` value co type la object hoac array
                    _.map(value.properties, (childValue, childKey) => {
                        getSchemaValueView(childKey, childValue, child);
                    });
                    break;
                }
                case 'array': {
                    if (!value.items) return;
                    let child = [];
                    ret[key] = child;
                    break;
                }
            }
            return ret;
        };

        me.closeDialog = function () {
            if (dialog) {
                dialog.close();
                if (me.parent && me.parent.focus)
                    me.parent.focus();
            }
        };

        // input is contentConfig
        var curContentConfig;
        me.value = function (value) {
            if (value) {
                curContentConfig = value;
                if (typeof(value) !== 'object') {
                    console.log('typeof(value)', typeof(value), value);
                    console.log('tree-view-dialog value type must be \'object\'');
                    return;
                }

                // set
                content.empty(); // remove previous tree
                let accordionRoot = $('<div class="ui styled accordion root-accordion treemenu"></div>');
                content.append(accordionRoot);

                let valueView = {};

                getSchemaValueView('', value, valueView);
                // remove tag
                if (valueView.root && valueView.root.tag)
                    delete valueView.root.tag;
//                console.log('valueView', valueView);
                buildObjectTree(accordionRoot, valueView);
                _.forEach(siteGlobalConfigIndexes, function (metaConfig, metaFileName) {
                    var metaName = metaFileName.split('.').shift();
                    var data = {};
                    getSchemaValueView(metaName, metaConfig, data);
                    buildObjectTree(accordionRoot, data);
                });
//                accordionRoot.accordion();
            } else {
                // get TODO find selected accordion item
            }
        };

        let onStateChange = function () {
//            console.log('change event', event);
            let val = $newFieldName.val().trim();
            if (val === '' || !selectedAccordionItem) {
                dialog.find('.add-field-btn').prop('disabled', true);
            } else {
                dialog.find('.add-field-btn').removeProp('disabled');
            }
        };

        var accordionInitialized = false;
        //        $.jsPanel.closeOnEscape = true;
        me.show = function () {
            if (!dialog) {
//                console.log('Create dialog jsPanel', container.clone().html());
                dialog = $.jsPanel({
                    headerTitle:    'Add as content field',
//                    paneltype:      'modal',
//                    headerRemove:   true,
                    closeOnEscape:  true,
                    headerControls: {
                        controls: 'closeonly',
                        iconfont: 'font-awesome'
                    },
                    position:       {
                        my: 'center',
                        at: 'center'
                    },
                    contentSize:    {width: 500, height: 450},
                    content:        container.clone().show(),
                    onclosed:       function () {
                        dialog = null;
                        accordionInitialized = false;
                    }
                });

                setTimeout(function () {
                    if (accordionInitialized) return;
                    accordionInitialized = true;
                    let $newFieldName = dialog.find('.new-field-name');
                    window.$newFieldName = $newFieldName;
//                    console.log('SETUP listen change new field name');
                    $newFieldName.on('change keyup paste', onStateChange);

                    dialog.find('.root-accordion').accordion({
                        onOpen: function () {
                            var openedItem = $(this);
                            selectedAccordionItem = openedItem.data('path');
//                            console.log('on accordion open', openedItem.data('path'));
                            onStateChange();
                        }
                    });

                    // hook add button
                    dialog.find('.add-field-btn').click(function () {
                        let fieldName = $newFieldName.val();
                        fieldName = fieldName || '';
                        fieldName = fieldName.trim();
                        if (fieldName === '') return;

                        let objectPath = selectedAccordionItem;
                        let contentConfig = curContentConfig;
//                        console.log('fieldName', fieldName);
//                        console.log('objectPath', objectPath);
//                        console.log('contentConfig', contentConfig);

                        // check if insert property to global meta or content data
                        if (objectPath === 'root' || objectPath.startsWith('root.')) {
                            // add field to content file
                            let config;
                            try {
                                let parts = objectPath.split('.');
                                parts.forEach(function (propName) {
                                    if (propName === 'root') config = contentConfig;
                                    else config = config.properties[propName];
                                });
                            } catch (ex) {
                                config = null;
                            }

                            if (config === null) {
                                console.log('error', 'config not found');
                                return;
                            }
                            if (!config.type) {
                                console.log('error', 'invalid config');
                                return;
                            }
                            if (config.type === 'array') {
                                if (config.items && config.items.type === 'object') {
                                    config.items.properties = config.items.properties || {};
                                    config.items.properties[fieldName] = {type: 'string', propertyOrder: 1000};
                                }
                            } else if (config.type === 'object') {
                                config.properties = config.properties || {};
                                config.properties[fieldName] = {type: 'string', propertyOrder: 1000};
                            }

//                          console.log('found config', config);
                            // save file
                            if (me.parent && me.parent.addField) {
                                me.parent.addField('content', null, fieldName, config, curContentConfig, objectPath);
                                me.closeDialog();
                            }
                        } else {
                            // add field to global meta
                            let parts = objectPath.split('.');
                            if (parts.length <= 0) return;
                            let metaSchemaConfigFileName = parts.shift() + '.meta-schema.json';
                            let globalMetaConfig = siteGlobalConfigIndexes[metaSchemaConfigFileName];
                            let config = globalMetaConfig;
                            try {
                                let parts = objectPath.split('.');
                                parts.shift(); // remove field name
                                parts.forEach(function (propName) {
                                    config = config.properties[propName];
                                });
                            } catch (ex) {
                                config = null;
                            }

                            if (config === null) {
                                console.log('error', 'config not found');
                                return;
                            }
                            if (!config.type) {
                                console.log('error', 'invalid config');
                                return;
                            }
                            if (config.type === 'array') {
                                if (config.items && config.items.type === 'object') {
                                    config.items.properties = config.items.properties || {};
                                    config.items.properties[fieldName] = {type: 'string', propertyOrder: 1000};
                                }
                            } else if (config.type === 'object') {
                                config.properties = config.properties || {};
                                config.properties[fieldName] = {type: 'string', propertyOrder: 1000};
                            }

                            me.parent.addField('globalMeta', metaSchemaConfigFileName, fieldName, config, globalMetaConfig, objectPath);
                            me.closeDialog();
                        }
                    });

                    dialog.find('.close-add-field-dialog').click(function () {
                        me.closeDialog();
                    });

                    accordionInitialized = true;
                }, 100);

                $('.new-field-name').focus();
            }
        };

        //        me.addField = function () {
        // get current selected text
        // default to empty
        // get current config path
        // insert to config file and save
        //        };

        function onEscape(evt) {
            evt = evt || window.event;
            var isEscape = false;
            if ('key' in evt) {
                isEscape = (evt.key == 'Escape' || evt.key == 'Esc');
            } else {
                isEscape = (evt.keyCode == 27);
            }
            if (isEscape) {
                if (dialog) {
                    dialog.close();
                    if (me.parent && me.parent.focus)
                        me.parent.focus();
                }
            }
        }

        me.on('mount', function () {
            content = $(me.root).find('.content');
            container = $(me.root).find('.container-fluid');
            $(document).on('keydown', onEscape);
        });

        me.on('unmount', function () {
            $(document).off('keydown', onEscape);
        });
    </script>

    <style>

    </style>
</tree-view-dialog>
