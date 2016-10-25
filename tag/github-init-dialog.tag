<github-init-dialog class="ui modal" tabindex="-1" role="dialog" data-backdrop="true">
    <div class="header">Prepare to public website</div>
    <i class="close icon"></i>
    <div class="content">
        <div class="ui form error {loading: status === 'sending'}">
            <div class="ui info message" hide="{status === 'sendRequestSuccess'}">
                <div class="header"><i class="icon help circle"></i>
                    Please make a "Request", we prepare hosting to deploy this website.
                </div>
            </div>

            <div class="ui positive message" show="{status === 'sendRequestSuccess'}">
                <div class="header"><i class="icon check circle"></i>
                    We will setup hosting and domain for your site within 24h. And all is free.
                </div>
            </div>

            <div class="inline fields" hide="{status === 'sendRequestSuccess'}">
                <label class="two wide field">Domain Name</label>
                <div class="ui fourteen wide field">
                    <div class="ui icon right labeled input">
                        <input name="webSiteName" type="text" placeholder="Website name" onkeyup="{canSend}">
                        <div class="ui label">.easywebhub.com</div>
                    </div>
                </div>
            </div>

            <div class="ui error message" show="{errMsg !== ''}">
                <div class="header">Send Request Failed</div>
                <p>{errMsg}</p>
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
                    <input type="url" id="form-repo-url" placeholder="Empty Github repository that ends with .git " oninput="{edit.bind(this, 'repoUrl')}" value="{repoUrl}">
                </div>
            </div>
            <div class="inline fields">
                <label class="two wide field">Username</label>
                <div class="ui icon input fourteen wide field">
                    <input type="text" id="form-username" placeholder="" oninput="{edit.bind(this, 'username')}" value="{username}">
                </div>
            </div>
            <div class="inline fields">
                <label class="two wide field">Password</label>
                <div class="ui icon input fourteen wide field">
                     <input type="password" class="form-control" id="form-password" placeholder="" oninput="{edit.bind(this, 'password')}" value="{password}">
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
        <div class="ui button cancel {disabled : status === 'sending'}" hide="{status === 'sendRequestSuccess'}">Cancel</div>
        <div class="ui button blue icon {disabled : !canSend()}" onclick="{sendMail}" hide="{status === 'sendRequestSuccess'}">
            <i class="send icon"></i>
            Request
        </div>
        <div class="ui button positive cancel" show="{status === 'sendRequestSuccess'}">Close</div>
    </div>

    <script>
        var nodemailer = require('nodemailer');
        var transporter = nodemailer.createTransport({
            host: 'smtp.sparkpostmail.com',
            port: 587,
            auth: {
                user: 'SMTP_Injection',
                pass: '5febf8263b78856c913ac65347df0af22a8c05ad',
            }
        });
        var sendRequestEmail = transporter.templateSender({
            subject: 'Set domain request {{domain}}',
            text:    'Username: {{username}}\r\nDomain: {{domain}}'
        });

        var me = this;
        me.mixin('form');
        me.status = '';
        me.errMsg = '';

        me.canSend = function () {
            return me.status !== 'sending' && me.webSiteName.value.trim() != '';
        };

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


        me.sendMail = function () {
            // neu thay doi email from khac 'app@lici.vn' phai thay doi transport.auth account tuong ung voi domain
            me.errMsg = '';
            me.status = 'sending';
            me.update();

//            setTimeout(function () {
////                me.status = 'sendRequestSuccess';
//                me.status = '';
//                me.errMsg = 'teo roi';
//
//                me.update();
//            }, 2000);

            sendRequestEmail({
                from: 'app@lici.vn',
                to:   'support@easywebhub.com',
//                to:   'nhudinhquocphuong@gmail.com',
            }, {
                username: 'user@email.com',
                domain:   me.webSiteName.value + '.easywebhub.com'
            }, function (err, info) {
                if (err) {
                    me.status = '';
                    me.errMsg = err.message;
                } else {
                    me.status = 'sendRequestSuccess';
                }
                me.update();
            });
        };

        me.show = function () {
            me.repoUrl = '';
            me.username = '';
            me.password = '';
            me.errMsg = '';
            me.status = 'showForm';
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
