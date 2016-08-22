<form-field-category-text class="form-group">
    <label for="form-{config.name}-{config.displayType}" class="col-sm-3 control-label" style="text-align: left;">{config.displayName}</label>
    <div class="col-sm-9 input-group">
        <select class="selectpicker" onchange="{edit.bind(this,'value')}">
            <option value=""></option>
            <option each="{category in categoryList}" value="{category.value}">{category.name}</option>
        </select>
    </div>
    <script>
        var me = this;
        me.mixin('form');
        me.config = opts.config || {};
        me.value = opts.value || '';
        me.categoryList = [];

        me.on('mount', function () {
            me.categoryList = BackEnd.getCategoryList(me.opts.siteName);
            me.categoryList.forEach(function (category) {
                category.name = category.name.split('.').join(' / ');
            });
            me.update();
            var dropdown = $(me.root.querySelector('select'));
            dropdown.selectpicker('refresh');
            dropdown.selectpicker('val', me.value);
        });

        me.getValue = function () {
            return me.value;
        };

        me.setValue = function (value) {
            me.value = value;
            me.update();
        };
    </script>
</form-field-category-text>

<form-field-tag-text class="form-group">
    <label for="form-{config.name}-{config.displayType}" class="col-sm-3 control-label" style="text-align: left;">{config.displayName}</label>
    <div class="col-sm-9 input-group">
        <select class="selectpicker" onchange="{editTag}" multiple>
            <option each="{tag in tagList}" value="{tag.value}">{tag.name}</option>
        </select>
    </div>
    <script>
        var me = this;
        me.mixin('form');
        me.config = opts.config || {};
        me.value = opts.value || '';
        me.tagList = [];

        me.editTag = function (e) {
            var selectedTags = $(e.srcElement).val();
            if (selectedTags == null)
                me.value = [];
            else
                me.value = selectedTags;
        };

        me.on('mount', function () {
            me.tagList = BackEnd.getTagList(me.opts.siteName);
            me.update();
            var dropdown = $(me.root.querySelector('select'));
            dropdown.selectpicker('refresh');
            dropdown.selectpicker('val', me.value);
        });

        me.getValue = function () {
            return me.value;
        };

        me.setValue = function (value) {
            me.value = value;
            me.update();
        };
    </script>
</form-field-tag-text>

<form-field-text class="form-group">
    <style>
        .fieldMarkDown {
            resize: vertical;
            min-height: 300px !important;
        }
    </style>
    <label for="form-{config.name}-{config.displayType}" class="col-sm-3 control-label" style="text-align: left;">{config.displayName}</label>
    <div class="col-sm-9 input-group">
        <input show="{config.displayType === 'ShortText'}" type="text" id="form-{config.name}-ShortText" class="form-control" onkeyup="{edit.bind(this,'value')}" readonly="{config.viewOnly}">
        <textarea show="{config.displayType === 'LongText'}" class="form-control" style="height: 150px; min-height: 150px;" rows="5" id="form-{config.name}-LongText" value="{value}" onkeyup="{edit.bind(this,'value')}" readonly="{config.viewOnly}"></textarea>

        <markdown-editor class="fieldMarkDown" show="{config.displayType === 'MarkDown'}" viewOnly="{config.viewOnly}"></markdown-editor>

        <div class="dropdown" show="{config.displayType === 'DropDown'}" id="form-{config.name}-DropDown">
            <button type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                {selectedName == '' ? 'Dropdown': selectedName}<span class="caret"></span>
            </button>
            <ul class="dropdown-menu">
                <li each="{config.predefinedData}">
                    <a href="#" onclick="{select.bind(this, name, value)}">{name}</a>
                </li>
            </ul>
        </div>
    </div>
    <script>
        var me = this;
        me.mixin('form');
        me.config = opts.config || {};
        me.config.displayType = me.config.displayType || 'ShortText';
        //console.log('me.config.displayType', me.config.displayType);
        me.value = opts.value || '';
        me.selectedName = '';

        me.select = function (name, value) {
            me.value = value;
            me.selectedName = name;
            me.update();
        };

        me.on('mount', function () {
            setTimeout(function () {
                me.setValue(me.value);
                me['form-' + me.config.name + '-ShortText'].value = me.value;
                // neu displayType dropdown tu` value -> name selected
                // TODO tach rieng ra tag rieng neu co hon 3 tag su dung dropdown
                if (me.config.displayType === 'DropDown' && me.config.predefinedData) {
                    me.config.predefinedData.forEach(function (data) {
                        if (data.value == me.value) {
                            me.selectedName = data.name;
                            me.update();
                        }
                    });
                }

                if (me.config.displayType === 'MarkDown') {
                    $(me.root.querySelectorAll('.CodeMirror-scroll')).addClass('fieldMarkDown');
                    $(me.root.querySelectorAll('.CodeMirror')).resizable({
                        handles: 's'
                    });
                }
            }, 1);
        });

        me.getValue = function () {
            if (me.config.displayType === 'MarkDown') {
                return me.tags['markdown-editor'].value();
            } else
                return me.value;
        };

        me.setValue = function (value) {
            if (me.config.displayType === 'MarkDown') {
                return me.tags['markdown-editor'].value(value);
            } else {
                me.value = value;
            }
            me.update();
        };
    </script>
</form-field-text>

<form-field-number class="form-group">
    <label for="form-{config.name}-{config.displayType}" class="col-sm-3 control-label" style="text-align: left;">{config.displayName}
    </label>
    <div class="col-sm-9 input-group">
        <input type="number" show="{config.displayType === 'Number'}" id="form-{config.name}-Number" class="form-control" onkeyup="{edit.bind(this,'value')}" readonly="{config.viewOnly}">

        <div class="dropdown" show="{config.displayType === 'DropDown'}" id="form-{config.name}-DropDown">
            <button type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                {selectedName == '' ? 'Dropdown': selectedName}<span class="caret"></span>
            </button>
            <ul class="dropdown-menu">
                <li each="{config.predefinedData}">
                    <a href="#" onclick="{select.bind(this, name, value)}">{name}</a>
                </li>
            </ul>
        </div>
    </div>
    <script>
        var me = this;
        me.mixin('form');
        me.config = opts.config || {};
        me.value = opts.value || '';
        me.selectedName = '';

        me.on('mount', function () {
            me['form-' + me.config.name + '-Number'].value = me.value;
            // neu displayType dropdown tu` value -> name selected
            if (me.config.displayType === 'DropDown' && me.config.predefinedData) {
                me.config.predefinedData.forEach(function (data) {
                    if (data.value == me.value) {
                        me.selectedName = data.name;
                        me.update();
                    }
                });
            }
        });

        me.select = function (name, value) {
            me.value = value;
            me.selectedName = name;
            me.update();
        };

        me.getValue = function () {
            return me.value;
        };

        me.setValue = function (value) {
            me.value = value;
            me.update();
        };
    </script>
</form-field-number>

<form-field-boolean class="form-group">
    <label for="form-{config.name}" class="col-sm-3 control-label" style="text-align: left;">{config.displayName}
    </label>
    <div class="col-sm-9">
        <div class="checkbox">
            <label>
                <input type="checkbox" id="form-{config.name}" checked="{value}" onchange="{edit.bind(this,'value')}" disabled="{config.viewOnly}">
            </label>
        </div>
    </div>
    <script>
        var me = this;
        me.mixin('form');
        me.config = opts.config || {};
        me.value = opts.value || '';

        me.on('mount', function () {
        });

        me.getValue = function () {
            return me.value;
        };

        me.setValue = function (value) {
            me.value = value;
            me.update();
        };
    </script>
</form-field-boolean>

<form-field-datetime class="form-group">
    <label for="form-{config.name}" class="col-sm-3 control-label" style="text-align: left;">{config.displayName}</label>
    <div class='col-sm-9 input-group date'>
        <input type='text' class="form-control" id="form-{config.name}" onkeyup="{edit.bind(this,'value')}" readonly="{config.viewOnly}"/>
        <span class="input-group-addon">
                <span class="glyphicon glyphicon-calendar" disabled="{config.viewOnly}"></span>
            </span>
    </div>
    <script>
        var me = this;
        me.mixin('form');
        me.config = opts.config || {};
        me.value = opts.value || '';

        me.on('mount', function () {
            me['form-' + me.config.name].value = me.value;
            var elm = me.root.querySelector('.input-group.date');
            var config = {};
            me.config.displayType = me.config.displayType || 'DateTime';
            if (me.config.displayType === 'Date')
                config.format = 'DD-MM-YYYY';
            else if (me.config.displayType === 'Time')
                config.format = 'hh:mm:ss A';
            else
                config.format = 'DD-MM-YYYY hh:mm:ss A';
            $(elm).datetimepicker(config)
                    .on('dp.change', function (e) {
                        me.value = e.date.format(config.format);
                    });

        });

        me.getValue = function () {
            return me.value;
        };

        me.setValue = function (value) {
            me.value = value;
            me.update();
        };
    </script>
</form-field-datetime>

<form-field-object class="form-group">
    <label for="form-{config.name}" class="col-sm-3 control-label" style="text-align: left;">{config.displayName}</label>
    <div class="col-sm-9" style="padding: 0; margin: 0;">
        <texarea class="code-editor CodeMirror" id="form-{config.name}" style="border: 1px;"></texarea>
    </div>
    <style>
        .CodeMirrorForm {
            resize: vertical;
            min-height: 130px !important;
        }
    </style>
    <script>
        var me = this;
        me.mixin('form');
        me.config = opts.config || {};
        var editor;
        me.value = opts.value || '';

        me.on('mount', function () {
            setTimeout(function () {
                $(me.root.querySelectorAll('.CodeMirror')).addClass('CodeMirrorForm');
                $(me.root.querySelectorAll('.CodeMirror-scroll')).addClass('CodeMirrorForm');

                $(me.root.querySelectorAll('.CodeMirror')).resizable({
                    handles: 's',
                    resize:  function () {
                        editor.setSize('100%', $(this).height());
                    }
                });
            }, 0);

            switch (typeof(me.value)) {
                case 'undefined':
                case 'string':
                    if (me.config.type === 'Array')
                        me.value = '[]';
                    else if (me.config.type === 'Object')
                        me.value = '{}';
                    break;
                case 'object':
                    me.value = JSON.stringify(me.value, null, 4);
                    break;
            }

            var editorElm = me.root.querySelector('.CodeMirror');
            editor = CodeMirror(editorElm, {
                value:                   me.value,
                rtlMoveVisually:         false,
                showCursorWhenSelecting: false,
                lineWrapping:            false,
                lineNumbers:             true,
                fixedGutter:             true,
                foldGutter:              false,
                matchBrackets:           true,
                styleActiveLine:         true,
                gutter:                  true,
                readOnly:                !!(me.config.viewOnly),
                lint:                    true,
//                height:                  150,
                scrollbarStyle:          'simple',
                gutters:                 ['CodeMirror-linenumbers', 'CodeMirror-lint-markers'],
                mode:                    'application/json',
                firstLineNumber:         1,
                indentUnit:              4
            });

            setTimeout(function () {
                editor.refresh();
            }, 10);
        });

        me.getValue = function () {
            return JSON.parse(editor.getValue());
        };

        me.setValue = function (value) {
            editor.setValue(value);
            me.update();
        };
    </script>
</form-field-object>

<form-field-media class="form-group">
    <label for="form-{config.name}" class="col-sm-3 control-label" style="text-align: left;">{config.displayName}
    </label>
    <div class="col-sm-9 input-group">
        <input type="text" class="form-control" id="form-{config.name}" readonly="{config.viewOnly}">
        <label class="input-group-btn">
            <span class="btn btn-default" onclick="{showChooseFile}" disabled="{config.viewOnly}">Browse local</span>
        </label>
    </div>
    <script>
        var dialog = require('electron').remote.dialog;
        var fs = require('fs');
        var me = this;
        me.mixin('form');
        me.config = opts.config || {};
        me.value = opts.value || '';

        me.on('mount', function () {
            me['form-' + me.config.name].value = me.value;
        });

        me.showChooseFile = function () {
            if (me.config.viewOnly) return;
            riot.api.trigger('chooseMediaFile', function (relativePath) {
//                me.value = relativePath.split(/[\\\/]/).pop();
                me.value = relativePath;
                me['form-' + me.config.name].value = relativePath;
                me.update();

                console.log('chooseMediaFile cb', 'me.value', me.value, relativePath);
            });
        };

        me.getValue = function () {
            return me.value;
        };

        me.setValue = function (value) {
            me.value = value;
            me.update();
        };
    </script>
</form-field-media>

<form-editor id="{opts.id}" role="tabpanel" class="tab-pane {opts.active ? 'active':''}">
    <form class="form-horizontal" style="padding: 5px;" onkeypress="{checkSave}">
    </form>
    <script>
        var me = this;
        me.form = null;
        me.formfields = [];
        me.siteName = me.opts.siteName;
        me.codeEditorMap = {};

        me.on('mount', function () {
            me.form = me.root.querySelector('form');
        });

        me.checkSave = function (e) {
            if (!(e.which == 115 && e.ctrlKey) && !(e.which == 19)) return true;
            console.log('Ctrl-S pressed');
            riot.api.trigger('codeEditor.save');
            e.preventDefault();
            return false;
        };

        function genSimpleInput(display, name, type, value) {
            if (type === 'boolean') {
                return `<div class="form-group">
                    <label for="" class="col-sm-3 control-label" style="text-align: left;">{displayName}
                    </label>
                    <div class="col-sm-9">
                        <div class="checkbox">
                        <label>
                            <input type="checkbox" name="input-{name}" checked="{value}">
                        </label>
                        </div>
                    </div>
                </div>`;
            }
            return `<div class="form-group">
                <label for="" class="col-sm-3 control-label" style="text-align: left;">{displayName}

                </label>
                <div class="col-sm-9">
                    <input type="{type}" name="input-{name}" class="form-control" id="" placeholder="{value}" value="{value}">
                </div>
            </div>`;
        }

        //        function genArrayInput(config, metaValue) {
        //            metaValue = metaValue ? metaValue : {};
        //            return `<div class="form-group">
        //                    <label for="" class="col-sm-3 control-label" style="text-align: left;">{config.displayName}</label>
        //                    <div class="col-sm-9">
        //                        <button class="btn btn-primary btn-sm" onclick="javascript:addArrayItem(this, '{config.name}')"><i class="fa fa-plus"></i> Add</button>
        //                        <ul class="list-group">
        //                            <li class="list-group-item clearfix">
        //                                Aasdfasfasdfsaf
        //                                <span class="pull-right">
        //                                    <a class="btn btn-dander btn-sm"><i class="fa fa-trash"></i></a>
        //                                </span>
        //                            </li>
        //                            <li class="list-group-item clearfix">A<span class="pull-right"><a class="btn btn-dander btn-sm"><i class="fa fa-trash"></i></a></span></li>
        //                            <li class="list-group-item clearfix">A<span class="pull-right"><a class="btn btn-dander btn-sm"><i class="fa fa-trash"></i></a></span></li>
        //                            <li class="list-group-item clearfix">A<span class="pull-right"><a class="btn btn-dander btn-sm"><i class="fa fa-trash"></i></a></span></li>
        //                            <li class="list-group-item clearfix">A<span class="pull-right"><a class="btn btn-dander btn-sm"><i class="fa fa-trash"></i></a></span></li>
        //                            <li class="list-group-item clearfix">A<span class="pull-right"><a class="btn btn-dander btn-sm"><i class="fa fa-trash"></i></a></span></li>
        //                            <li class="list-group-item clearfix">A<span class="pull-right"><a class="btn btn-dander btn-sm"><i class="fa fa-trash"></i></a></span></li>
        //                            <li class="list-group-item clearfix">A<span class="pull-right"><a class="btn btn-dander btn-sm"><i class="fa fa-trash"></i></a></span></li>
        //                            <li class="list-group-item clearfix">A<span class="pull-right"><a class="btn btn-dander btn-sm"><i class="fa fa-trash"></i></a></span></li>
        //                        </ul>
        //                        <input type="text" name="input-{config.name}" data-name="{config.name}" class="form-control" id="" placeholder="{config.name}" value="{metaValue}">
        //                    </div>
        //                </div>`;
        //        }


        me.getForm = function () {
//            var inputs = me.form.querySelectorAll('input');
//            var ret = {};
//            // get value of input
//            inputs.forEach(function (input) {
//                ret[input.dataset.name] = getInputValue(input);
//            });
//            // get editor field
//            for (var fieldName in me.codeEditorMap) {
//                if (!me.codeEditorMap.hasOwnProperty(fieldName)) continue;
//                ret[fieldName] = JSON.parse(me.codeEditorMap[fieldName].getValue());
//            }
//            return ret;
            var ret = {};
            me.formfields.forEach(function (field) {
                ret[field.config.name] = (field.getValue());
            });
            return ret;
        };

        me.clear = function () {
            me.form.innerHTML = '';
        };

        me.addArrayItem = function (name) {
            console.log('addArrayItem', name);
        };

        me.genForm = function (metaData, contentConfig) {
//            console.log('genForm', metaData, contentConfig);
            // unmount any exists form field
            me.formfields.forEach(function (field) {
                if (field != undefined)
                    field.unmount();
            });

            me.formfields = [];

            me.form.innerHTML = '';
            me.codeEditorMap = {};

            for (var i = 0; i < contentConfig.length; i++) {
                var fieldConfig = contentConfig[i];
                var metaValue = metaData[fieldConfig.name];
                var div = document.createElement('div');
                var tagTypeName = 'form-field-' + fieldConfig.type.toLowerCase();
                // special case for category
                if (fieldConfig.name === 'category') {
                    tagTypeName = 'form-field-category-text';
                } else if (fieldConfig.name === 'tag') {
                    tagTypeName = 'form-field-tag-text';
                }
                // TODO fix this, tam thoi su dung object cho array luon
                if (tagTypeName === 'form-field-array')
                    tagTypeName = 'form-field-object';
                div.setAttribute('data-is', tagTypeName);
                div.setAttribute('site-name', me.opts.siteName);
                me.form.appendChild(div);
                var tag = riot.mount(div, {
                    config: fieldConfig,
                    value:  metaValue
                })[0];
                me.formfields.push(tag);
            }
        }
    </script>
</form-editor>
