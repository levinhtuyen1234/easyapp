<form-field-category-text class="inline fields">
    <label for="form-{config.name}-{config.displayType}" class="two wide field" style="">{config.displayName}</label>

    <div class="ui menu fluid">
        <div class="ui fluid selection dropdown">
            <input name="gender" type="hidden">
            <i class="dropdown icon"></i>
            <div class="default text">Choose Category</div>
            <div class="menu">
                <div class="item" each="{category in categoryList}" data-value="{category.value}">{category.name}</div>
            </div>
        </div>
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
//            var dropdown = $(me.root.querySelector('select'));
//            dropdown.selectpicker('refresh');
//            dropdown.selectpicker('val', me.value);

            $(me.root.querySelector('.ui.dropdown')).dropdown({
                onChange: function (value, text) {
                    console.log('on change', value, text);
                    me.value = value;
                }
            }).dropdown('set selected', me.value);
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

<form-field-tag-text class="inline fields">
    <label for="form-{config.name}-{config.displayType}" class="two wide field" style="">{config.displayName}</label>
    <div class="ui menu fluid">
        <div class="ui fluid selection multiple dropdown">
            <input name="gender" type="hidden">
            <i class="dropdown icon"></i>
            <div class="default text">Choose some tags</div>
            <div class="menu">
                <div class="item" each="{tag in tagList}" data-value="{tag.name}">{tag.name}</div>
            </div>
        </div>
    </div>
    <!--<select class="selectpicker" onchange="{editTag}" multiple>-->
    <!--<option each="{tag in tagList}" value="{tag.value}">{tag.name}</option>-->
    <!--</select>-->
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
//            var dropdown = $(me.root.querySelector('select'));
//            dropdown.selectpicker('refresh');
//            dropdown.selectpicker('val', me.value);
            $(me.root).find('.ui .dropdown').dropdown({
                onChange: function (value, text) {
                    console.log('on change', value, text);
                    me.value = value;
                }
            }).dropdown('set selected', me.value);
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

<form-field-text class=" inline field">
    <style>
        .fieldMarkDown {
            resize: vertical;
            min-height: 300px !important;
        }
    </style>
    <label for="form-{config.name}-{config.displayType}" name="label" class="two wide field" style="text-align: left;">{config.displayName}</label>
    <input if="{config.displayType === 'ShortText'}" class="eight wide field" type="text" id="form-{config.name}-ShortText" onkeyup="{edit('value')}" readonly="{config.viewOnly}">
    <textarea if="{config.displayType === 'LongText'}" style="height: 150px; min-height: 150px;" rows="5" id="form-{config.name}-LongText" value="{value}" onkeyup="{edit('value')}" readonly="{config.viewOnly}"></textarea>

    <markdown-editor if="{config.displayType === 'MarkDown'}" height="300px" viewOnly="{config.viewOnly}"></markdown-editor>

    <div class="dropdown" if="{config.displayType === 'DropDown'}" id="form-{config.name}-DropDown">
        <button type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            {selectedName == '' ? 'Dropdown': selectedName}<span class="caret"></span>
        </button>
        <ul class="dropdown-menu">
            <li each="{config.predefinedData}">
                <a href="#" onclick="{select.bind(this, name, value)}">{name}</a>
            </li>
        </ul>
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

//                if (me.config.displayType === 'MarkDown') {
//                    $(me.root.querySelectorAll('.CodeMirror-scroll')).addClass('fieldMarkDown');
//                    $(me.root.querySelectorAll('.CodeMirror')).resizable({
//                        handles: 's'
//                    });
//                    $(me.label).removeClass('col-sm-3');
//                    $(me.content).removeClass('col-sm-9');
//                    $(me.label).addClass('col-sm-12');
//                    $(me.content).addClass('col-sm-12');
//                }
            }, 1);
        });

        me.getValue = function () {
            if (me.config.displayType === 'MarkDown') {
                return me.tags['markdown-editor'].getValue();
            } else
                return me.value;
        };

        me.setValue = function (value) {
            if (me.config.displayType === 'MarkDown') {
                return me.tags['markdown-editor'].setValue(value);
            } else {
                me.value = value;
            }
            me.update();
        };
    </script>
</form-field-text>

<form-field-number class="field">
    <label for="form-{config.name}-{config.displayType}" class="" style="text-align: left;">{config.displayName}
    </label>
    <input type="number" if="{config.displayType === 'Number'}" id="form-{config.name}-Number" class="form-control" onkeyup="{edit('value')}" readonly="{config.viewOnly}">

    <div class="dropdown" if="{config.displayType === 'DropDown'}" id="form-{config.name}-DropDown">
        <button type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            {selectedName == '' ? 'Dropdown': selectedName}<span class="caret"></span>
        </button>
        <ul class="dropdown-menu">
            <li each="{config.predefinedData}">
                <a href="#" onclick="{select.bind(this, name, value)}">{name}</a>
            </li>
        </ul>
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

<form-field-boolean class="inline field">
    <label style="vertical-align: middle; margin-bottom: 12px;">{config.displayName}</label>
    <div class="ui toggle checkbox">
        <input id="form-{config.name}" class="hidden" tabindex="0" type="checkbox" checked="{value}" onchange="{edit('value')}" disabled="{config.viewOnly}">
    </div>
    <script>
        var me = this;
        me.mixin('form');
        me.config = opts.config || {};
        me.value = opts.value || '';

        me.on('mount', function () {
            $(me.root.querySelector('.ui.checkbox')).checkbox();
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

<form-field-datetime class="inline fields">
    <label for="form-{config.name}" class="two wide field">{config.displayName}</label>
    <div class="ui calendar six wide field" ref="validFromCalendar">
        <div class="ui input left icon">
            <i class="calendar icon"></i>
            <input type="text" placeholder="" id="form-{config.name}" onkeyup="{edit('value')}" readonly="{config.viewOnly}">
        </div>
    </div>

    <script>
        var me = this;
        me.mixin('form');
        me.config = opts.config || {};
        me.value = opts.value || '';

        me.on('mount', function () {
            me['form-' + me.config.name].value = me.value;
            var elm = me.root.querySelector('input');
            var config = {};
            me.config.displayType = me.config.displayType || 'DateTime';
            var format, calendarType;
            if (me.config.displayType === 'Date') {
                format = 'DD-MM-YYYY';
                calendarType = 'date';
            } else if (me.config.displayType === 'Time') {
                format = 'HH:mm:ss';
                calendarType = 'time';
            } else {
                format = 'DD-MM-YYYY HH:mm:ss';
                calendarType = 'datetime';
            }

            console.log('calendarType', calendarType);

            $(me.root.querySelector('.ui.calendar')).calendar({
                type:     calendarType,
                onChange: function (date, text) {
                    console.log('date', date);
                    console.log('text', text);
                    console.log('formated', moment(date).format(format));
                    me.value = moment(date).format(format);
                    me['form-' + me.config.name].value = me.value;
                }
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

<form-field-object>
    <div class="ui styled fluid accordion" style="margin-top: 5px; margin-bottom: 5px;">
        <div class="title">
            <i class="dropdown icon"></i>
            {config.displayName} &nbsp;
            <!--<div class="ui mini basic icon float button" onclick="{addChild}">-->
            <!--<i class="blue add icon"></i>-->
            <!--</div>-->
        </div>
        <div class="content accordion-content">
        </div>
    </div>
    <script>
        var me = this;
        me.mixin('form');
        me.config = opts.config || {};
        me.value = opts.value || '';

        var content = null;
        var formFields = [];

        var genForm = function (metaData, contentConfig) {
            content.innerHTML = '';
            if (contentConfig == undefined) {
                console.log('BUG', contentConfig, metaData);
            }
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

                div.setAttribute('data-is', tagTypeName);
                div.setAttribute('site-name', me.opts.siteName);
                content.appendChild(div);
                var tag = riot.mount(div, {
                    config: fieldConfig,
                    value:  metaValue
                })[0];
                formFields.push(tag);
            }
        };

        me.addChild = function (e) {
            console.log('add CHILD');
            e.preventDefault();
            e.stopPropagation();

//            me.tags['object-choose-child-type-dialog'].show();

            return false;
        };

        me.on('mount', function () {
//            console.log('form-field-object mount', $(me.root));
            var root = $(me.root);
            if (me.opts.parent === 'true') {
                $(me.root.querySelector('.ui .accordion')).accordion();
            }

            content = me.root.querySelector('.accordion-content');
            genForm(me.value, me.config.children);
        })

    </script>
</form-field-object>

<array-add-child-dialog class="ui modal">

</array-add-child-dialog>

<form-field-array class="ui styled fluid accordion field" style="margin-top: 5px; margin-bottom: 5px;">
    <array-add-child-dialog></array-add-child-dialog>
    <div class="title">
        <i class="dropdown icon"></i>
        {config.displayName}
        &nbsp;
        <button name="addBtn" class="ui mini basic icon button" onclick="{addChild}" data-content="Define model before add child">
            <i class="blue add icon"></i>
        </button>
    </div>
    <div class="content">
    </div>
    <script>
        var me = this;
        me.mixin('form');
        me.config = opts.config || {};
        me.value = opts.value || '';

        me.on('mount', function () {
            if (!me.config.model) {
                $(me.addBtn).popup({
                    on: 'click'
                });
            }
        });

        me.addChild = function () {
            if (me.config.model) {
                return;
            }
        };

        me.getValue = function () {
//            return JSON.parse(editor.getValue());
            return '';
        };

        me.setValue = function (value) {
//            editor.setValue(value);
            me.update();
        };
    </script>
</form-field-array>

<form-field-media class="field">
    <label for="form-{config.name}" class="" style="text-align: left;">{config.displayName}
    </label>
    <input type="text" class="form-control" id="form-{config.name}" readonly="{config.viewOnly}">
    <label class="input-group-btn">
        <span class="ui button default" onclick="{showChooseFile}" disabled="{config.viewOnly}">Browse local</span>
    </label>
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
            riot.event.trigger('chooseMediaFile', function (relativePath) {
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

<form-editor id="{opts.id}" class="ui form" style="" onkeypress="{checkSave}">

    <script>
        var me = this;
        me.form = null;
        me.formfields = [];
        me.siteName = me.opts.siteName;
        me.codeEditorMap = {};

        me.on('mount', function () {
//            me.form = me.root.querySelector('form');
            me.form = me.root;
        });

        me.checkSave = function (e) {
            if (!(e.which == 115 && e.ctrlKey) && !(e.which == 19)) return true;
            console.log('Ctrl-S pressed');
            riot.event.trigger('codeEditor.save');
            e.preventDefault();
            return false;
        };

        me.getForm = function () {
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
            console.log('genForm', metaData, contentConfig);
            // unmount any exists form field
            me.formfields.forEach(function (field) {
                if (field != undefined)
                    field.unmount();
            });

            me.formfields = [];

            me.form.innerHTML = '';
            me.codeEditorMap = {};
            if (contentConfig == undefined) {
                console.log('BUG', contentConfig);
            }
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

                if (tagTypeName === 'form-field-object')
                    div.setAttribute('parent', 'true');

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
