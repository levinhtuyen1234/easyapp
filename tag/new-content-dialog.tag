<new-content-dialog class="ui modal" tabindex="-1" role="dialog" data-backdrop="true">
    <i class="close icon"></i>
    <div class="header">Create new page</div>
    <div class="content">
        <form class="ui form">
            <div class="one field">
                <div class="field">
                    <label>Page Title</label>
                    <input type="text" class="form-control" id="contentTitleElm" placeholder="Title" oninput="{updateFileName}" style="width: 498px;">
                </div>
            </div>
            <div class="field">
                <label>Layout</label>
                <div class="ui menu">
                    <div class="ui fluid selection dropdown">
                        <input name="gender" type="hidden">
                        <i class="dropdown icon"></i>
                        <div class="default text">Choose Layout</div>
                        <div class="menu">
                            <div class="item" each="{value in layoutList}" data-value="{value}">{hideExt(value)}</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="two fields">
                <div class="field">
                    <label>Category</label>
                    <div class="ui menu">
                        <div class="ui fluid selection dropdown">
                            <input name="gender" type="hidden">
                            <i class="dropdown icon"></i>
                            <div class="default text">Choose Category</div>
                            <div class="menu">
                                <div class="item" each="{category in categoryList}" data-value="{category.value}">{category.name}</div>
                            </div>
                        </div>
                    </div>

                    <!--<div class="col-sm-10">-->
                    <!--<select id="categoryListElm" class="selectpicker" onchange="{edit.bind(this,'contentCategory')}">-->
                    <!--<option value=""></option>-->
                    <!--<option each="{category in categoryList}" value="{category.value}">{category.name}</option>-->
                    <!--</select>-->
                    <!--</div>-->
                </div>

                <div class="field">
                    <label>Tag</label>
                    <div class="ui menu">
                        <div class="ui fluid dropdown multiple search selection">
                            <input name="gender" type="hidden">
                            <i class="dropdown icon"></i>
                            <div class="default text">Choose Tag</div>
                            <div class="menu">
                                <div class="item" each="{tag in tagList}" data-value="{tag.value}">{tag.name}</div>
                            </div>
                        </div>
                    </div>

                    <!--<div class="col-sm-10">-->
                    <!--<select id="categoryListElm" class="selectpicker" onchange="{edit.bind(this,'contentCategory')}">-->
                    <!--<option value=""></option>-->
                    <!--<option each="{category in categoryList}" value="{category.value}">{category.name}</option>-->
                    <!--</select>-->
                    <!--</div>-->
                </div>
            </div>


            <!--<div class="form-group">-->
            <!--<label for="contentLayoutElm" class="col-sm-2 control-label">Layout</label>-->
            <!--<div class="col-sm-10">-->
            <!--<select id="contentLayoutElm" class="selectpicker" onchange="{edit.bind(this,'contentLayout')}">-->
            <!--<option value=""></option>-->
            <!--<option each="{value in layoutList}" value="{value}">{hideExt(value)}</option>-->
            <!--</select>-->
            <!--</div>-->
            <!--</div>-->
            <!--<div class="form-group">-->
            <!--<div class="col-sm-offset-2 col-sm-10">-->
            <!--<label for="isFrontPageElm">-->
            <!--<input type="checkbox" id="isFrontPageElm" onchange="{updateFileName}"> To create a single Page, check here-->
            <!--</label>-->
            <!--<label class="text-info">Hãy check nếu đây là trang duy nhất như Home, Contact, AboutUs,... </label>-->
            <!--</div>-->
            <!--</div>-->

            <!--<div class="form-group">-->
            <!--<label for="contentTitleElm" class="col-sm-2 control-label">Category</label>-->
            <!--<div class="col-sm-10">-->
            <!--<input type="text" class="form-control" placeholder="Category" style="width: 498px;" onchange="{edit.bind(this,'contentCategory')}">-->
            <!--</div>-->
            <!--</div>-->


            <div class="form-group">
                <label for="tagListElm" class="col-sm-2 control-label">Tag</label>
                <div class="col-sm-10">
                    <select id="tagListElm" class="selectpicker" onchange="{editTag}" multiple>
                        <option each="{tag in tagList}" value="{tag.value}">{tag.name}</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label for="contentFilenameElm" class="col-sm-2 control-label">File Name</label>
                <div class="col-sm-10">
                    <div class="input-group">
                        <input type="text" class="form-control" id="contentFilenameElm" placeholder="FileName" disabled value="{contentFileName}">
                        <span class="input-group-addon">.md</span>
                    </div>
                </div>
            </div>
        </form>
    </div>
    <div class="actions">
        <div class="ui button cancel">Cancel</div>
        <div class="ui button" disabled="{canAdd()}" onclick="{add}">Add</div>
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

        console.log('SITE NAME', me.opts.siteName);

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
        };

        riot.event.on('unmount', function () {
            riot.event.off('closeNewContentDialog');
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
                    .replace(/[?,!\/'":;#$@\\()\[\]{}^~]*/g, '')
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

            me.update();


            $(me.root).modal('show');
            $(me.contentLayoutElm).selectpicker('refresh');
            $(me.categoryListElm).selectpicker('refresh');
            $(me.tagListElm).selectpicker('refresh');
            riot.event.one('closeNewContentDialog', function () {
                $(me.root).modal('hide');
            });
        }
    </script>
</new-content-dialog>
