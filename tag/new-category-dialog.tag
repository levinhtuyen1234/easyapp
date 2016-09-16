<new-category-dialog class="modal fade" tabindex="-1" role="dialog" data-backdrop="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h2 class="modal-title">Create new Category</h2>
            </div>
            <div class="modal-body">

                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Name</label>
                        <div class="col-sm-10">
                            <input type="text" name="categoryNameElm" class="form-control" placeholder="Name" oninput="{updateCategoryName}" style="width: 100%">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="categoryFilenameElm" class="col-sm-2 control-label">File Name</label>
                        <div class="col-sm-10">
                            <div class="input-group">
                                <input type="text" class="form-control" id="categoryFilenameElm" readonly="{ User.accountType !== 'dev'}" placeholder="FileName">
                                <span class="input-group-addon">.json</span>
                            </div>
                        </div>
                    </div>
                    <label class="text-info">(?)NOTE: The "." of filename is used to define the relationship between 2 categories</label>
                    <label class="text-info">E.g <span class="text-danger">category.sub-category.json</span> belongs the <span class="text-danger">category.json</span></label>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" disabled="{categoryName==''}" onclick="{add}">Add</button>
            </div>
        </div>
    </div>
    <script>
        var me = this;
        var combining = /[\u0300-\u036F]/g;
        me.categoryName = '';

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
            riot.event.trigger('addCategory', me.categoryName, me.categoryFilenameElm.value + '.json');
        };

        me.updateCategoryName = function (e) {
            me.categoryName = e.target.value.trim();
            me.categoryFilenameElm.value = me.categoryName
                    .toLowerCase()
                    .normalize('NFKD')
                    .replace(combining, '')
                    .replace(/đ/g, 'd')
                    .replace(/[?,!\/'":;#$@\\()\[\]{}^~]*/g, '')
                    .replace(/\s+/g, '-')
                    .trim();
            me.update();
        };

        me.show = function () {
            console.log('show category add dialog');
            me.categoryName = '';
            me.categoryNameElm.value = '';
            me.categoryFilenameElm.value = '';
            $(me.root).modal('show');
            $(me.root).find('.selectpicker').selectpicker();
            setTimeout(function () {
                $(me.categoryNameElm).focus();
            }, 500);

            riot.event.one('closeNewCategoryDialog', function () {
                console.log('closeNewLayoutDialog');
                $(me.root).modal('hide');
            });
        }
    </script>
</new-category-dialog>
