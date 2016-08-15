<new-layout-dialog class="modal fade" tabindex="-1" role="dialog" data-backdrop="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h2 class="modal-title">Create new Layout</h2>
            </div>
            <div class="modal-body">
                <h4 class="text-success">(?) apply for one or multiple webpage, using HTML, CSS and <a href="http://handlebarsjs.com">HandlebarJS</a> code</h4>
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
                        <div class="col-sm-offset-1 col-sm-10">
                                <input id="new-layout-is-partial" type="checkbox" name="isCategory" onchange="{updatePostFix}" value="partial">
                                <label for="new-layout-is-partial" class="text-center">Is a Partial layout  (click <a href="http://handlebarsjs.com/partials.html" target="_blank">here</a> for a clear explanation)</label>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-sm-offset-1 col-sm-5">
                              <input id="new-layout-is-category" type="checkbox" name="isCategory" onchange="{updatePostFix}" value="category">
                              <label for="new-layout-is-category" class="control-label text-center">Is the layout of a Category</label>
                        </div>
                        <div class="col-sm-4">
                              <input id="new-layout-is-tag" type="checkbox" name="isCategory" onchange="{updatePostFix}" value="tag">
                              <label for="new-layout-is-tag" class="control-label text-center">Is the layout of a Tag</label>
                        </div>
                        <div class="col-sm-offset-1 col-sm-10">(click <a href="http://blog.easywebhub.com/syntax-of-easywebhub/" target="_blank">here</a> for a clear explanation)</div>
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
            if (e.srcElement.checked) {
                $(me.root.querySelectorAll('input[type="checkbox"]')).attr('checked', false);
                e.srcElement.checked = true;
                me.postFix = '.' + e.srcElement.value + '.html';
            } else {
                me.postFix = '.html';
            }

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
