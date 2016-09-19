<dialog-new-site-import class="ui modal" tabindex="-1" role="dialog" data-backdrop="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">Import site</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group is-empty">
                        <label for="form-repo-url" class="control-label col-sm-4">Folder name</label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" name="siteName" placeholder="" value={siteName} oninput="{edit.bind(this,'siteName')}">
                            <span class="material-input"></span>
                        </div>
                    </div>
                    <div class="form-group is-empty">
                        <label for="form-repo-url" class="control-label col-sm-4">Repository url (HTTPS)</label>
                        <div class="col-sm-8">
                            <input type="url" class="form-control" id="form-repo-url" placeholder="ends with .git" oninput="{edit.bind(this,'repoUrl')}" value="{repoUrl}">
                            <span class="material-input"></span>
                        </div>
                    </div>
                    <div class="form-group is-empty">
                        <label for="form-username" class="control-label col-sm-4">Username</label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" id="form-username" placeholder="" oninput="{edit.bind(this,'username')}" value="{username}">
                        </div>
                    </div>
                    <div class="form-group is-empty">
                        <label for="form-password" class="control-label col-sm-4">Password</label>
                        <div class="col-sm-8">
                            <input type="password" class="form-control" id="form-password" placeholder="" oninput="{edit.bind(this,'password')}" value="{password}">
                            <span class="material-input"></span>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary disabled={siteName=='' || repoUrl=='' || username=='' || password=='' || !urlValid}" onclick="{create}">Create</button>
            </div>
        </div>
    </div>

    <script>
        var me = this;

        me.edit = function (name, e) {
            switch (e.target.type) {
                case 'checkbox':
                    me[name] = e.target.checked;
                    break;
                default:
                    me[name] = e.target.value;
            }
            me.urlValid = /https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)/i.test(me.repoUrl);
            me.update();
        };

        me.event = riot.observable();

        me.siteName = '';
        me.repoUrl = '';
        me.username = '';
        me.password = '';
        me.urlValid = false;

        me.show = function () {
            me.repoUrl = '';
            me.username = '';
            me.password = '';

            // debug
//            me.siteName = 'bb';
//            me.repoUrl = 'https://github.com/nemesisqp/test-gh.git';
//            me.username = 'nemesisqp';
//            me.password = '8394fca387b64f36ab8c95bfbd99abec90bcc7xx';
//            me.urlValid = true;

            me.update();
            $(me.root).modal('show');
        };

        me.hide = function () {
            $(me.root).modal('hide');
        };

        me.create = function () {
            me.event.trigger('create', {
                siteName: me.siteName,
                url:      me.repoUrl,
                username: me.username,
                password: me.password
            });
        }
    </script>
</dialog-new-site-import>
