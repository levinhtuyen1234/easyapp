<form-field-text class="form-group">
    <label for="form-{config.name}" class="col-sm-3 control-label" style="text-align: left;">{config.displayName}</label>
    <div class="col-sm-9 input-group">
        <input type="text" id="form-{config.name}" data-name="{config.name}" class="form-control" value="{value}" onkeyup="{edit.bind(this,'value')}">
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
</form-field-text>

<form-field-number class="form-group">
    <label for="form-{config.name}" class="col-sm-3 control-label" style="text-align: left;">{config.displayName}
    </label>
    <div class="col-sm-9">
        <input type="number" id="form-{config.name}" class="form-control" value="${value}">
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
</form-field-number>

<form-field-boolean class="form-group">
    <label for="form-{config.name}" class="col-sm-3 control-label" style="text-align: left;">{config.displayName}
    </label>
    <div class="col-sm-9">
        <div class="checkbox">
            <label>
                <input type="checkbox" id="form-{config.name}" checked="{value}" onchange="{edit.bind(this,'value')}">
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
    <div class="col-sm-9 input-group">
        <input type="text" id="form-{config.name}" data-name="{config.name}" class="form-control" value="{value}" onkeyup="{edit.bind(this,'value')}">
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
</form-field-datetime>

<form-field-object class="form-group">
    <label for="form-{config.name}" class="col-sm-3 control-label" style="text-align: left;">{config.displayName}</label>
    <div class="col-sm-9">
        <texarea class="code-editor CodeMirror" id="form-{config.name}" style="border: 1px; padding: 0 0 15px 0;"></texarea>
    </div>
    <script>
        var me = this;
        me.mixin('form');
        me.config = opts.config || {};
        var editor;
        me.value = opts.value || '';

        me.on('mount', function () {
            console.log('typeof(me.value)', typeof(me.value), me.value, me.config.type);
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
            console.log('form-field-object mount',  'value', me.value);
            console.log('form-field-object mount', me.config);

            var editorElm = me.root.querySelector('.CodeMirror');
            editor = CodeMirror(editorElm, {
                value:                   me.value,
                rtlMoveVisually:         false,
                showCursorWhenSelecting: false,
                lineWrapping:            true,
                lineNumbers:             true,
                fixedGutter:             true,
                foldGutter:              false,
                matchBrackets:           true,
                styleActiveLine:         true,
                gutter:                  true,
                readOnly:                false,
                lint:                    true,
                height:                  'auto',
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
        <input type="text" class="form-control" value="{value}">
        <label class="input-group-btn">
            <span class="btn btn-default" onclick="{showChooseFile}">Browse local</span>
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
        });

        me.showChooseFile = function () {
            dialog.showOpenDialog({
                properties: ['openFile'],
                filters:    [
                    {name: 'All Media Files', extensions: ['*']}
                ]
            }, function (filePaths) {
                if (!filePaths || filePaths.length != 1) return;
                var filePath = filePaths[0];
                console.log('choose files', filePath);
                // TODO validate url
                // TODO copy file to asset/images and fix url to relative
                console.log('filePath[0]', filePath);
                var fileName = filePath.split(/[\\\/]/).pop();
                console.log('fileName', fileName);
                me.value = '/asset/img/' + fileName;
                riot.api.trigger('copyAssetFile', filePath, me.value);
                // copy file vo asset
                me.update();
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
    <form class="form-horizontal" style="padding: 5px;">
    </form>
    <script>
        var me = this;
        me.form = null;
        me.formfields = [];

        me.codeEditorMap = {};

        me.on('mount', function () {
            me.form = me.root.querySelector('form');
        });

        function genSimpleInput(display, name, type, value) {
            if (type === 'boolean') {
                return `<div class="form-group">
                    <label for="" class="col-sm-3 control-label" style="text-align: left;">${displayName}
                    </label>
                    <div class="col-sm-9">
                        <div class="checkbox">
                        <label>
                            <input type="checkbox" name="input-${name}" checked="${value}">
                        </label>
                        </div>
                    </div>
                </div>`;
            }
            return `<div class="form-group">
                <label for="" class="col-sm-3 control-label" style="text-align: left;">${displayName}

                </label>
                <div class="col-sm-9">
                    <input type="${type}" name="input-${name}" class="form-control" id="" placeholder="${value}" value="${value}">
                </div>
            </div>`;
        }

//        function genArrayInput(config, metaValue) {
//            metaValue = metaValue ? metaValue : {};
//            return `<div class="form-group">
//                    <label for="" class="col-sm-3 control-label" style="text-align: left;">${config.displayName}</label>
//                    <div class="col-sm-9">
//                        <button class="btn btn-primary btn-sm" onclick="javascript:addArrayItem(this, '${config.name}')"><i class="fa fa-plus"></i> Add</button>
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
//                        <input type="text" name="input-${config.name}" data-name="${config.name}" class="form-control" id="" placeholder="${config.name}" value="${metaValue}">
//                    </div>
//                </div>`;
//        }


        me.getForm = function () {
//            var inputs = me.form.querySelectorAll('input');
//            var ret = {};
//            // get value of input
//            inputs.forEach(function (input) {
//                console.log('input', input.dataset.name, getInputValue(input));
//                ret[input.dataset.name] = getInputValue(input);
//            });
//            // get editor field
//            for (var fieldName in me.codeEditorMap) {
//                if (!me.codeEditorMap.hasOwnProperty(fieldName)) continue;
//                ret[fieldName] = JSON.parse(me.codeEditorMap[fieldName].getValue());
//            }
//            console.log('ret', ret);
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
                // TODO fix this, tam thoi su dung object cho array luon
                if (tagTypeName === 'form-field-array')
                    tagTypeName = 'form-field-object';
                div.setAttribute('data-is', tagTypeName);
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
