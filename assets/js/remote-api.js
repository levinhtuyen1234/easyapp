'use strict';

let Promise = require('bluebird');
let _ = require('lodash');

var ERROR_MSG = {
    '444': 'user not exists'
};

var thinAdapter = {
    loginUrl:    'http://api.easywebhub.com/api-user/Logon',
    registerUrl: 'http://api.easywebhub.com/api-user/InsertUser',
    addSiteUrl:  'http://api.easywebhub.com/api-user/CreateWebsite',

    accountObjectTransformer: function (account) {
        return {
            id:          account['AccountId'],
            accessLevel: account['AccessLevel']
        }
    },

    sitesObjectTransformer: function (sites) {
        // console.log('sites', sites);
        var ret = [];
        sites.forEach(function (site) {
            ret.push({
                displayName: site['DisplayName'],
                name:        site['Name'],
                id:          site['id'],
                accounts:    _.map(site['accounts'], thinAdapter.accountObjectTransformer)
            })
        });
        return ret;
    },

    loginResponse: function (data) {
        try {
            if (!data['Data']) {
                return {
                    error: {
                        code:    -1,
                        message: 'Account not found'
                    }
                }
            }

            if (data['Result'] === true) {
                return {
                    result: {
                        id:          data['Data']['AccountId'],
                        username:    data['Data']['UserName'],
                        accountType: data['Data']['AccountType'],
                        sites:       thinAdapter.sitesObjectTransformer(data['Data']['ListWebsite'] || [])
                    }
                };
            } else {
                var msg = ERROR_MSG[data['StatusCode'].toString()];
                if (!msg)
                    msg = data['Message'];
                return {
                    error: {
                        code:    data['StatusCode'],
                        message: msg
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
                var msg = ERROR_MSG[data['StatusCode'].toString()];
                if (!msg)
                    msg = data['Message'];
                return {
                    error: {
                        code:    data['StatusCode'],
                        message: msg
                    }
                }
            }
        } catch (ex) {
            console.log('thinAdapter registerResponse error', ex);
            return {
                error: {
                    code:    -1,
                    message: `invalid response ${ex.message}`
                }
            };
        }
    },

    addSiteResponse: function (data) {
        try {
            if (data['Result'] === true && data['Data'] === true) {
                return {
                    result: true
                }
            } else {
                return {
                    result: false
                }
            }
        } catch (ex) {
            return {
                error: {
                    code:    -1,
                    message: `invalid response ${ex.message}`
                }
            };
        }
    }
};

var resolveAdapter = function () {
    return thinAdapter;
};

var adapter = resolveAdapter();

function login(username, password) {
    var data = {
        username: username,
        password: password
    };

    return Promise.resolve($.ajax({
        method:      'POST',
        dataType:    'json',
        contentType: 'application/json',
        url:         adapter.loginUrl,
        data:        JSON.stringify(data)
    }).then(function (resp) {
        resp = adapter.loginResponse(resp);
        return new Promise((resolve, reject) => {
            // console.log('LOGIN resp', resp);
            if (resp.error) {
                return reject(resp.error);
            }

            // TODO add password to data because no api to get user's site list yet (get through login)
            resp.result.password = password;
            resp.result.username = username; // TODO server always return null username too

            return resolve(resp.result);
        });
    }));
}

function register(data) {
    data = data || {};
    return Promise.resolve($.ajax({
        method:      'POST',
        dataType:    'json',
        contentType: 'application/json',
        url:         adapter.registerUrl,
        data:        JSON.stringify(data)
    }).then(function (resp) {
        resp = adapter.registerResponse(resp);
        return new Promise((resolve, reject)=> {
            if (resp.error)
                return reject(resp.error);
            return resolve('');
        });
    }));
}

class AppUser {
    constructor(data) {
        this.data = data;
    }

    get accountType() {
        return this.data.accountType;
    }

    addSite(name, displayName) {
        var postData = {
            "Accounts":    [
                {
                    "AccountId":   this.data.id,
                    "AccessLevel": ['dev']
                }
            ],
            "Name":        name,
            "DisplayName": displayName
        };
        return Promise.resolve($.ajax({
            method:      'POST',
            dataType:    'json',
            contentType: 'application/json',
            url:         adapter.addSiteUrl,
            data:        JSON.stringify(postData)
        }).then(function (resp) {
            resp = adapter.addSiteResponse(resp);
            return new Promise((resolve, reject)=> {
                if (resp.error)
                    return reject(resp.error);
                return resolve(resp.result);
            });
        }));
    }

    getSites() {
        return login(this.data.username, this.data.password).then(function (resp) {
            return resp.sites;
        })
    }
}

window.AppUser = AppUser;

module.exports = {
    login:    login,
    register: register
};
