<dialog-login-signup class="modal fade" tabindex="-1" role="dialog" data-backdrop="static" style="margin-top: 20vh">
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
                                <a type="submit" class="btn btn-success {isLoginFormValid() ? '': 'disabled'} " disabled="{!isLoginFormValid}" onclick="{login}">
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
                                <a type="submit" class="btn btn-success" disabled="{!isRegisterFormValid}" onclick="{register}">
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
            $(me.root).modal('show');
        });


        //        var loginResponseSuccess = {
        //            "Result":     true,
        //            "Message":    "Thành công!",
        //            "StatusCode": 200,
        //            "ItemsCount": 1,
        //            "Data":       {
        //                "AccountId":    "0001",
        //                "AccountType":  "user",
        //                "Username":     "baotnq",
        //                "Password":     "m468jYe/f96oqqZ8f6QgkayJxk8znYn+TzKSCoH9O+k=",
        //                "PasswordSalt": "loxDb1lFh3rQB7a5DCvMXhInA6IcSpi9",
        //                "Status":       "verified",
        //                "Info":         {
        //                    "Name":    "Trịnh Ngọc Quốc Bảo",
        //                    "Age":     "31",
        //                    "Sex":     "nam",
        //                    "Address": ""
        //                },
        //                "Websites":     null
        //            }
        //        };

        //        var loginResponseFail = {
        //            "Result":     false,
        //            "Message":    "Login Fail!!",
        //            "StatusCode": 422,
        //            "ItemsCount": 0,
        //            "Data":       null
        //        };

        var thinAdapter = {
            loginUrl:    'http://api.easywebhub.com/api-user/logon',
            registerUrl: 'http://api.easywebhub.com/api-user/InsertUser',

            loginResponse: function (data) {
                try {
                    if (data['Result'] === true) {
                        return {
                            result: {
                                id:       data['Data']['AccountId'],
                                username: data['Data']['Username'],
                                sites:    data['Data']['Websites'] || []
                            }
                        };
                    } else {
                        return {
                            error: {
                                code:    data['StatusCode'],
                                message: data['Message']
                            }
                        }
                    }
                } catch (err) {
                    console.log('thinAdapter loginResponse error', err);
                    return {
                        error: {
                            code:    -1,
                            message: `invalid response ${err.message}`
                        }
                    };
                }
            },

            registerResponse: function (data) {
                try {
                    if (data['Result'] === true) {
                        return {
                            result: {}
                        };
                    } else {
                        return {
                            error: {
                                code:    data['StatusCode'],
                                message: data['Message']
                            }
                        }
                    }
                } catch (err) {
                    console.log('thinAdapter registerResponse error', err);
                    return {
                        error: {
                            code:    -1,
                            message: `invalid response ${err.message}`
                        }
                    };
                }
            }
        };

        var resolveAdapter = function () {
            return thinAdapter;
        };

        var adapter = resolveAdapter();

        me.login = function (e, username, password) {
            console.log('LOGIN', username, password);
            me.requesting = true;
            var data = {
                username: username || me.loginUsername.value.trim(),
                password: password || me.loginPassword.value.trim()
            };

            $.ajax({
                method:      'POST',
                dataType:    'json',
                contentType: 'application/json',
                url:         adapter.loginUrl,
                data:        JSON.stringify(data)
            }).then(function (resp) {
                resp = adapter.loginResponse(resp);
                if (resp.error) {
                    me.errMsg = resp.error.message;
                    console.log('login failed', resp.error.message);
                    alert(resp.error.message, 'Login failed');
                } else {
                    console.log('login success', resp.result);
                    me.unmount(true);
                    localStorage.setItem('username', data.username);
                    localStorage.setItem('password', data.password);
                }
            }).fail(function (err) {
                console.log('login err', err.statusText);
                me.errMsg = err.statusText;
            }).always(function () {
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

            $.ajax({
                method:      'POST',
                dataType:    'json',
                contentType: 'application/json',
                url:         adapter.registerUrl,
                data:        JSON.stringify(data)
            }).then(function (resp) {
                resp = adapter.registerResponse(resp);
                if (resp.error) {
                    console.log('register failed', resp.error.message);
                    alert(resp.error.message, 'Register failed');
                } else {
                    console.log('register success', resp.result);
                    return me.login(null, data.username, data.password);
                }
            }).fail(function (err) {
                console.log('err', err.statusText);

            }).always(function () {
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
            return username !== '' &&
                    password !== '' &&
                    confirmPassword !== '' &&
                    password === confirmPassword;
        };
    </script>
</dialog-login-signup>
