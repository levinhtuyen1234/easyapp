<config-view-text>
    <div class="field">
        <label>Display name:</label>
        <input type="text" class="form-control" id="textDisplayName" value="{config.displayName}" onkeyup="{edit('config.displayName')}">
    </div>
    <!-- This field is required -->
    <div class="inline field">
        <input type="checkbox" onchange="{edit('config.required')}" checked="{config.required}">
        <label class="">Is required</label>
    </div>
    <!-- View Only Field -->
    <div class="inline field">
        <input type="checkbox" onchange="{edit('config.viewOnly')}" checked="{config.viewOnly}">
        <label class="">Only View</label>
    </div>
    <br>

    <!-- Display Type -->
    <div class="inline field">
        <label class="">Display type:</label>
        <select class="ui dropdown" onchange="{edit('config.displayType'); tags['config-view-prop-predefined-value'].update()}">
            <option value="ShortText">Short Text</option>
            <option value="LongText">Long Text</option>
            <option value="MarkDown">Markdown</option>
            <option value="DropDown">DropDown</option>
        </select>
    </div>

    <config-view-prop-predefined-value type="text"></config-view-prop-predefined-value>
    <!--&lt;!&ndash; Specify number of characters &ndash;&gt;-->
    <!--<label>-->
    <!--<input type="checkbox" data-toggle="collapse" data-target="#textNumOfCharSection" onchange="{edit( 'textNumOfChar')}"> Specify number of characters-->
    <!--</label>-->
    <!--<div class="collapse" id="textNumOfCharSection">-->
    <!--<div class="form-group">-->
    <!--<label class="col-sm-2 control-label"></label>-->
    <!--<div class="col-sm-10">-->
    <!--<form class="form-inline">-->
    <!--<select class="selectpicker" onchange="{edit( 'textNumOfCharType')}" style="width: 240px;">-->
    <!--<option value="Between">Between</option>-->
    <!--<option value="AtLeast">At least</option>-->
    <!--<option value="NotMoreThan">Not more than</option>-->
    <!--</select>-->
    <!--<input type="number" class="form-control" id="textNumberMin" placeholder="Min" show="{textNumOfCharType == 'Between' || textNumOfCharType == 'AtLeast'}" style="width: 84px;">-->
    <!--<input type="number" class="form-control" id="textNumberMax" placeholder="Max" show="{textNumOfCharType == 'Between' || textNumOfCharType == 'NotMoreThan'}" style="width: 84px;">-->
    <!--</form>-->
    <!--</div>-->
    <!--</div>-->
    <!--</div>-->
    <!--<br>-->
    <!--&lt;!&ndash; Match a specific pattern &ndash;&gt;-->
    <!--<label>-->
    <!--<input type="checkbox" data-toggle="collapse" data-target="#textMatchPatternSection" onchange="{edit( 'textMatchPattern')}"> Match a specific pattern-->
    <!--</label>-->
    <!--<div class="collapse" id="textMatchPatternSection">-->
    <!--<label class="col-sm-2 control-label"></label>-->
    <!--<div class="col-sm-10">-->
    <!--<form class="form-inline">-->
    <!--<select class="selectpicker" onchange="{edit( 'textMatchPatternType')}" style="width: 240px;">-->
    <!--<option value="">Custom</option>-->
    <!--<option value="^\w[\w.-]*@([\w-]+\.)+[\w-]+$">Email</option>-->
    <!--<option value="^(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?$">URL</option>-->
    <!--</select>-->
    <!--<input name="textMatchPatternValue" type="text" class="form-control" id="textPattern" placeholder="" style="width: 320px;" value="{textMatchPatternType}">-->
    <!--<input name="textMatchPatternFlag" type="text" class="form-control" id="textPatternFlag" placeholder="Flags" style="width: 64px;" value="">-->
    <!--</form>-->
    <!--</div>-->
    <!--</div>-->
    <!--<br>-->

    <!--&lt;!&ndash; Predefined value &ndash;&gt;-->
    <!--<label>-->
    <!--<input type="checkbox" data-toggle="collapse" data-target="#textPredefinedValueSection" onchange="{edit( 'textPredefined')}"> Predefined value-->
    <!--</label>-->
    <!--<div class="collapse" id="textPredefinedValueSection">-->
    <!--<label class="col-sm-2 control-label"></label>-->
    <!--<div class="col-sm-10">-->
    <!--<div class="form-group">-->
    <!--&lt;!&ndash;<p class="help-block">Flags</p>&ndash;&gt;-->
    <!--<input type="text" class="form-control" id="textPredefinedText" placeholder="Add a value and hit Enter" onkeyup="{addPredefinedText}" style="width: 420px;">-->
    <!--</div>-->
    <!--<ul class="list-group">-->
    <!--<li class="list-group-item" each="{value, index in textPredefinedList}">{value}-->
    <!--<button class="btn btn-xs pull-right" onclick="{removePredefinedText.bind(this,value)}"><i class="fa fa-close"></i></button>-->
    <!--</li>-->
    <!--</ul>-->
    <!--</div>-->
    <!--</div>-->
    <script>
        var me = this;
        me.mixin('form');

        me.config = {type: 'Text', displayType: 'ShortText'};
        me.textNumOfCharType = 'Between';
        me.textMatchPatternType = '';

        me.on('mount', function () {
//            $(me.root.querySelector('.selectpicker')).selectpicker();
//            if (me.config.displayType) {
//                $(me.root.querySelector('.selectpicker')).selectpicker('val', me.config.displayType);
//            }
        });

        me.clear = function () {
            me.config = {
                type: 'Text'
            };
        };

        me.getConfig = function () {
            me.config.type = 'Text';
            return me.config;
        };

        me.loadConfig = function (config) {
            me.config = Object.assign({type: 'Text', displayType: 'ShortText'}, config);
            // select current displayType
            if (me.config.displayType) {
//                $(me.root.querySelector('.selectpicker')).selectpicker('val', me.config.displayType);
            }
            me.update();
        };
    </script>
</config-view-text>
