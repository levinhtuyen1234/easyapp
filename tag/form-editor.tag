<form-field-category-text class="inline fields">
    <label for="form-{config.name}-{config.displayType}" class="two wide field truncate" title="{config.displayName}">{config.displayName}</label>

    <div class="ui fourteen wide field" style="padding: 0">
        <div class="ui fluid selection dropdown" style="width: 100%">
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
        var dropdown = null;

        me.on('mount', function () {
            me.categoryList = BackEnd.getCategoryList(me.opts.siteName);
            me.categoryList.forEach(function (category) {
                category.name = category.name.split('.').join(' / ');
            });
            me.update();
//            var dropdown = $(me.root.querySelector('select'));
//            dropdown.selectpicker('refresh');
//            dropdown.selectpicker('val', me.value);

            dropdown = $(me.root.querySelector('.ui.dropdown')).dropdown({
                onChange: function (value, text) {
                    me.value = dropdown.dropdown('get value');
                }
            });
            dropdown.dropdown('set selected', me.value);
        });

        me.getValue = function () {
            return me.value;
        };

        me.setValue = function (value) {
            me.value = value;
            dropdown.dropdown('set selected', me.value);
            me.update();
        };
    </script>
</form-field-category-text>

<form-field-tag-text class="inline fields">
    <label for="form-{config.name}-{config.displayType}" class="two wide field truncate" title="{config.displayName}">{config.displayName}</label>
    <div class="ui fourteen wide field" style="padding: 0">
        <div class="ui fluid selection multiple dropdown" style="width: 100%">
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
        var dropdown = null;

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
            dropdown = $(me.root).find('.ui .dropdown').dropdown({
                onChange: function (value, text) {
                    me.value = dropdown.dropdown('get value');
                }
            });

            dropdown.dropdown('set selected', me.value);
        });

        me.getValue = function () {
            return me.value;
        };

        me.setValue = function (value) {
            me.value = value;
            dropdown.dropdown('set selected', me.value);
            me.update();
        };
    </script>
</form-field-tag-text>

<form-field-text class="inline fields">
    <style>
        .fieldMarkDown {
            resize: vertical;
            min-height: 100px !important;
        }
    </style>
    <label for="form-{config.name}-{config.displayType}" name="label" class="two wide field truncate" data-tooltip="{config.displayName}" style="text-align: left;">{config.displayName}</label>
    <div class="ui fourteen wide field" style="padding: 0">
        <input if="{config.displayType === 'ShortText'}" class="" type="text" id="form-{config.name}-ShortText" onkeyup="{edit.bind(this, 'value')}" readonly="{config.viewOnly}">
        <textarea if="{config.displayType === 'LongText'}" style="height: 150px; min-height: 150px;" rows="5" id="form-{config.name}-LongText" value="{value}" onkeyup="{edit.bind(this, 'value')}" readonly="{config.viewOnly}"></textarea>

        <markdown-editor if="{config.displayType === 'MarkDown'}" status="false" height="300px" style="width:100%" viewOnly="{config.viewOnly}"></markdown-editor>

        <div class="ui fluid selection dropdown" if="{config.displayType === 'DropDown'}" style="width: 100%">
            <input name="" type="hidden">
            <i class="dropdown icon"></i>
            <div class="default text">Choose {config.displayName}</div>
            <div class="menu">
                <div class="item" each="{data in config.predefinedData}" data-value="{data.value}">{data.name}</div>
            </div>
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


        me.on('mount', function () {
            setTimeout(function () {
                me.setValue(me.value);
                me['form-' + me.config.name + '-ShortText'].value = me.value;
                // neu displayType dropdown tu` value -> name selected
                if (me.config.displayType === 'DropDown' && me.config.predefinedData) {
                    var dropdown = $(me.root).find('.ui.dropdown').dropdown({
                        onChange: function (value, text) {
                            me.value = value;
                            me.selectedName = text;
                        }
                    });
                    if (me.value)
                        dropdown.dropdown('set selected', me.value);

//                    me.config.predefinedData.forEach(function (data) {
//                        if (data.value == me.value) {
//                            me.selectedName = data.name;
//                            me.update();
//                        }
//                    });
                }

                if (me.config.displayType === 'MarkDown') {
                    $(me.root.querySelectorAll('.CodeMirror-scroll, .CodeMirror-wrap')).addClass('fieldMarkDown');
                    $(me.root.querySelectorAll('.CodeMirror')).resizable({
                        handles: 's'
                    });
//                    $(me.label).removeClass('col-sm-3');
//                    $(me.content).removeClass('col-sm-9');
//                    $(me.label).addClass('col-sm-12');
//                    $(me.content).addClass('col-sm-12');
                }
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

<form-field-number class="inline fields">
    <label for="form-{config.name}-{config.displayType}" class="two wide field" style="text-align: left;">{config.displayName}
    </label>
    <div class="fourteen wide field" style="padding: 0">
        <input type="number" if="{config.displayType === 'Number'}" id="form-{config.name}-Number" class="form-control" onkeyup="{edit.bind(this, 'value')}" readonly="{config.viewOnly}">

        <div class="ui fluid selection dropdown" if="{config.displayType === 'DropDown'}" style="width: 100%">
            <input name="" type="hidden">
            <i class="dropdown icon"></i>
            <div class="default text">Choose {config.displayName}</div>
            <div class="menu">
                <div class="item" each="{data in config.predefinedData}" data-value="{data.value}">{data.name}</div>
            </div>
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
                var dropdown = $(me.root).find('.ui.dropdown').dropdown({
                    onChange: function (value, text) {
                        me.value = value;
                        me.selectedName = text;
                    }
                });
                if (me.value)
                    dropdown.dropdown('set selected', me.value);
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

<form-field-boolean class="inline fields">
    <label style="vertical-align: middle; margin-bottom: 12px; padding-top: 12px;" class="two wide field">{config.displayName}</label>
    <div class="ui toggle checkbox">
        <input id="form-{config.name}" class="hidden" tabindex="0" type="checkbox" checked="{value}" onchange="{edit.bind(this, 'value')}" disabled="{config.viewOnly}">
    </div>
    <script>
        var me = this;
        me.mixin('form');
        me.config = opts.config || {};
        me.value = opts.value || false;

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

<form-field-datetime>
    <div class="inline fields">
        <label for="form-{config.name}" class="two wide field">{config.displayName}</label>
        <div class="ui calendar fourteen wide field" ref="validFromCalendar" style="padding:0">
            <div class="ui input left icon">
                <i class="calendar icon"></i>
                <input type="text" placeholder="" onkeyup="{edit.bind(this, 'value')}" readonly="{config.viewOnly}">
            </div>
        </div>
    </div>

    <script>
        var me = this;
        me.mixin('form');
        me.config = opts.config || {};
        me.value = opts.value || '';

        me.on('mount', function () {
            var input = me.root.querySelector('input');
            input.value = me.value;

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

            $(me.root.querySelector('.ui.calendar')).calendar({
                type:     calendarType,
                onChange: function (date, text) {
                    if (text === '') {
                        me.value = '';
                        input.value = '';
                    } else {
                        var time = moment(date);
                        me.value = time.toISOString();
                        input.value = time.format(format);
                    }
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
    <div class="styled fluid accordion" style="margin-top: 5px; margin-bottom: 5px;">
        <div class="title">
            <i class="dropdown icon"></i>
            {config.displayName} &nbsp;
            <!--<div class="ui mini basic icon float button" onclick="{addChild}">-->
            <!--<i class="blue add icon"></i>-->
            <!--</div>-->
            <button if="{opts.arrayObject}" name="removeBtn" class="ui mini red icon button right floated" onclick="{removeChild}">
                <i class="remove icon"></i>
            </button>
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
                console.log('PARENT', me);
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
            content = me.root.querySelector('.accordion-content');
            genForm(me.value, me.config.children);
            if (me.opts.parent === 'true') {
                var accordion = $(me.root.querySelector('.accordion'));
                accordion.addClass('ui');
                accordion.accordion();
            }
            if (me.opts.arrayObject == true) {
//                console.log("$(me.root.find('div.title'))", $(me.root).find('div.title'));
//                $(me.root).find('div.title').hide();
                $(me.root).find('div.title').append('Item: ' + me.opts.index);
            }
        });

        me.getValue = function () {
            var ret = {};
            formFields.forEach(function (field) {
                ret[field.config.name] = (field.getValue());
            });
            return ret;
        };

        me.setValue = function (value) {
//            editor.setValue(value);
//            me.update();
            // not needed
        };
    </script>
</form-field-object>

<array-add-child-dialog class="ui modal">

</array-add-child-dialog>

<form-field-array>
    <div class="styled fluid accordion" style="margin-top: 5px; margin-bottom: 5px;">
        <array-add-child-dialog></array-add-child-dialog>
        <div class="title">
            <i class="dropdown icon"></i>
            {config.displayName}
            &nbsp;
            <button name="addBtn" class="ui mini basic icon button" onclick="{addChild}">
                <i class="blue add icon"></i>
            </button>
        </div>
        <div class="content">
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

            if (metaData == '') metaData = [];
            if (contentConfig == undefined || !contentConfig.length || contentConfig.length == 0) {
                // no array model -> no form render
                return;
            }

            var config = {children: contentConfig};
            var index = 1;
            metaData.forEach(function (data) {

                var div = document.createElement('div');
                var tagTypeName = 'form-field-object';
                div.setAttribute('data-is', tagTypeName);
//                div.setAttribute('parent', 'true');
                div.setAttribute('site-name', me.opts.siteName);
                content.appendChild(div);
                var tag = riot.mount(div, {
                    config:      config,
                    value:       data,
                    arrayObject: true,
                    index:       index
                })[0];
                index += 1;
                formFields.push(tag);
            });
        };

        me.on('mount', function () {
            if (!me.config.model) {
                $(me.addBtn).popup({
                    on: 'click'
                });
            }
            content = me.root.querySelector('.content');
//            console.log('ARRAY MOUNT', me.value, me.config.children);
            genForm(me.value, me.config.children);

            if (me.opts.parent === 'true') {
                var accordion = $(me.root.querySelector('.accordion'));
                accordion.addClass('ui');
                accordion.accordion();

                for (var i = 1; i <= me.value.length; i++) {
                    accordion.accordion('open', i);
                }
            }
        });

        me.addChild = function (e) {
            if (me.config.model) {
                // TODO form add new object
                return;
            }
            e.preventDefault();
            e.stopPropagation();
            console.log();
            return false;
        };

        me.getValue = function () {
            var ret = [];
            formFields.forEach(function (field) {
                ret.push(field.getValue());
            });
            return ret;
        };

        me.setValue = function (value) {
            // not needed
        };
    </script>
</form-field-array>

<form-field-media class="inline fields">
    <label for="form-{config.name}" class="two wide field" style="text-align: left;">{config.displayName}
    </label>
    <div class="fourteen wide field" style="padding: 0">
        <div class="ui action input">
            <input type="text" class="" id="form-{config.name}" readonly="{config.viewOnly}">
            <button class="ui button default" onclick="{showChooseFile}" disabled="{config.viewOnly}">Browse</button>
            </label>
        </div>
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
            riot.event.trigger('chooseMediaFile', function (relativePath) {
//                me.value = relativePath.split(/[\\\/]/).pop();
                me.value = relativePath;
                me['form-' + me.config.name].value = relativePath;
                me.update();

//                console.log('chooseMediaFile cb', 'me.value', me.value, relativePath);
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

<form-editor id="{opts.id}" class="ui form" onkeypress="{checkSave}">
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
            // check ctrl + S -> save
            if (!(e.which == 115 && e.ctrlKey) && !(e.which == 19)) return true;
            console.log('Ctrl-S pressed');
//            console.log('me.getForm', me.getForm());
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
//            console.log('genForm', metaData, contentConfig);
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
            // render all field excet __content__
            for (var i = 0; i < contentConfig.length; i++) {
                var fieldConfig = contentConfig[i];
                if (fieldConfig.name === '__content__') continue;
                var metaValue = metaData[fieldConfig.name];
                var div = document.createElement('div');
                var tagTypeName = 'form-field-' + fieldConfig.type.toLowerCase();
                // special case for category
                if (fieldConfig.name === 'category') {
                    tagTypeName = 'form-field-category-text';
                } else if (fieldConfig.name === 'tag') {
                    tagTypeName = 'form-field-tag-text';
                }

                var mountData = {
                    config: fieldConfig,
                    value:  metaValue
                };

                if (tagTypeName === 'form-field-object' || tagTypeName === 'form-field-array') {
                    div.setAttribute('parent', 'true');
                }

                div.setAttribute('data-is', tagTypeName);
                div.setAttribute('site-name', me.opts.siteName);
                me.form.appendChild(div);

                var tag = riot.mount(div, mountData)[0];
                me.formfields.push(tag);
            }
        }
    </script>
</form-editor>
