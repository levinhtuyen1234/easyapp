<add-config-field-dialog class="ui small modal">
    <i class="close icon" show="{!cloning}"></i>
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
                        <a class="ui fluid card" onclick="{chooseFieldType}" data-fieldType="{contentType.name}">
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
    </div>
    <div class="actions">
        <div class="ui deny button">Cancel</div>
        <div class="ui positive right labeled icon button {disabled : canSubmit()}" onclick="{submit}">Add
            <i class="add icon"></i>
        </div>
    </div>

    <script>
        var me = this;
        me.mixin('form');

        var modal;
        me.fieldName = '';
        me.fieldType = '';

        me.canSubmit = function () {
            return !(me.fieldName !== '' && me.fieldType !== '');
        };

        me.contentTypes = [
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

        var activeFieldType = function (name) {
            $(me.root).find('.card[data-fieldType="' + name + '"]').addClass('blue');
            me.fieldType = name;
            me.update();
        };

        me.chooseFieldType = function (e) {
            if (e.srcElement.tagName === 'DIV') {
                var card = $(e.srcElement).closest('a');
                me.fieldType = card[0].dataset.fieldType;
                $(me.root).find('.ui.card').removeClass('blue');
                card.addClass('blue');
            }
        };

        me.on('mount', function () {
            modal = $(me.root).modal();
            activeFieldType('Text');
        });

        me.show = function () {
            modal.modal('show');
        };

        me.hide = function () {
            modal.modal('hide');
        };

        me.submit = function () {
            me.trigger('addField', me.fieldName, me.fieldType);
        };
    </script>
</add-config-field-dialog>

<field-setting-dialog class="ui modal">
    <i class="close icon"></i>
    <div class="header">{modalTitle}</div>
    <div class="content">
        <div class="ui form">
            <div class="inline field">
                <label>Field type</label>
                <select id="fieldTypeDropDown" class="ui dropdown" onchange="{ShowFieldConfig}">
                    <option value="Array">Array</option>
                    <option value="Boolean">Boolean</option>
                    <option value="DateTime">DateTime</option>
                    <option value="Media">Media</option>
                    <option value="Number">Number</option>
                    <option value="Object">Object</option>
                    <option value="Text">Text</option>
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
        <div class="ui button cancel">Close</div>
        <div class="ui button positive icon" disabled="{layoutName==''}" onclick="{saveConfig}">
            <i class="save icon"></i>
            Save
        </div>
    </div>

    <script>
        var me = this;
        var modal;

        me.curFieldType = '';

        me.on('mount', function () {
            modal = $(me.root).modal();
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
        };

        me.saveConfig = function () {

        };

        me.show = function () {
            modal.modal('show');
        };

        me.hide = function () {
            modal.modal('hide');
        };
    </script>
</field-setting-dialog>

<!--<config-view-object-node>-->
<!--<div class="truncate">{config.displayName} - {config.name} - <strong>{config.type}</strong></div>-->
<!--<div class="ui fluid celled list sortable">-->
<!--<div each="{child in config.children}" class="fluid item" style="cursor: pointer;">-->
<!--<div class="right floated content">-->
<!--<div class="ui icon mini button" onclick="{showFieldSettingDialog}"><i class="setting icon"></i></div>-->
<!--<div class="ui red icon mini button" onclick="{removeField}"><i class="remove icon"></i></div>-->
<!--</div>-->
<!--<i class="archive icon" style="padding-top: 5px"></i>-->
<!--<div class="content" style="padding-top: 6px">-->
<!--<div class="truncate">{child.displayName} - {child.name} - <strong>{child.type}</strong></div>-->
<!--</div>-->
<!--</div>-->
<!--</div>-->
<!--</config-view-object-node>-->

<config-view-object-node>
    <div class="ui middle aligned divided list sortable" style="padding-left: 10px; padding-top: 3px;">
        <div each="{config in config.children}" class="item" style="cursor: pointer; border-top: 1px solid rgba(34,36,38,.15)">
            <div class="right floated content">
                <div class="ui icon mini button" onclick="{showFieldSettingDialog}"><i class="setting icon"></i></div>
                <div class="ui red icon mini button" onclick="{removeField}"><i class="remove icon"></i></div>
            </div>
            <i class="content icon" style="padding-top: 5px;"></i>
            <div class="content" style="padding-top: 6px">
                <div class="header">{config.displayName} - {config.name} - <strong>{config.type}</strong></div>
            </div>
            <virtual if="{config.type === 'Object'}">
                <div data-is="config-view-object-node" config="{config}" style="padding-left: 10px; padding-top: 3px;"></div>
            </virtual>
        </div>
    </div>

    <script>
        var me = this;

        me.on('updated', function () {
            var configItems = $(me.root).find('.sortable');
            var startIndex;
            configItems.sortable({
                start: function (e, ui) {
                    startIndex = ui.item.index();
                }
            });
        })
    </script>
</config-view-object-node>

<config-view style="height: calc(100% - 88px);">
    <add-config-field-dialog></add-config-field-dialog>
    <field-setting-dialog></field-setting-dialog>
    <h2>
        List of fields
        <div class="ui button right floated " onclick="{showAddConfigFieldDialog}">Add Field</div>
    </h2>
    <h3 class="text-success">(?) Click vào Setting button để điều chỉnh hiển thị trong phần Form nhập liệu</h3>
    <div class="" style="overflow: scroll; padding: 0; height: calc(100% - 80px); margin: 0 0 -14px; overflow-x: hidden;">
        <div class="ui middle aligned divided list sortable">
            <div each="{config in contentConfig}" class="item" style="cursor: pointer;">
                <div class="right floated content">
                    <div class="ui icon mini button" onclick="{showFieldSettingDialog}"><i class="setting icon"></i></div>
                    <div class="ui red icon mini button" onclick="{removeField}"><i class="remove icon"></i></div>
                </div>
                <i class="content icon" style="padding-top: 5px;"></i>
                <div class="content" style="padding-top: 6px">
                    <div class="header">{config.displayName} - {config.name} - <strong>{config.type}</strong></div>
                </div>
                <virtual if="{config.type === 'Object'}">
                    <div data-is="config-view-object-node" config="{config}" style="padding-left: 10px; padding-top: 3px;"></div>
                </virtual>
            </div>
        </div>
    </div>


    <script>
        var me = this;
        me.mixin('form');
        me.event = riot.observable();
        var $root = $(me.root);
        me.contentConfig = [];
        me.hiddenConfig = [];
        me.curFieldType = '';
        me.curConfig = {};
        me.originalFieldType = '';

        me.on('unmount', function () {

        });

        me.on('mount', function () {
//            me.selectorElm = $(me.root.querySelector('.selectpicker'));
//            me.selectorElm.selectpicker();

        });

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
            console.log('click saveConfig', contentType);
            var formTag = formTags[contentType];
            if (!formTag) return;

            var newConfig = formTag.getConfig();

            console.log('new config', newConfig);
            me.event.trigger('saveConfig', me.curConfigFieldName, newConfig);
            $(me.dialog).modal('hide');
        };


        me.showFieldSettingDialog = function (e) {
            console.log('showFieldSettingDialog', e.item);
            var fieldName = e.item.config.name;
            var fieldType = e.item.config.type;
            console.log('showFieldSettingDialog', fieldName);
            me.modalTitle = 'Configuration for ' + fieldName + ', displayName: ' + e.item.config.displayName;
            me.curFieldType = fieldType;
            me.curConfigFieldName = fieldName;
            me.curConfig = e.item.config;
            me.originalFieldType = fieldType;

            if (me.modal == null) {
                me.modal = $root.find('.modal').modal({
                    autofocus: false
                });
            }
            me.modal.modal('show');

//            me.selectorElm.selectpicker();
//            me.selectorElm.selectpicker('val', fieldType);
            console.log(me.fieldTypeDropDown);
            $(me.fieldTypeDropDown).dropdown();
            $(me.fieldTypeDropDown).dropdown('set selected', fieldType);
            console.log('set selected', fieldType);
            formTags[fieldType].clear(); // clear form setting
            formTags[fieldType].loadConfig(e.item.config);
            me.update();
        };

        me.loadContentConfig = function (contentConfig) {
            console.log('[config-view] loadContentConfig', contentConfig);
            var hiddenFieldNames = ['slug', 'layout'];
            me.hiddenConfig = [];
            me.contentConfig = contentConfig.filter(function (config) {
                if (hiddenFieldNames.indexOf(config.name) !== -1) {
                    me.hiddenConfig.push(config);
                    return false;
                }
                return true;
            });
            me.update();

//            console.log(me.root.querySelectorAll('.sortable'));
            var configItems = $(me.root.querySelector('.sortable'));
            var startIndex;
            configItems.sortable({
                start:  function (e, ui) {
                    startIndex = ui.item.index();
                },
                update: function (e, ui) {
                    var newIndex = ui.item.index();
//                    console.log('from', startIndex, 'to', newIndex);
                    var tmp = me.contentConfig[newIndex];
                    me.contentConfig[newIndex] = me.contentConfig[startIndex];
                    me.contentConfig[startIndex] = tmp;
                }
            });
            configItems.disableSelection();
        };

        me.removeField = function (e) {
            var fieldName = e.item.config.name;
//            console.log('remove field', fieldName);
            for (var i = 0; i < me.contentConfig.length; i++) {
                if (me.contentConfig[i].name === fieldName) {
                    me.contentConfig.splice(i, 1);
                    return;
                }
            }
        };

        me.getContentConfig = function () {
            return me.hiddenConfig.concat(me.contentConfig);
        };

        me.showAddConfigFieldDialog = function () {
            me.tags['add-config-field-dialog'].show();
        };
    </script>

    <style>
        .dropdown-backdrop {
            display: none;
        }
    </style>
</config-view>
