<github-init-dialog class="ui modal" tabindex="-1" role="dialog" data-backdrop="true">
    
    <div class="header">Prepare to public website</div>
    <i class="close icon"></i>
    <div class="content">
        <div class="ui form">
            <div class="ui info message">
                <div class="header"><i class="icon help circle"></i>
                    Please make a "Request", we prepare hosting to deploy this website.
                </div>
          
            </div>
            
            <div class="inline fields">
                <label class="two wide field">Domain Name</label>
                <div class="eight wide field">
                        <div class="ui icon right labeled input">
                            <input type="text" placeholder="Website name">
                            <div class="ui label">.easywebhub.com</div>
                        </div>
                    </div>
            </div>
        </div>
        
        
        <!--
        <form class="ui form">
            <div class="inline fields">
                <label class="error message">Sử dụng tạm thời với GitHub repo</label>
            </div>
            <div class="inline fields">
                <label class="two wide field">Repository url (HTTPS)</label>
                <div class="ui icon input fourteen wide field">
                    <input type="url" id="form-repo-url" placeholder="Empty Github repository that ends with .git " oninput="{edit('repoUrl')}" value="{repoUrl}">
                </div>
            </div>
            <div class="inline fields">
                <label class="two wide field">Username</label>
                <div class="ui icon input fourteen wide field">
                    <input type="text" id="form-username" placeholder="" oninput="{edit('username')}" value="{username}">
                </div>
            </div>
            <div class="inline fields">
                <label class="two wide field">Password</label>
                <div class="ui icon input fourteen wide field">
                     <input type="password" class="form-control" id="form-password" placeholder="" oninput="{edit('password')}" value="{password}">
                </div>
            </div>
           <div class="actions">
                <div class="ui button cancel">Cancel</div>
          
                <div class="ui button positive icon"  disabled="{repoUrl=='' || username=='' || password=='' || !urlValid}" onclick="{save}">
                    <i class="save icon"></i>
                    Save
                </div>
            </div>
        </form>
        -->
      </div>
    <div class="actions">
        <div class="ui button cancel">Cancel</div>
        <div class="ui button positive icon" >
            <i class="send icon"></i>
            Request
        </div>
        <label class="success">
            We will setup hosting and domain for your site within 24h. And all is free.
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

        me.repoUrl = '';
        me.username = '';
        me.password = '';
        me.urlValid = false;

        me.show = function () {
            me.repoUrl = '';
            me.username = '';
            me.password = '';
            me.update();
            $(me.root).modal('show');
        };

        me.hide = function () {
            $(me.root).modal('hide');
        };

        me.save = function () {
            me.event.trigger('save', {
                url:      me.repoUrl,
                username: me.username,
                password: me.password
            });
        }

    </script>
</github-init-dialog>
