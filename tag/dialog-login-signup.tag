<dialog-login-signup class="ui small modal" tabindex="-1" role="dialog" data-backdrop="static" style="margin-top: 20vh; width: 460px;margin-left: -16vw;">
    <!--<div class="header" style="border-bottom: 0">-->
    <!--Account Settings-->
    <!--<div class="sub header">Manage your account settings and set e-mail preferences.</div>-->
    <!--</div>-->
    <div class="ui header" style="">
        <i class="{isLogin ? 'sign in' : 'signup'} icon" style=""></i>
        <div class="content" style="text-align: left">
            {isLogin ? 'Login to EasyWeb' : 'Register EasyWeb account'}
            <!--<div class="sub header">Manage your account settings and set e-mail preferences.</div>-->
            <!--<div class="sub header"></div>-->
        </div>
    </div>
    <div class="content">
        <form class="ui form error {loading : isRequesting}">
            <div class="required field">
                <div class="ui left icon input">
                    <i class="user icon"></i>
                    <input name="usernameField" type="text" placeholder="Username" onkeyup="{edit.bind(this, 'username')}">
                </div>
            </div>

            <div show="{!isLogin}" class="required field">
                <div class="ui left icon input" data-tooltip="Please use actual email address, it helps us keep in touch with you later">
                    <i class="mail icon"></i>
                    <input name="emailField" type="email" placeholder="Email" onkeyup="{edit.bind(this, 'email')}">
                </div>
            </div>
            <div class="required field">
                <div class="ui left icon input">
                    <i class="lock icon"></i>
                    <input name="passwordField" type="password" placeholder="Password" onkeyup="{edit.bind(this, 'password')}">
                </div>
            </div>
            <div show="{!isLogin}" class="required field" id="confirmPasswordField">
                <div class="ui left icon input">
                    <i class="lock icon"></i>
                    <input name="confirmPasswordField" type="password" placeholder="Confirm Password" onkeyup="{edit.bind(this, 'confirmPassword')}">
                </div>
            </div>
            <div show="{errorMsg != ''}" class="ui error message">
                <!--<div class="header">{isLogin ? 'Login to EasyWeb' : 'Sign Up EasyWeb account'} Error</div>-->
                <p>{errorMsg}</p>
            </div>
            <div class="ui fluid button blue" onclick="{submit}">{isLogin ? 'Sign In' : 'Sign Up'}</div>
            <div show="{isLogin}" class="ui message" style="text-align: center;">
                New to us? <a href="#" onclick="{changeMode}">Sign Up</a>
            </div>
            <div show="{!isLogin}" class="ui message" style="text-align: center;">
                Already have an account? <a href="#" onclick="{changeMode}">Sign In</a>
            </div>
        </form>
    </div>

    <script>
        var me = this;
        me.mixin('form');

        me.isRequesting = false;
        me.isLogin = true;
        me.errorMsg = '';
        me.email = '';
        var modal = null;

        me.changeMode = function () {
            me.isLogin = !me.isLogin;
            me.errorMsg = '';

            me.usernameField.value = '';
            me.passwordField.value = '';
            me.confirmPasswordField.value = '';

            me.update();
        };

        me.on('mount', function () {
            console.log('show login register dialog');
            modal = $(me.root).modal({
                closable: false
            });
            modal.modal('show');
        });

        me.on('unmount', function () {
            console.log('hide login register dialog');
            modal.modal('hide');
        });

        me.submit = function () {
            if (me.isLogin) {
                me.login();
            } else {
                me.register();
            }
        };

        me.login = function () {
            me.isRequesting = true;

            try {
                validateLoginForm();

                API.login(me.username, me.password).then(function (result) {
                    console.log('login success, trigger loginSuccess, result', result);
                    me.isRequesting = false;
                    me.unmount(true);
                    riot.event.trigger('loginSuccess', result);
                }).catch(function (err) {
                    me.errorMsg = err.message;
                    me.isRequesting = false;
                    me.update();
                });
            } catch (ex) {
                me.errorMsg = ex.message;
                me.isRequesting = false;
            }
        };


        me.register = function () {
            console.log('REGISTER');
            me.isRequesting = true;

            try {
                validateRegisterForm();
                var data = {
                    Username:    me.username,
                    Password:    me.password,
                    AccountType: 'user',
                    Status:      'verified',
                    Info:        {
                        Name:    '',
                        Email:   me.email,
                        Sex:     '',
                        Address: '',
                        Age:     ''
                    }
                };

                API.register(data).then(function () {
                    return me.login();
                }).catch(function (err) {
//                alert(err.message, 'Register failed');
                    me.errorMsg = err.message;
                    me.isRequesting = false;
                    me.update();
                });
            } catch (ex) {
                me.errorMsg = ex.message;
                me.isRequesting = false;
            }
        };

        var validateLoginForm = function () {
            if (me.username == undefined || ((me.username = me.username.trim()) === '')) {
                throw new Error('username is empty');
            }

            if (me.password == undefined || ((me.password = me.password.trim()) === '')) {
                throw new Error('password is empty');
            }
        };

        var validateRegisterForm = function () {
            validateLoginForm();
            var emailRegex = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            me.email  = me.email.trim();
            if (me.email && !emailRegex.test(me.email))
                throw new Error('email is invalid');

            if (me.password != me.confirmPassword) {
                throw new Error('password not match');
            }
        };
    </script>
</dialog-login-signup>
