<config-view>
    <ul class="list-group" each="{config in contentConfig}">
        <li class="list-group-item">
            {config.displayName} - {config.name} - <strong>{config.type}</strong>
            <button class="btn btn-xs btn-danger pull-right" style="margin-left: 15px;" onclick="{removeField.bind(this,config.name)}"><i class="fa fa-close"></i></button>
            <button class="btn btn-xs btn-default pull-right" onclick="{showFieldSettingDialog.bind(this,config.name,config.type,config)}"><i class="fa fa-gear"></i> Setting</button>
            <div class="clearfix"></div>
        </li>
    </ul>

    <div class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">{modalTitle}</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">Type</label>
                            <div class="col-sm-10">
                                <select class="selectpicker" onchange="{ShowFieldConfig}">
                                    <option value="Boolean">Boolean</option>
                                    <option value="DateTime">DateTime</option>
                                    <option value="Media">Media</option>
                                    <option value="Number">Number</option>
                                    <option value="Text">Text</option>
                                </select>
                            </div>
                        </div>

                        <config-view-text show="{curFieldType === 'Text'}"></config-view-text>
                        <config-view-number show="{curFieldType === 'Number'}"></config-view-number>
                        <config-view-boolean show="{curFieldType === 'Boolean'}"></config-view-boolean>
                        <config-view-datetime show="{curFieldType === 'DateTime'}"></config-view-datetime>
                        <config-view-media show="{curFieldType === 'Media'}"></config-view-media>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="{saveConfig}">Save</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        var me = this;
        me.mixin('form');
        me.event = riot.observable();
        var $root = $(me.root);
        me.contentConfig = [];
        me.curFieldType = '';
        me.curConfig = {};
        me.originalFieldType = '';


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
            'Text':     me.tags['config-view-text']
        };

        me.saveConfig = function () {
            var contentType = $root.find('select').val();
            console.log('saveConfig', contentType);
            var formTag = formTags[contentType];
            if (!formTag) return;

            var newConfig = formTag.getConfig();

            console.log('new config', newConfig);
            me.event.trigger('saveLayoutConfig', me.curConfigFieldName, newConfig);
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

        me.showFieldSettingDialog = function (fieldName, fieldType, config) {
            console.log('show modal field', fieldName);
            me.modalTitle = 'Field - ' + fieldName;
            me.curFieldType = fieldType;
            me.curConfigFieldName = fieldName;
            me.curConfig = config;
            me.originalFieldType = fieldType;
            $root.find('.modal').modal('show');
            $($root.find('.selectpicker')[0]).selectpicker('val', fieldType);
            formTags[fieldType].clear(); // clear form setting
            formTags[fieldType].loadConfig(config);
            me.update();
        };

        me.loadContentConfig = function (contentConfig) {
//            console.log('[config-view] loadContentConfig', contentConfig);
            var ignoreFields = ['slug', 'layout'];
            me.contentConfig = contentConfig.filter(function (config) {
                return ignoreFields.indexOf(config.name) === -1;
            });
            me.update();
        };

        me.removeField = function (fieldName) {
//            console.log('remove field', fieldName);
            for (var i = 0; i < me.contentConfig.length; i++) {
                if (me.contentConfig[i].name === fieldName) {
                    me.contentConfig.splice(i, 1);
                    return;
                }
            }
        };

        me.getContentConfig = function () {
            return me.contentConfig;
        }
    </script>
</config-view>
