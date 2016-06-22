<config-view>
    <ul class="list-group" each="{contentConfig}">
        <li class="list-group-item">
            {displayName} - {name} - <strong>{type}</strong>
            <button class="btn btn-xs btn-danger pull-right" style="margin-left: 15px;" onclick="{removeField.bind(this,name)}"><i class="fa fa-close"></i></button>
            <button class="btn btn-xs btn-default pull-right" onclick="{showFieldSettingDialog.bind(this,name,type)}"><i class="fa fa-gear"></i> Setting</button>
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
                    <!--<form class="form-horizontal">-->
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Type</label>
                        <div class="col-sm-10">
                            <select class="selectpicker" onchange="{edit.bind(this,'curFieldType')}">
                                <option value="Text">Text</option>
                                <option value="Number">Number</option>
                                <option value="Boolean">Boolean</option>
                                <option value="DateTime">DateTime</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Display name:</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="textDisplayName" placeholder="{displayName}">
                        </div>
                    </div>
                    <!-- TEXT FIELD OPTIONS -->
                    <div show="{curFieldType === 'Text'}">
                        <!-- This field is required -->
                        <label>
                            <input type="checkbox" onchange="{edit.bind(this, 'textRequired')}"> This field is required
                        </label>
                        <br>
                        <!-- Specify number of characters -->
                        <label>
                            <input type="checkbox" data-toggle="collapse" data-target="#textNumOfCharSection" onchange="{edit.bind(this, 'textNumOfChar')}"> Specify number of characters
                        </label>
                        <div class="collapse" id="textNumOfCharSection">
                            <form class="form-inline">
                                <select class="selectpicker" onchange="{edit.bind(this, 'textNumOfCharType')}" style="width: 240px;">
                                    <option value="Between">Between</option>
                                    <option value="AtLeast">At least</option>
                                    <option value="NotMoreThan">Not more than</option>
                                </select>
                                <div class="form-group" show="{textNumOfCharType == 'Between' || textNumOfCharType == 'AtLeast'}">
                                    <input type="number" class="form-control" id="textNumberMin" placeholder="Min" style="width: 84px;">
                                </div>
                                <div class="form-group" show="{textNumOfCharType == 'Between' || textNumOfCharType == 'NotMoreThan'}">
                                    <input type="number" class="form-control" id="textNumberMax" placeholder="Max" style="width: 84px;">
                                </div>
                            </form>
                        </div>
                        <br>
                        <!-- Match a specific pattern -->
                        <label>
                            <input type="checkbox" data-toggle="collapse" data-target="#textMatchPatternSection" onchange="{edit.bind(this, 'textMatchPattern')}"> Match a specific pattern
                        </label>
                        <div class="collapse" id="textMatchPatternSection">
                            <form class="form-inline">
                                <select class="selectpicker" onchange="{edit.bind(this, 'textMatchPatternType')}" style="width: 240px;">
                                    <option value="">Custom</option>
                                    <option value="^\w[\w.-]*@([\w-]+\.)+[\w-]+$">Email</option>
                                    <option value="^(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?$">URL</option>
                                </select>
                                <div class="form-group">
                                    <input name="textMatchPatternValue" type="text" class="form-control" id="textPattern" placeholder="" style="width: 320px;" value="{textMatchPatternType}">
                                </div>
                                <div class="form-group">
                                    <label>Flags</label>
                                    <input name="textMatchPatternFlag" type="text" class="form-control" id="textPatternFlag" placeholder="" style="width: 64px;" value="">
                                </div>
                            </form>
                        </div>
                        <br>

                        <!-- Predefined value -->
                        <label>
                            <input type="checkbox" data-toggle="collapse" data-target="#textPredefinedValueSection" onchange="{edit.bind(this, 'textPredefined')}"> Predefined value
                        </label>
                        <div class="collapse" id="textPredefinedValueSection">
                            <div class="form-group">
                                <!--<p class="help-block">Flags</p>-->
                                <input type="text" class="form-control" id="textPredefinedText" placeholder="Add a value and hit Enter" onkeyup="{addPredefinedText}" style="width: 420px;">
                            </div>
                            <ul class="list-group">
                                <li class="list-group-item" each="{value, index in textPredefinedList}">{value}
                                    <button class="btn btn-xs pull-right" onclick="{removePredefinedText.bind(this,value)}"><i class="fa fa-close"></i></button>
                                </li>
                            </ul>
                        </div>

                    </div>
                    <!-- END TEXT FIELD OPTIONS -->
                    <div show="{curFieldType === 'Number'}"><h1>Number OPTIONS</h1></div>
                    <div show="{curFieldType === 'Boolean'}"><h1>BOOLEAN OPTIONS</h1></div>
                    <div show="{curFieldType === 'DateTime'}"><h1>DATE TIME OPTIONS</h1></div>
                    <!--</form>-->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="{saveSetting}">Save</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        console.trace('me');
        var me = this;
        var $root = $(me.root);
        me.contentConfig = [];

        me.curFieldType = '';
        me.textNumOfCharType = 'Between';
        me.textMatchPatternType = '';
        me.textPredefinedList = [];

        //        me.getTextSetting = function() {
        //
        //        };

        me.edit = function (name, e) {
            switch (e.target.type) {
                case 'checkbox':
                    me[name] = e.target.checked;
                    break;
                default:
                    me[name] = e.target.value;
            }
        };

        me.addPredefinedText = function (e) {
            var EnterKey = 13;
            if (e.which != EnterKey) return;

            var value = e.target.value;
            e.target.value = '';
            console.log('addPredefinedText', value);
            var index = me.textPredefinedList.indexOf(value);    // <-- Not supported in <IE9
            if (index === -1) {
                me.textPredefinedList.push(value);
                me.update();
            }
        };

        me.removePredefinedText = function (value) {
            var index = me.textPredefinedList.indexOf(value);    // <-- Not supported in <IE9
            if (index !== -1) {
                me.textPredefinedList.splice(index, 1);
                me.update();
            }
        };

        me.saveSetting = function () {
            var contentType = $root.find('select').val();
            console.log('save setting contentType', contentType);
            var settings = {
                contentType:  $root.find('select').val(),
                textRequired: me.textRequired,

                textNumOfChar:     me.textNumOfChar,
                textNumOfCharType: me.textNumOfCharType,
                textNumOfCharMin:  me.textNumOfCharMin,
                textNumOfCharMax:  me.textNumOfCharMax,

                textMatchPattern:      me.textMatchPattern,
                textMatchPatternType:  me.textMatchPatternType,
                textMatchPatternValue: me.textMatchPatternValue,
                textMatchPatternFlag:  me.textMatchPatternFlag,

                textPredefined:     me.textPredefined,
                textPredefinedList: me.textPredefinedList
            };
            console.log('settings', settings);
        };

        me.showFieldOptions = function (e) {
            console.log('showFieldOptions', e.target.value);
            me.curFieldType = e.target.value;
        };

        me.showFieldSettingDialog = function (fieldName, fieldType) {
            console.log('show modal field', fieldName);
            me.modalTitle = 'Field - ' + fieldName;
            me.curFieldType = fieldType;
            me.update();
            window.r = $root;
            $root.find('.modal').modal('show');
            $root.find('select').selectpicker();
        };

        me.loadContentConfig = function (contentConfig) {
            console.log('[config-view] loadContentConfig', contentConfig);
            me.contentConfig = contentConfig;
            me.update();
        };

        me.removeField = function(fieldName) {
            console.log('remove field', fieldName);
            for (var i = 0; i < me.contentConfig.length; i++) {
                if (me.contentConfig[i].name === fieldName) {
                    me.contentConfig.splice(i, 1);
                    return;
                }
            }
        };

        me.getContentConfig = function() {
            return me.contentConfig;
        }
    </script>
</config-view>
