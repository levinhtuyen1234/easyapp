<new-layout-dialog class="modal fade" tabindex="-1" role="dialog" data-backdrop="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">Create New Layout</h4>
            </div>
            <div class="modal-body">
                <label class="text-info">Tạo layout bằng HTML, CSS và HandleBarJS để sử dụng chung cho một hoặc nhiều trang</label>
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">FileName</label>
                        <div class="col-sm-10">
                            <div class="input-group">
                                <input type="text" class="form-control" name="layoutNameElm" placeholder="FileName" oninput="{updateFileName}">
                                <span class="input-group-addon">{postFix}</span>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">Category</label>
                        <div class="col-sm-10">
                            <div class="checkbox">
                                <label>
                                    <!--<input type="checkbox" name="input-{name}" checked="{value}">-->
                                    <input type="checkbox" name="isCategory" onchange="{updatePostFix}">
                                </label>
                            </div>
                            <!--<div class="input-group">-->
                            </div>
                        <!--</div>-->
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" disabled="{layoutName==''}" onclick="{add}">Add</button>
            </div>
        </div>
    </div>
    <script>
        var me = this;
        me.layoutName = '';
        me.postFix = '.html';
        me.isCategory = false;

        me.edit = function (name, e) {
            switch (e.target.type) {
                case 'checkbox':
                    me[name] = e.target.checked;
                    break;
                default:
                    me[name] = e.target.value;
            }
        };

        me.add = function () {
            riot.api.trigger('addLayout', me.layoutName + me.postFix);
        };

        me.updatePostFix = function(e) {
            me.postFix = e.srcElement.checked ? '.category.html' : '.html';
            me.update();
        };

        me.updateFileName = function (e) {
            var title = e.target.value;

            var combining = /[\u0300-\u036F]/g;
            title = title.normalize('NFKD').replace(combining, '').replace(/\s/g, '-').trim();
            me.layoutName = title;
//
            me.update();
        };


        me.show = function () {
            me.layoutName = '';
            me.layoutNameElm.value = '';
            $(me.root).modal('show');
            $(me.root).find('.selectpicker').selectpicker();
            var fieldFileName = $(me['layout-filename']);
            fieldFileName.val('');
            setTimeout(function () {
                fieldFileName.focus();
            }, 500);

            riot.api.one('closeNewLayoutDialog', function () {
                console.log('closeNewLayoutDialog');
                $(me.root).modal('hide');
            });
        }
    </script>
</new-layout-dialog>
