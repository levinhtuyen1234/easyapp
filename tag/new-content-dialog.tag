<new-content-dialog class="ui modal" tabindex="-1">
    <i class="close icon"></i>
    <div class="header">Create new page</div>
    <div class="content">
        <form class="ui form">
            <div class="inline fields">
                <label class="two wide field">Page Title</label>
                <div class="ui icon input fourteen wide field">
                    <input type="text" id="contentTitleElm" placeholder="Title" oninput="{updateFileName}">
                </div>
            </div>
            <div class="inline fields">
                <label class="two wide field">Layout</label>
                <div class="ui fourteen wide field">
                    <div class="ui selection dropdown" id="layoutDropDown" style="width: 100%">
                        <input name="gender" type="hidden">
                        <i class="dropdown icon"></i>
                        <div class="default text">Choose Layout</div>
                        <div class="menu">
                            <div class="item" each="{value in layoutList}" data-value="{value}">{hideExt(value)}</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="inline fields">
                <label class="two wide field">Category</label>
                <div class="ui fourteen wide field">
                    <div class="ui fluid selection dropdown" id="categoryDropDown" style="width: 100%">
                        <input name="gender" type="hidden">
                        <i class="dropdown icon"></i>
                        <div class="default text">Choose Category</div>
                        <div class="menu">
                            <div class="item" each="{category in categoryList}" data-value="{category.value}">{category.name}</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="inline fields">
                <label class="two wide field">Tags</label>
                <div class="ui fourteen wide field">
                    <div class="ui fluid dropdown multiple selection" id="tagDropDown" style="width: 100%">
                        <input name="gender" type="hidden">
                        <i class="dropdown icon"></i>
                        <div class="default text">Choose Tag</div>
                        <div class="menu">
                            <div class="item" each="{tag in tagList}" data-value="{tag.value}">{tag.name}</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="inline fields">
                <label class="two wide field">Filename</label>
                <div class="fourteen wide field">
                    <div class="ui fluid right labeled icon input">
                        <input type="text" id="contentFilenameElm" placeholder="Title" oninput="{updateFileName}" readonly value="{contentFileName}">
                        <div class="ui label">.md</div>
                    </div>
                </div>
            </div>
        </form>
    </div>
    <div class="actions">
        <div class="ui button cancel">Cancel</div>
        <div class="ui button positive icon" disabled="{canAdd()}" onclick="{add}">
            <i class="add icon"></i>
            Add
        </div>
    </div>
    <script>
        var me = this;
        me.layoutList = [];
        me.categoryList = [];
        me.tagList = [];
        me.contentLayout = '';
        me.contentTitle = '';
        me.contentFileName = '';
        me.contentCategory = '';
        me.contentTag = '[]';

        me.canAdd = function () {
            return me.contentLayout == '' || me.contentTitle == '' || me.contentTitle == '.md';
        };

        me.edit = function (name, e) {
            switch (e.target.type) {
                case 'checkbox':
                    me[name] = e.target.checked;
                    break;
                default:
                    me[name] = e.target.value;
            }
            me.updateFileName();
        };

        me.editTag = function (e) {
            var selectedTags = $(e.srcElement).val();
            if (selectedTags == null)
                me.contentTag = '[]';
            else
                me.contentTag = JSON.stringify(selectedTags);
        };

        me.hideExt = function (name) {
            var parts = name.split('.');
            if (parts.length > 1)
                parts.pop();
            return parts[0]
        };

        me.add = function () {
//            console.log(me.contentTag);
//            riot.event.trigger('addContent', me.contentLayout, me.contentTitle, me.contentFileName + '.md', me.contentCategory, me.contentTag, me.isFrontPageElm.checked);
            riot.event.trigger('addContent', me.contentLayout, me.contentTitle, me.contentFileName + '.md', me.contentCategory, me.contentTag, true);
//            console.log('me.add', 'addContent', me.contentLayout, me.contentTitle, me.contentFileName + '.md', me.contentCategory, me.contentTag, true);
        };

        me.on('unmount', function () {
            riot.event.off('closeNewContentDialog');
        });

        me.on('mount', function () {
            riot.event.on('closeNewContentDialog', function () {
                $(me.root).modal('hide');
            });
        });

        me.updateLayoutList = function (layoutList) {
            var list = [];
            layoutList.forEach(function (layout) {
                list.push(layout.name);
            });
            me.layoutList = list;
//            if (me.layoutList.length > 0)
//                me.contentLayout = me.layoutList[0];
            me.update();
        };

        me.updateFileName = function (e) {
            var title = me.contentTitleElm.value;
            me.contentTitle = title;
            var combining = /[\u0300-\u036F]/g;
            title = title
                    .toLowerCase()
                    .normalize('NFKD')
                    .replace(combining, '')
                    .replace(/đ/g, 'd')
                    .replace(/[?,!\/"*:;#$@\\()\[\]{}^~]*/g, '')
                    .replace(/[.’']/g, ' ')
                    .replace(/\s+/g, '-')
                    .trim();
//            if (me.isFrontPageElm.checked) {
            me.contentFileName = title;
//            } else {
//                var contentLayoutBase = me.contentLayout.split('.');
//                contentLayoutBase.pop();
//                me.contentFileName = contentLayoutBase.join('') + '/' + title;
//            }

            me.update();
        };

        me.show = function () {
            // reset content
            me.contentTitle = '';
            me.contentTitleElm.value = '';
            me.contentFileName = '';

            me.categoryList = BackEnd.getCategoryList(me.opts.siteName);
            me.categoryList.forEach(function (category) {
                category.name = category.name.split('.').join(' / ');
            });

            me.tagList = BackEnd.getTagList(me.opts.siteName);
            me.tagList.forEach(function (tag) {
                tag.name = tag.name.split('.').join(' / ');
            });

            var categoryDropDown = $(me.categoryDropDown).dropdown({
                onChange: function (value, text) {
                    me.contentCategory = categoryDropDown.dropdown('get value');
                }
            });

            var layoutDropDown = $(me.layoutDropDown).dropdown({
                onChange: function (value, text) {
                    me.contentLayout = layoutDropDown.dropdown('get value');
                }
            });

            var tagDropDown = $(me.tagDropDown).dropdown({
                onChange: function (value, text) {
                    me.contentTag = tagDropDown.dropdown('get value');
                }
            });

            categoryDropDown.dropdown('clear');
            layoutDropDown.dropdown('clear');
            tagDropDown.dropdown('clear');

            $(me.root).modal('show');
//            $(me.contentLayoutElm).selectpicker('refresh');
//            $(me.categoryListElm).selectpicker('refresh');
//            $(me.tagListElm).selectpicker('refresh');

            me.update();
        }
    </script>
</new-content-dialog>
