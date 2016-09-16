'use strict';

let Promise = require('bluebird');

var thinAdapter = {
    loginUrl:               'http://api.easywebhub.com/api-user/logon',
    registerUrl:            'http://api.easywebhub.com/api-user/InsertUser',
    sitesObjectTransformer: function (sites) {
        var ret = [];
        sites.forEach(function (site) {
            var name = site['DisplayName'].toLowerCase()
                .normalize('NFKD')
                .replace(/[\u0300-\u036F]/g, '')
                .replace(/đ/g, 'd')
                .replace(/[?,!\/'":;#$@\\()\[\]{}^~]*/g, '')
                .replace(/\s+/g, '-')
                .trim();
            ret.push({
                displayName: site['DisplayName'],
                name:        name,
                id:          site['Id']
            })
        });
        return ret;
    },
    loginResponse:          function (data) {
        try {
//                    console.log('data', data);
            if (data['Result'] === true) {
                return {
                    result: {
                        id:          data['Data']['AccountId'],
                        username:    data['Data']['UserName'],
                        password:    data['Data']['Password'],
                        accountType: data['Data']['accountType'],
                        sites:       thinAdapter.sitesObjectTransformer(data['Data']['Websites'] || [])
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

function login(username, password) {
    console.log('LOGIN', username, password);
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
            if (resp.error)
                return reject(resp.error);
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

function addSite(user, name, displayName) {

}

function updateSiteRepoUrl(user, siteName, repoUrl) {

}

module.exports = {
    login:    login,
    register: register,
};
