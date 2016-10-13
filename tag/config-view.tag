<add-config-field-dialog class="ui small modal">
    <div class="header">Add new Field</div>
    <div class="content">
        <div class="ui form">
            <div class="field">
                <label>Name</label>
                <div class="ui fluid input">
                    <input type="text" id="nameField" placeholder="Name" oninput="{edit('fieldName')}">
                </div>
            </div>
            <div class="field">
                <label>Field type</label>
                <div class="ui three column grid">
                    <div each="{contentType in contentTypes}" class="column">
                        <a class="ui fluid card" onclick="{chooseFieldType}" data-field-type="{contentType.name}">
                            <div class="content">
                                <div class="header">{contentType.name}</div>
                                <div class="description">
                                    {contentType.desc}
                                </div>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <div class="ui error message" show="{errMsg != ''}">
            <div class="header">Add field failed</div>
            <p>{errMsg}</p>
        </div>
    </div>
    <div class="actions">
        <div class="ui deny button">Cancel</div>
        <div class="ui blue right labeled icon button {disabled : canSubmit()}" onclick="{submit}">Add
            <i class="add icon"></i>
        </div>
    </div>

    <script>
        var me = this;
        me.mixin('form');

        var modal;
        me.fieldName = '';
        me.fieldType = '';
        me.errMsg = '';
        me.parentIndex;


        me.canSubmit = function () {
            return !(me.fieldName !== '' && me.fieldType !== '');
        };

        var allContentType = [
            {
                name: 'Text',
                desc: 'Text desc'
            },
            {
                name: 'Number',
                desc: 'Number desc'
            },
            {
                name: 'Boolean',
                desc: 'Boolean desc'
            },
            {
                name: 'DateTime',
                desc: 'DateTime desc'
            },
            {
                name: 'Media',
                desc: 'Media desc'
            },
            {
                name: 'Object',
                desc: 'Object desc'
            },
            {
                name: 'Array',
                desc: 'Array desc'
            }
        ];

        me.contentTypes = allContentType;

        var activeFieldType = function (name) {
            $(me.root).find('.ui.card').removeClass('blue');
            $(me.root).find('.card[data-field-type="' + name + '"]').addClass('blue');
            me.fieldType = name;
            me.update();
        };

        me.chooseFieldType = function (e) {
            var card = $(e.srcElement).closest('a');
//            console.log('card', card.data('fieldType'));

            me.fieldType = card.data('fieldType');
            $(me.root).find('.ui.card').removeClass('blue');
            card.addClass('blue');
        };

        me.reset = function () {
            me.nameField.value = '';
            me.fieldName = '';
            me.fieldType = '';
            me.errMsg = '';
            activeFieldType('Text');
            me.update();
        };

        me.on('mount', function () {
            modal = $(me.root).modal();
            activeFieldType('Text');
        });

        me.on('configView.addFieldSuccess', function () {
            me.hide();
        });

        me.on('configView.addFieldFailed', function (errMsg) {
            me.errMsg = errMsg;
            me.update();
        });

        me.show = function (parentIndex) {
            me.parentIndex = parentIndex;
            activeFieldType('Text');
            modal.modal('show');
        };

        me.hide = function () {
            modal.modal('hide');
        };

        me.hideFieldTypes = function (hiddenFields) {
            var tmp = JSON.parse(JSON.stringify(allContentType));
            me.contentTypes = tmp.filter(function (field) {
                return !hiddenFields.some(function (name) {
                    return name == field.name;
                });
            });
            me.update();
        };

        me.submit = function () {
//            console.log('ADD FIELD', me.parentIndex, me.fieldName, me.fieldType);
            riot.event.trigger('configView.addField', me.parentIndex, me.fieldName, me.fieldType);
        };
    </script>
</add-config-field-dialog>

<field-setting-dialog class="ui modal">
    <div class="header">{modalTitle}</div>
    <div class="content">
        <div class="ui form">
            <div class="inline field">
                <label>Field type</label>
                <select id="fieldTypeDropDown" class="ui dropdown" onchange="{ShowFieldConfig}">
                    <option each="{field in fieldTypes}" value="{field.value}">{field.name}</option>
                </select>
            </div>

            <config-view-text show="{curFieldType === 'Text'}"></config-view-text>
            <config-view-array show="{curFieldType === 'Array'}"></config-view-array>
            <config-view-object show="{curFieldType === 'Object'}"></config-view-object>
            <config-view-number show="{curFieldType === 'Number'}"></config-view-number>
            <config-view-boolean show="{curFieldType === 'Boolean'}"></config-view-boolean>
            <config-view-datetime show="{curFieldType === 'DateTime'}"></config-view-datetime>
            <config-view-media show="{curFieldType === 'Media'}"></config-view-media>
        </div>
    </div>
    <div class="actions">
        <div class="ui button deny">Close</div>
        <div class="ui button positive icon" disabled="{layoutName==''}" onclick="{saveConfig}">
            <i class="save icon"></i>
            Save
        </div>
    </div>

    <script>
        var me = this;
        var modal;

        me.curFieldType = '';

        var AllFieldTypes = [
            {name: 'Text', value: 'Text'},
            {name: 'Number', value: 'Number'},
            {name: 'Boolean', value: 'Boolean'},
            {name: 'DateTime', value: 'DateTime'},
            {name: 'Media', value: 'Media'},
            {name: 'Object', value: 'Object'},
            {name: 'Array', value: 'Array'},
        ];

        me.fieldTypes = AllFieldTypes;

        var formTags = {
            'Boolean':  me.tags['config-view-boolean'],
            'DateTime': me.tags['config-view-datetime'],
            'Media':    me.tags['config-view-media'],
            'Number':   me.tags['config-view-number'],
            'Object':   me.tags['config-view-object'],
            'Array':    me.tags['config-view-array'],
            'Text':     me.tags['config-view-text']
        };

        me.saveConfig = function () {
            var contentType = me.fieldTypeDropDown.value;
//            console.log('click saveConfig', contentType);
            var formTag = formTags[contentType];
            if (!formTag) return;

            var newConfig = formTag.getConfig();

            Object.assign(me.curConfig, newConfig);

//            console.log('new config', newConfig, 'changed config', me.curConfig);
            me.parent.onFieldSettingChanged();
            modal.modal('hide');
        };

        me.addPredefinedText = function (e) {
            var EnterKey = 13;
            if (e.which != EnterKey) return;

            var value = e.target.value;
            e.target.value = '';
            var index = me.textPredefinedList.indexOf(value);
            if (index === -1) {
                me.textPredefinedList.push(value);
                me.update();
            }
        };

        me.removePredefinedText = function (value) {
            var index = me.textPredefinedList.indexOf(value);
            if (index !== -1) {
                me.textPredefinedList.splice(index, 1);
                me.update();
            }
        };

        me.on('mount', function () {
            modal = $(me.root).modal({
                autofocus:      false,
                observeChanges: true
            });
        });

        me.ShowFieldConfig = function (e) {
            console.log('ShowFieldConfig', e.target.value);
            me.curFieldType = e.target.value;
            // set displayName khi chuyen sang Content type khac
            if (me.curFieldType !== me.originalFieldType) {
                var configFieldTag = 'config-view-' + me.curFieldType.toLowerCase();
                me.tags[configFieldTag].loadConfig({
                    name:        me.curConfig.name,
                    displayName: me.curConfig.displayName
                });
            }
            me.update();
        };

        me.hideFieldTypes = function (hiddenFields) {
            var tmp = JSON.parse(JSON.stringify(AllFieldTypes));
            me.fieldTypes = tmp.filter(function (field) {
                return !hiddenFields.some(function (name) {
                    return name == field.name;
                });
            });
//            console.log('me.fieldTypes', me.fieldTypes);
            me.update();
        };

        me.show = function (config) {
//            console.log('config', config);
            me.curConfig = config;

            var fieldName = config.name;
            var fieldType = config.type;
//            console.log('showFieldSettingDialog', fieldName);
            me.modalTitle = 'Configuration for ' + fieldName + ', displayName: ' + config.displayName;
            me.curFieldType = fieldType;
            me.curConfigFieldName = fieldName;
            me.curConfig = config;
            me.originalFieldType = fieldType;

            modal.modal('show');

//            console.log(me.fieldTypeDropDown);
            $(me.fieldTypeDropDown).dropdown().dropdown('set selected', fieldType);
//            console.log('set selected', fieldType);
//            console.log('fieldType', fieldType, 'formTags', formTags);
            formTags[fieldType].clear(); // clear form setting
            formTags[fieldType].loadConfig(config);
            me.update();
        };

        me.hide = function () {
            modal.modal('hide');
        };
    </script>
</field-setting-dialog>

<config-view-object-node>
    <div class="ui middle aligned divided list sortable" style="padding-left: 10px; padding-top: 5px;">
        <div each="{config, index in config.children}" class="item" style="cursor: pointer; border-top: 1px solid rgba(34,36,38,.15)" data-parent-index="{parentIndex}">
            <div class="right floated content">
                <div if="{isArrayOrObject(config)}" class="ui icon mini button" onclick="{onShowAddFieldDialog}" data-index="{parent.parentIndex + '-' + index}">
                    <i class="add icon"></i>
                </div>
                <div class="ui icon mini button" onclick="{onShowFieldSetting}" data-index="{parentIndex + '-' + index}"><i class="setting icon"></i></div>
                <div class="ui red icon mini button" onclick="{onRemoveField}" data-index="{parentIndex + '-' + index}"><i class="remove icon"></i></div>
            </div>
            <i class="content icon" style="padding-top: 5px;"></i>
            <div class="content" style="padding-top: 6px">
                <div class="header">{config.displayName} - {config.name} - <strong>{config.type}</strong></div>
            </div>
            <div if="{isArrayOrObject(config)}" parent-index="{parent.parentIndex + '-' + index}" data-is="config-view-object-node" style="padding-left: 10px; padding-top: 3px;"></div>
        </div>
    </div>

    <script>
        var me = this;
        me.parentIndex = me.opts.parentIndex;

        me.isArrayOrObject = function (config) {
            return config.type === 'Object' || config.type === 'Array';
        };

        //        me.on('unmount', function () {
        //            var childTags = me.tags['config-view-object-node'];
        //            if (Array.isArray(childTags)) {
        //                me.tags['config-view-object-node'].forEach(function (tag) {
        //                    tag.unmount(true);
        //                });
        //            } else if(childTags) {
        //                childTags.unmount(true);
        //            }
        //        });

        me.on('updated', function () {
            var configItems = $(me.root).find('.sortable');
            var startIndex;
            configItems.sortable({
                start:  function (e, ui) {
                    startIndex = ui.item.index();
                },
                update: function (e, ui) {
                    var newIndex = ui.item.index();
                    var parentIndex = ui.item.context.dataset.parentIndex;
                    riot.event.trigger('configView.onChangeRowIndex', parentIndex, startIndex, newIndex);
                }
            });
        });

        me.onShowFieldSetting = function (e) {
            riot.event.trigger('configView.onShowFieldSetting', $(e.srcElement).closest('div').data('index'));
        };

        me.onRemoveField = function (e) {
            riot.event.trigger('configView.onRemoveField', $(e.srcElement).closest('div').data('index'));
        };

        me.onShowAddFieldDialog = function (e) {
            riot.event.trigger('configView.onShowAddFieldDialog', $(e.srcElement).closest('div').data('index'));
        };
    </script>
</config-view-object-node>

<config-view style="height: calc(100% - 88px);">
    <add-config-field-dialog></add-config-field-dialog>
    <field-setting-dialog></field-setting-dialog>
    <h2>
        List of fields
        <div class="ui button right floated" onclick="{onShowAddFieldDialog}" data-index="">Add Field</div>
    </h2>
    <h3 class="text-success">(?) Click vào Setting button để điều chỉnh hiển thị trong phần Form nhập liệu</h3>
    <div class="" style="overflow: scroll; padding: 0; height: calc(100% - 80px); margin: 0 0 -14px; overflow-x: hidden;">
        <div class="ui middle aligned divided list sortable">
            <div each="{config, index in contentConfig}" class="item" style="cursor: pointer;">
                <div class="right floated content">
                    <div if="{isArrayOrObject(config)}" class="ui icon mini button" onclick="{onShowAddFieldDialog}" data-index="{index.toString()}">
                        <i class="add icon"></i>
                    </div>
                    <div class="ui icon mini button" onclick="{onShowFieldSetting}" data-index="{index}"><i class="setting icon"></i></div>
                    <div class="ui red icon mini button" onclick="{onRemoveField}" data-index="{index}"><i class="remove icon"></i></div>
                </div>
                <i class="content icon" style="padding-top: 5px;"></i>
                <div class="content" style="padding-top: 6px">
                    <div class="header">{config.displayName} - {config.name} - <strong>{config.type}</strong></div>
                </div>
                <div if="{isArrayOrObject(config)}" data-is="config-view-object-node" config="{config}" parent-index="{index.toString()}" style="padding-left: 10px; padding-top: 3px;"></div>
            </div>
        </div>
    </div>
    <script>
        var me = this;
        var _ = require('lodash');
        me.mixin('form');
        me.contentConfig = [];
        me.hiddenConfig = [];
        me.originalFieldType = '';

        me.isArrayOrObject = function (config) {
            return config.type === 'Object' || config.type === 'Array';
        };

        var getParentConfigChildren = function (index) {
            if (typeof(index == 'number'))
                index = index.toString();
            if (index == '') return me.contentConfig;
            var parts = index.split('-');
            var ret = me.contentConfig;
            parts.forEach(function (index) {
                ret = ret[parseInt(index)].children;
            });
            return ret;
        };

        var getConfig = function (fieldIndex) {
            var parts = fieldIndex.split('-');
            if (parts.length == 1) {
                return me.contentConfig[fieldIndex];
            }

            fieldIndex = parts.pop();
            var parentIndex = parts.join('-');

            var configs = getParentConfigChildren(parentIndex);
            return configs[fieldIndex];
        };

        var getParentConfig = function (fieldIndex) {
            var parts = fieldIndex.split('-');
            if (parts.length == 1) {
                return me.contentConfig[fieldIndex];
            }

            parts.pop();

            var parentIndex = parts.join('-');
//            console.log('getParentConfig parentIndex', parentIndex);
            return getConfig(parentIndex);
        };

        var changeRowIndex = function (parentIndex, from, to) {
//            console.log('me.curConfig', me.curConfig);
//            console.log('changeRowIndex', parentIndex, from, to);
            var configs = getParentConfigChildren(parentIndex);
            var tmp = configs[to];
            configs[to] = configs[from];
            configs[from] = tmp;
            me.trigger('saveConfig', me.getContentConfig());
            refreshConfig();
        };

        var addField = function (parentIndex, fieldName, fieldType) {
            var configs = getParentConfigChildren(parentIndex);
            var fieldExists = _.some(configs, {'name': fieldName});
            if (fieldExists) {
                me.tags['add-config-field-dialog'].trigger('configView.addFieldFailed', 'field name "' + fieldName + '" already exists');
            } else {
                var contentConfig = BackEnd.getDefaultContentConfig(fieldName, fieldType);
                configs.push(contentConfig);
                me.tags['add-config-field-dialog'].trigger('configView.addFieldSuccess');
                me.trigger('saveConfig', me.getContentConfig());
                refreshConfig();
            }
        };

        var showAddFieldDialog = function (fieldIndex) {
//            console.log('show add field dialog', fieldIndex);
            me.tags['add-config-field-dialog'].reset();

            // hide Array and Object field type if fieldConfig type is Array
            var config = getConfig(fieldIndex);
            if (config && config.type === 'Array') {
//                console.log('hide array and object field');
                me.tags['add-config-field-dialog'].hideFieldTypes(['Array', 'Object']);
            } else {
                me.tags['add-config-field-dialog'].hideFieldTypes([]);
            }

            me.tags['add-config-field-dialog'].show(fieldIndex);
        };

        var showFieldSettingDialog = function (fieldIndex) {
//            console.log('show field setting dialog', fieldIndex);

            var parentConfig = getParentConfig(fieldIndex);
            var config = getConfig(fieldIndex);
            // if parent type is Array hide Array and Object field type
//            console.log('showFieldSettingDialog parentConfig', parentConfig);
            if (parentConfig.type === 'Array') {
//                console.log('showFieldSettingDialog hide FIELDS');
                me.tags['field-setting-dialog'].hideFieldTypes(['Array', 'Object']);
            } else {
                me.tags['field-setting-dialog'].hideFieldTypes([]);
            }
            me.tags['field-setting-dialog'].show(config);
        };

        var removeField = function (fieldIndex) {
//            console.log('remove field', fieldIndex);
            var config = getConfig(fieldIndex);
            bootbox.confirm({
                title:    'Delete',
                message:  `Are you sure you want to delete field "${config.name}" ?`,
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
                    var parts = fieldIndex.split('-');
                    fieldIndex = parts.pop();
                    var parentIndex = parts.join('-');

                    var configs = getParentConfigChildren(parentIndex);
//            console.log('removeField', parentIndex, fieldIndex);
                    configs.splice(fieldIndex, 1);
                    me.trigger('saveConfig', me.getContentConfig());
                    refreshConfig();
                }
            });
        };

        me.onFieldSettingChanged = function () {
            me.trigger('saveConfig', me.getContentConfig());
            refreshConfig();
        };

        me.on('unmount', function () {
            riot.event.off('configView.onChangeRowIndex', changeRowIndex);
            riot.event.off('configView.onRemoveField', removeField);
            riot.event.off('configView.onShowFieldSetting', showFieldSettingDialog);
            riot.event.off('configView.onShowAddFieldDialog', showAddFieldDialog);
            riot.event.off('configView.addField', addField);
        });

        me.on('mount', function () {
            riot.event.on('configView.onChangeRowIndex', changeRowIndex);
            riot.event.on('configView.onRemoveField', removeField);
            riot.event.on('configView.onShowFieldSetting', showFieldSettingDialog);
            riot.event.on('configView.onShowAddFieldDialog', showAddFieldDialog);
            riot.event.on('configView.addField', addField);
        });

        me.onShowFieldSetting = function (e) {
            var fieldIndex = $(e.srcElement).closest('div').data('index').toString();
            showFieldSettingDialog(fieldIndex);
        };

        me.onRemoveField = function (e) {
            var fieldIndex = $(e.srcElement).closest('div').data('index').toString();
            removeField(fieldIndex);
        };

        me.onShowAddFieldDialog = function (e) {
            var parentIndex = $(e.srcElement).closest('div').data('index').toString();
            showAddFieldDialog(parentIndex);
        };

        var bindDragDrop = function () {
            var configItems = $(me.root).find('.sortable');
            var startIndex;
            configItems.sortable({
                start:  function (e, ui) {
                    startIndex = ui.item.index();
                },
                update: function (e, ui) {
                    var newIndex = ui.item.index();
                    changeRowIndex('', startIndex, newIndex);
                }
            });
            configItems.disableSelection();
        };

        var refreshConfig = function () {
            me.contentConfig = JSON.parse(JSON.stringify(me.contentConfig));
            me.update();

            bindDragDrop();
        };

        me.loadContentConfig = function (contentConfig) {
//            console.log('[config-view] loadContentConfig', contentConfig);
            var hiddenFieldNames = ['slug', 'layout', 'category', 'tag'];
            me.hiddenConfig = [];
            me.contentConfig = contentConfig.filter(function (config) {
                if (hiddenFieldNames.indexOf(config.name) !== -1) {
                    me.hiddenConfig.push(config);
                    return false;
                }
                return true;
            });
            me.update();
            bindDragDrop();
        };

        //        me.removeField = function (e) {
        //            var fieldName = e.item.config.name;
        //            for (var i = 0; i < me.contentConfig.length; i++) {
        //                if (me.contentConfig[i].name === fieldName) {
        //                    me.contentConfig.splice(i, 1);
        //                    return;
        //                }
        //            }
        //        };

        me.getContentConfig = function () {
            // merge cac hidden field vao
            return me.hiddenConfig.concat(me.contentConfig);
        };
    </script>
</config-view>
