<config-view>
    <h2>List of fields</h2>
    <h3 class="text-success">(?) Click vào Setting button để điều chỉnh hiển thị trong phần Form nhập liệu</h3>
    <div class="" style="overflow: auto; padding: 0; height: calc(100vh - 240px); margin: 0 0 -14px;">
        <div class="ui celled list sortable">
            <div each="{config in contentConfig}" class="item" style="cursor: pointer;">
                <div class="right floated content">
                    <div class="ui icon mini button" onclick="{showFieldSettingDialog}"><i class="setting icon"></i></div>
                    <div class="ui red icon mini button" onclick="{removeField}"><i class="remove icon"></i></div>
                </div>
                <i class="content icon" style="padding-top: 5px"></i>
                <div class="content" style="padding-top: 6px">
                    <div class="truncate">{config.displayName} - {config.name} - <strong>{config.type}</strong></div>
                </div>
            </div>
        </div>
    </div>

    <div class="ui modal" tabindex="-1" name="dialog">
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

        me.ShowFieldConfig = function (e) {
            console.log('ShowFieldConfig', e.target.value);
            me.curFieldType = e.target.value;
            // set displayName khi chuyen sang Content type khac
            if (me.curFieldType !== me.originalFieldType) {
                formTags[me.curFieldType].loadConfig({
                    name:        me.curConfig.name,
                    displayName: me.curConfig.displayName
                });
            }
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
            window.mydialog = me.modal;
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
            console.log('[config-view] loadContentConfig');
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
        }
    </script>

    <style>
        .dropdown-backdrop {
            display: none;
        }
    </style>
</config-view>
