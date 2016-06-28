<form-editor id="{opts.id}" role="tabpanel" class="tab-pane {opts.active ? 'active':''}">
    <form class="form-horizontal" style="padding: 5px;">
    </form>
    <script>
        var me = this;
        me.form = null;

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

        function htmlToNode(html, className) {
            var div = document.createElement('div');
            div.innerHTML = html;
            if (className) div.className = className;
            return div;
        }

        function genTextInput(config, metaValue) {
            metaValue = metaValue ? metaValue : '';
            return htmlToNode(`
                <label for="" class="col-sm-3 control-label" style="text-align: left;">${config.displayName}</label>
                <div class="col-sm-9">
                    <input type="text" name="input-${config.name}" data-name="${config.name}" class="form-control" id="" value="${metaValue}">
                </div>`, 'form-group');
        }

        function genBooleanInput(config, metaValue) {
            metaValue = metaValue ? metaValue : false;
            return htmlToNode(`
                    <label for="" class="col-sm-3 control-label" style="text-align: left;">${config.displayName}
                    </label>
                    <div class="col-sm-9">
                        <div class="checkbox">
                        <label>
                            <input type="checkbox" name="input-${config.name}" data-name="${config.name}" ` + (metaValue ? 'checked' : '') + `>
                        </label>
                        </div>
                    </div>`, 'form-group');
        }

        function genIntegerInput(config, metaValue) {
            metaValue = metaValue ? metaValue : '';
            return htmlToNode(`
                    <label for="" class="col-sm-3 control-label" style="text-align: left;">${config.displayName}

                    </label>
                    <div class="col-sm-9">
                        <input type="number" name="input-${config.name}" data-name="${config.name}" class="form-control" id="" placeholder="${config.name}" value="${metaValue}">
                    </div>`, 'form-group');
        }

        function genArrayInput(config, metaValue) {
            metaValue = metaValue ? metaValue : {};
            return `<div class="form-group">
                    <label for="" class="col-sm-3 control-label" style="text-align: left;">${config.displayName}</label>
                    <div class="col-sm-9">
                        <button class="btn btn-primary btn-sm" onclick="javascript:addArrayItem(this, '${config.name}')"><i class="fa fa-plus"></i> Add</button>
                        <ul class="list-group">
                            <li class="list-group-item clearfix">
                                Aasdfasfasdfsaf
                                <span class="pull-right">
                                    <a class="btn btn-dander btn-sm"><i class="fa fa-trash"></i></a>
                                </span>
                            </li>
                            <li class="list-group-item clearfix">A<span class="pull-right"><a class="btn btn-dander btn-sm"><i class="fa fa-trash"></i></a></span></li>
                            <li class="list-group-item clearfix">A<span class="pull-right"><a class="btn btn-dander btn-sm"><i class="fa fa-trash"></i></a></span></li>
                            <li class="list-group-item clearfix">A<span class="pull-right"><a class="btn btn-dander btn-sm"><i class="fa fa-trash"></i></a></span></li>
                            <li class="list-group-item clearfix">A<span class="pull-right"><a class="btn btn-dander btn-sm"><i class="fa fa-trash"></i></a></span></li>
                            <li class="list-group-item clearfix">A<span class="pull-right"><a class="btn btn-dander btn-sm"><i class="fa fa-trash"></i></a></span></li>
                            <li class="list-group-item clearfix">A<span class="pull-right"><a class="btn btn-dander btn-sm"><i class="fa fa-trash"></i></a></span></li>
                            <li class="list-group-item clearfix">A<span class="pull-right"><a class="btn btn-dander btn-sm"><i class="fa fa-trash"></i></a></span></li>
                            <li class="list-group-item clearfix">A<span class="pull-right"><a class="btn btn-dander btn-sm"><i class="fa fa-trash"></i></a></span></li>
                        </ul>
                        <input type="text" name="input-${config.name}" data-name="${config.name}" class="form-control" id="" placeholder="${config.name}" value="${metaValue}">
                    </div>
                </div>`;
        }

        function genTextEditorInput(config, metaValue) {
            switch (typeof(metaValue)) {
                case 'undefined':
                    if (config.type === 'Array')
                        metaValue = '[]';
                    else if (config.type === 'Object')
                        metaValue = '{}';
                    break;
                case 'object':
                    metaValue = JSON.stringify(metaValue, null, 4);
                    break;
            }

            var node = htmlToNode(`
                    <label for="" class="col-sm-3 control-label" style="text-align: left;">${config.displayName}</label>
                    <div class="col-sm-9">
                        <div class="code-editor CodeMirror" id="${config.name}" style="border: 1px; padding: 0 0 15px 0;"></div>
                    </div>`, 'form-group');
            var editorElm = node.querySelector('.CodeMirror');
            var editor = CodeMirror(editorElm, {
                value:                   metaValue ? metaValue : '',
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
                height:                  'auto',
                lint:                    true,
                gutters:                 ['CodeMirror-linenumbers', 'CodeMirror-lint-markers'],
                mode:                    'application/json',
                firstLineNumber:         1,
                indentUnit:              4
            });

            me.codeEditorMap[config.name] = editor;

            setTimeout(function () {
                editor.refresh();
            }, 10);
            return node;
        }

        function genObjectInput(config, metaValue) {
            metaValue = metaValue ? metaValue : [];
            var node = htmlToNode(`
                <label for="" class="col-sm-3 control-label" style="text-align: left;">${config.displayName}</label>
                <div class="col-sm-9">
                    <input type="text" name="input-${config.name}" data-name="${config.name}" class="form-control" id="" placeholder="${config.name}" value="${metaValue}">
                </div>`, 'form-group');
            return node;
        }

        function getInputValue(input) {
            switch (input.type) {
                case 'checkbox':
                    return input.checked;
                    break;
                case 'number':
                    return parseFloat(input.value);
                default:
                    return input.value;
            }
        }

        me.getForm = function () {
            var inputs = me.form.querySelectorAll('input');
            var ret = {};
            // get value of input
            inputs.forEach(function (input) {
                console.log('input', input.dataset.name, getInputValue(input));
                ret[input.dataset.name] = getInputValue(input);
            });
            // get editor field
            for (var fieldName in me.codeEditorMap) {
                if (!me.codeEditorMap.hasOwnProperty(fieldName)) continue;
                ret[fieldName] = JSON.parse(me.codeEditorMap[fieldName].getValue());
            }
            console.log('ret', ret);
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
            me.form.innerHTML = '';
            me.codeEditorMap = {};
            var innerForm = '';
            for (var i = 0; i < contentConfig.length; i++) {
                var fieldConfig = contentConfig[i];
                var metaValue = metaData[fieldConfig.name];
                switch (fieldConfig.type) {
                    case 'Text':
                        me.form.appendChild(genTextInput(fieldConfig, metaValue));
                        break;
                    case 'Number':
                        me.form.appendChild(genIntegerInput(fieldConfig, metaValue));
                        break;
                    case 'Boolean':
                        me.form.appendChild(genBooleanInput(fieldConfig, metaValue));
                        break;
                    case 'DateTime':
                        me.form.appendChild(genDateTimeInput(fieldConfig, metaValue));
                        break;
                    case 'Array':
                        me.form.appendChild(genTextEditorInput(fieldConfig, metaValue));
                        break;
                    case 'Object':
                        me.form.appendChild(genTextEditorInput(fieldConfig, metaValue));
                        break;
                }
            }
//            me.form.innerHTML = innerForm;
        }
    </script>
</form-editor>
