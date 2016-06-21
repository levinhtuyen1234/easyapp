<field-setting-text class="modal fade" tabindex="-1" role="dialog">
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
    <script>
        var me = this;
    </script>
</field-setting-text>
