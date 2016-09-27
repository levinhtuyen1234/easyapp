<dialog-new-site-import class="ui modal" tabindex="-1">
    <i class="close icon"></i>
    <div class="header">Import site</div>
    <div class="content">
        <div class="ui form">
            <div class="field">
                <label for="siteNameField" class="">Folder name</label>
                <input type="text" class="form-control" id="siteNameField" placeholder="" oninput="{edit('siteName')}">
            </div>siteNameField
            <div class="field">
                <label for="repoUrlField" class="">Repository url (HTTPS)</label>
                <input type="url" class="form-control" id="repoUrlField" placeholder="ends with .git" oninput="{edit('repoUrl')}">
            </div>
            <div class="field">
                <label for="usernameField" class="">Username</label>
                <input type="text" class="form-control" id="usernameField" placeholder="" oninput="{edit('username')}">
            </div>
            <div class="field">
                <label for="passwordField" class="">Password</label>
                <input type="password" class="form-control" id="passwordField" placeholder="" oninput="{edit('password')}">
            </div>
        </div>
    </div>
    <div class="actions">
        <div class="ui deny button">Cancel</div>
        <div class="ui positive right labeled icon button" disabled="{siteName=='' || repoUrl=='' || username=='' || password=='' || !urlValid}"  onclick="{create}">Import
            <i class="add icon"></i>
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
            me.siteName = '';
            me.repoUrl = '';
            me.username = '';
            me.password = '';

            me.siteNameField.value = me.siteName;
            me.repoUrlField.value = me.repoUrl;
            me.usernameField.value = me.username;
            me.passwordField.value = me.password;

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
