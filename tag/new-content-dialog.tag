<new-content-dialog class="modal fade" tabindex="-1" role="dialog" data-backdrop="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h2 class="modal-title">Create new page</h2>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label for="contentLayoutElm" class="col-sm-2 control-label">Layout</label>
                        <div class="col-sm-10">
                            <select id="contentLayoutElm" class="selectpicker" onchange="{edit.bind(this,'contentLayout')}">
                                <option value=""></option>
                                <option each="{value in layoutList}" value="{value}">{hideExt(value)}</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-sm-offset-2 col-sm-10">
                            <label for="isFrontPageElm">
                                <input type="checkbox" id="isFrontPageElm" onchange="{updateFileName}"> To create a single Page, check here
                            </label>
                            <label class="text-info">Hãy check nếu đây là trang duy nhất như Home, Contact, AboutUs,... </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="contentTitleElm" class="col-sm-2 control-label">Page Title</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="contentTitleElm" placeholder="Title" oninput="{updateFileName}" style="width: 498px;">
                        </div>
                    </div>
                    <!--<div class="form-group">-->
                    <!--<label for="contentTitleElm" class="col-sm-2 control-label">Category</label>-->
                    <!--<div class="col-sm-10">-->
                    <!--<input type="text" class="form-control" placeholder="Category" style="width: 498px;" onchange="{edit.bind(this,'contentCategory')}">-->
                    <!--</div>-->
                    <!--</div>-->

                    <div class="form-group">
                        <label for="categoryListElm" class="col-sm-2 control-label">Category</label>
                        <div class="col-sm-10">
                            <select id="categoryListElm" class="selectpicker" onchange="{edit.bind(this,'contentCategory')}">
                                <option value=""></option>
                                <option each="{category in categoryList}" value="{category.value}">{category.name}</option>
                            </select>
                        </div>
                    </div>

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
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" disabled="{canAdd()}" onclick="{add}">Add</button>
            </div>
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
        me.contentTag = '';

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

        me.editTag = function(e) {
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
            riot.api.trigger('addContent', me.contentLayout, me.contentTitle, me.contentFileName + '.md', me.contentCategory, me.contentTag, me.isFrontPageElm.checked);
        };


        riot.api.on('unmount', function () {
            riot.api.off('closeNewContentDialog');
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
            title = title.normalize('NFKD').replace(combining, '').replace(/\s/g, '-').toLowerCase().trim();
            if (me.isFrontPageElm.checked) {
                me.contentFileName = title;
            } else {
                var contentLayoutBase = me.contentLayout.split('.');
                contentLayoutBase.pop();
                me.contentFileName = contentLayoutBase.join('') + '/' + title;
            }

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
            riot.api.one('closeNewContentDialog', function () {
                $(me.root).modal('hide');
            });
        }
    </script>
</new-content-dialog>
