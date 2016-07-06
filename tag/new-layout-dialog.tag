<new-layout-dialog class="modal fade" tabindex="-1" role="dialog" data-backdrop="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">Create New Layout</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label for="layout-filename" class="col-sm-2 control-label">FileName</label>
                        <div class="col-sm-10">
                            <div class="input-group">
                                <input type="text" class="form-control" id="layout-filename" placeholder="FileName" oninput="{updateFileName}" value="{layoutFileName}">
                                <span class="input-group-addon">.html</span>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" disabled="{layoutFileName==''}" onclick="{add}">Add</button>
            </div>
        </div>
    </div>
    <script>
        var me = this;
        me.layoutFileName = '';

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
            riot.api.trigger('addLayout', me.layoutFileName + '.html');
        };

        me.updateFileName = function (e) {
            var title = e.target.value;
            var combining = /[\u0300-\u036F]/g;
            title = title.normalize('NFKD').replace(combining, '').replace(/\s/g, '-').trim();
            me.layoutFileName = title;
            me.update();
        };

        riot.api.on('closeNewLayoutDialog', function() {
            console.log('closeNewLayoutDialog');
            $(me.root).modal('hide');
        });

        me.show = function () {
            me.layoutFileName = '';
            me.update();
            $(me.root).modal('show');
            $(me.root).find('.selectpicker').selectpicker();
        }
    </script>
</new-layout-dialog>
