<new-content-dialog class="modal fade" tabindex="-1" role="dialog" data-backdrop="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h2 class="modal-title">Create New Content Using Defined Layout</h2>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label for="contentLayoutElm" class="col-sm-2 control-label">Layout</label>
                        <div class="col-sm-10">
                            <select id="contentLayoutElm" class="selectpicker" onchange="{edit.bind(this,'contentLayout')}">
                                <option each="{value in layoutList}" value="{value}">{value}</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-sm-offset-2 col-sm-10">
                            <label for="isFrontPageElm">
                                <input type="checkbox" id="isFrontPageElm" onchange="{updateFileName}" checked> At root (/) folder, used for a Single Page
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="contentTitleElm" class="col-sm-2 control-label">Title</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="contentTitleElm" placeholder="Title" oninput="{updateFileName}" style="width: 498px;" value="{contentTitle}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="contentFilenameElm" class="col-sm-2 control-label">FileName</label>
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
                <button type="button" class="btn btn-primary {(contentLayout=='' || contentTitle=='' || contentTitle=='.md') ? 'disabled' : ''}" onclick="{add}">Add</button>
            </div>
        </div>
    </div>
    <script>
        var me = this;
        me.layoutList = [];
        me.contentLayout = '';
        me.contentTitle = '';
        me.contentFileName = '';

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

        me.add = function () {
            console.log(me.isFrontPageElm.checked);
            riot.api.trigger('addContent', me.contentLayout, me.contentTitle, me.contentFileName + '.md', me.isFrontPageElm.checked);
        };

        riot.api.on('closeNewContentDialog', function () {
            console.log('closeNewContentDialog');
            $(me.root).modal('hide');
        });

        me.updateLayoutList = function (layoutList) {
            me.layoutList = layoutList;
            if (me.layoutList.length > 0)
                me.contentLayout = me.layoutList[0];
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
            me.contentFileName = '';
            me.update();

            $(me.root).modal('show');
            $(me.root).find('.selectpicker').selectpicker();
        }
    </script>
</new-content-dialog>
