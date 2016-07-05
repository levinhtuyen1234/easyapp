<dialog-new-site-local class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close" show="{!cloning}">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title">Create new site</h4>
            </div>
            <div class="modal-body">
                <form>
                    <div class="form-group">
                        <label>Tên Thư mục</label>
                        <input type="text" class="form-control" name="siteName" placeholder="" value={siteName} oninput="{siteNameChange}" disabled="{cloning}">
                    </div>
                    <!--<div class="input-group">-->
                    <!--<span class="input-group-btn">-->
                    <!--<button class="btn btn-default" onclick="{showSelectDirDialog}">Browse</button>-->
                    <!--</span>-->
                    <!--<input type="text" class="form-control" name="sitePath" placeholder="Path" value={sitePath} disabled="disabled">-->
                    <!--</div>-->
                </form>
                <div style="text-align: center" show="{cloning}">
                    <i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i>
                    <span class="sr-only">Loading...</span>
                </div>
                <div class="alert alert-danger" role="alert" show="{errMsg != ''}">{errMsg}</div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal" disabled="{cloning}">Close</button>
                <button type="button" class="btn btn-primary" disabled="{(siteName==='' || cloning) ? 'disabled' : false}" onclick="{createSite.bind(this, siteName)}">Create</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->

    <script>
        var me = this;
        var root = me.root;
        var dialog = require('electron').remote.dialog;

        me.siteName = '';
        me.errMsg = '';
        me.cloning = false;

        me.show = function () {
            me.errMsg = '';
            $(root).modal({
                backdrop: false,
                keyboard: false
            });
        };

        me.siteNameChange = function (e) {
            me.siteName = e.target.value;
        };

        me.createSite = function (siteName) {
            // TODO show loading animation
            me.cloning = 1;
            me.errMsg = '';
            me.update();
            me.parent.createSite(siteName).then(function (ret) {
                // TODO stop loading animation
                me.cloning = 0;
                me.update();
                $(root).modal('hide'); // close modal
                parent.openSite(siteName);
            }).catch(function (err) {
                // stop loading animation
                me.cloning = 0;
                me.errMsg = err.message;
                me.update();
            });
        };

        me.showSelectDirDialog = function () {
            me.sitePath = dialog.showOpenDialog({
                title:      "Choose new site directory",
                properties: ['openDirectory']
            });
        }
    </script>
</dialog-new-site-local>
