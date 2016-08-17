<new-tag-dialog class="modal fade" tabindex="-1" role="dialog" data-backdrop="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h2 class="modal-title">Create new Tag</h2>
            </div>
            <div class="modal-body">
                <label class="text-info"></label>
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Name</label>
                        <div class="col-sm-10">
                            <input type="text" name="tagNameElm" class="form-control" placeholder="Name" oninput="{updateTagName}" style="width: 100%">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="tagFilenameElm" class="col-sm-2 control-label">File Name</label>
                        <div class="col-sm-10">
                            <div class="input-group">
                                <input type="text" class="form-control" id="tagFilenameElm" placeholder="FileName" readonly="{ User.accountType !== 'dev'}" >
                                <span class="input-group-addon">.json</span>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" disabled="{tagName==''}" onclick="{add}">Add</button>
            </div>
        </div>
    </div>
    <script>
        var me = this;
        var combining = /[\u0300-\u036F]/g;
        me.tagName = '';

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
            riot.api.trigger('addTag', me.tagName, me.tagFilenameElm.value + '.json');
        };

        me.updateTagName = function (e) {
            me.tagName = e.target.value.trim();
            me.tagFilenameElm.value = me.tagName.normalize('NFKD')
                    .replace(combining, '')
                    .replace(/\s/g, '-')
                    .toLowerCase()
                    .replace(/[^0-9a-z_-]/g, '');
            me.update();
        };

        me.show = function () {
            me.tagName = '';
            me.tagNameElm.value = '';
            me.tagFilenameElm.value = '';

            $(me.root).modal('show');
            $(me.root).find('.selectpicker').selectpicker();
            setTimeout(function () {
                $(me.tagNameElm).focus();
            }, 500);

            riot.api.one('closeNewTagDialog', function () {
                $(me.root).modal('hide');
            });
        }
    </script>
</new-tag-dialog>
