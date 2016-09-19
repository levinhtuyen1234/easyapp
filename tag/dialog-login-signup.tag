<dialog-login-signup class="ui modal" tabindex="-1" role="dialog" data-backdrop="static" style="margin-top: 20vh">
    <div class="modal-dialog" role="document">
        <div class="modal-body">
            <div>
                <ul class="nav nav-tabs nav-pills" style="border-bottom: 0;" role="tablist">
                    <li class="active {requesting ? 'disabled': ''}"><a disabled="{requesting}" href="#login" data-toggle="tab">Login</a></li>
                    <li class="{requesting ? 'disabled': ''}"><a disabled="{requesting}" href="#register" data-toggle="tab">Register</a></li>
                </ul>
                <div class="tab-content">
                    <!-- LOGIN TAB -->
                    <div role="tabpanel" class="tab-pane fade in active" id="login">
                        <form class="form-horizontal" method="post" action="">
                            <div class="form-group ">
                                <div class="input-group">
                                    <div class="input-group-addon "><i class="fa fa-user fa-fw"></i></div>
                                    <input type="text" disabled="{requesting}" name="loginUsername" class="form-control" placeholder="Username" required="required" value="" onkeyup="{isLoginFormValid}">
                                </div>
                            </div>
                            <div class="form-group ">
                                <div class="input-group">
                                    <div class="input-group-addon"><i class="fa fa-key fa-fw"></i></div>
                                    <input type="password" disabled="{requesting}" name="loginPassword" class="form-control" placeholder="Password" required="required" onkeyup="{isLoginFormValid}">
                                </div>
                            </div>
                            <div class="form-group" style="text-align: center">
                                <a href='#' class="btn btn-default {(isLoginFormValid() && !requesting) ? '': 'disabled'} " disabled="{!isLoginFormValid && requesting}" onclick="{login}">
                                    Login
                                    <i class="fa fa-spinner fa-pulse fa-fw" if="{requesting}"></i>
                                </a>
                            </div>
                        </form>
                    </div>

                    <!-- REGISTER TAB -->
                    <div role="tabpanel" class="tab-pane fade" id="register">
                        <form class="form-horizontal" method="post" action="">
                            <div class="form-group ">
                                <div class="input-group">
                                    <div class="input-group-addon"><i class="fa fa-user fa-fw"></i></div>
                                    <input type="text" disabled="{requesting}" name="registerUsername" class="form-control" placeholder="Username" required="required" value="">
                                </div>
                            </div>
                            <div class="form-group ">
                                <div class="input-group">
                                    <div class="input-group-addon"><i class="fa fa-lock fa-fw"></i></div>
                                    <input type="password" disabled="{requesting}" name="registerPassword" class="form-control" placeholder="Password" required="required" onkeyup="{isRegisterFormValid}">
                                </div>
                            </div>
                            <div class="form-group ">
                                <div class="input-group">
                                    <div class="input-group-addon"><i class="fa fa-lock fa-fw"></i></div>
                                    <input type="password" disabled="{requesting}" name="registerConfirmPassword" class="form-control" placeholder="Confirm Password" required="required" onkeyup="{isRegisterFormValid}">
                                </div>
                            </div>
                            <span if="{errorMsg !== ''}" class="alert alert-danger help-block">{errorMsg}</span>
                            <div class="form-group" style="text-align: center">
                                <a href='#' class="btn btn-default {(isRegisterFormValid() && !requesting) ? '': 'disabled'}" disabled="{!isRegisterFormValid && requesting}" onclick="{register}">
                                    Register
                                    <i class="fa fa-spinner fa-pulse fa-fw" if="{requesting}"></i>
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        var me = this;
        me.requesting = false;
        me.errorMsg = '';

        me.on('mount', function () {
            console.log('show login register dialog');
            $(me.root).modal('show');
        });

        me.on('unmount', function () {
            console.log('hide login register dialog');
            $(me.root).modal('hide');
        });

        me.login = function (e, username, password) {
            console.log('LOGIN', username, password);
            me.requesting = true;
            username = username || me.loginUsername.value.trim();
            password = password || me.loginPassword.value.trim();

            API.login(username, password).then(function (result) {
                console.log('login success, trigger loginSuccess');
                me.unmount(true);
                riot.event.trigger('loginSuccess', result);
            }).catch(function (err) {
                me.errMsg = err.statusText;
                me.requesting = false;
                me.update();
            });
        };

        me.register = function () {
            console.log('REGISTER');
            me.requesting = true;

            var data = {
                username:    me.registerUsername.value.trim(),
                password:    me.registerPassword.value.trim(),
                accountType: 'user',
                websites:    []
            };
            API.register(data).then(function () {
                console.log('register success, call login', data.username, data.password);
                return me.login(null, data.username, data.password);
            }).catch(function (err) {
                alert(err.message, 'Register failed');
                me.requesting = false;
                me.update();
            });
        };

        me.isLoginFormValid = function () {
            return me.loginUsername.value.trim() !== '' &&
                    me.loginPassword.value.trim() !== ''
        };

        me.isRegisterFormValid = function () {
            var username = me.registerUsername.value.trim();
            var password = me.registerUsername.value.trim();
            var confirmPassword = me.registerConfirmPassword.value.trim();
            console.log('username', username, 'password', password, 'confirmPassword', confirmPassword);
            return username !== '' &&
                    password !== '' &&
                    confirmPassword !== '' &&
                    password === confirmPassword;
        };
    </script>
</dialog-login-signup>
