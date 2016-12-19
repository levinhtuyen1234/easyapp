'use strict';

let Promise = require('bluebird');
let _ = require('lodash');

const GOGS_SERVER_URL = 'http://212.47.253.180:7000'; // TODO TEMP SERVER

const ERROR_MSG = {
    '444':           'user not exists',
    'AlreadyExists': 'Username already exists'
};

const Ajax = Promise.coroutine(function*(opts) {
    return new Promise((resolve, reject) => {
        $.ajax(opts).then(function (resp) {
            return resolve(resp);
        }, function (xhr, textStatus, errorThrown) {
            if (xhr.responseJSON.Message)
                reject(new Error(xhr.responseJSON.Message));
            else
                reject(new Error(errorThrown));
        });
    });
});

const restAdapter = {
    loginUrl:    'http://api.easywebhub.com/auth/signin',
    registerUrl: 'http://api.easywebhub.com/users',
    addSiteUrl:  'http://api.easywebhub.com/websites',

    accountObjectTransformer: function (account) {
        console.log('accountObjectTransformer', account);
        return {
            id:          account['AccountId'],
            accessLevel: account['AccessLevel']
        }
    },

    sitesObjectTransformer: function (sites) {
        // console.log('sitesObjectTransformer', sites);
        var ret = [];
        sites.forEach(function (site) {
            ret.push({
                displayName: site['DisplayName'],
                name:        site['Name'],
                url:         site['Url'],
                id:          site['WebsiteId']
            })
        });
        // console.log('sitesObjectTransformer after', ret);
        return ret;
    },

    registerResponse: function (data) {
        console.log('registerResponse', data);
    },

    addSiteResponse: function (data) {
        console.log('addSiteResponse', data);
    }
};

// const thinAdapter = {
//     loginUrl:    'http://api.easywebhub.com/auth/signin',
//     registerUrl: 'http://api.easywebhub.com/auth/signup',
//     addSiteUrl:  'http://api.easywebhub.com/website/addnew',
//
//     accountObjectTransformer: function (account) {
//         return {
//             id:          account['AccountId'],
//             accessLevel: account['AccessLevel']
//         }
//     },
//
//     sitesObjectTransformer: function (sites) {
//         // console.log('sites', sites);
//         var ret = [];
//         sites.forEach(function (site) {
//             ret.push({
//                 displayName: site['DisplayName'],
//                 name:        site['Name'],
//                 id:          site['id'],
//                 accounts:    _.map(site['accounts'], thinAdapter.accountObjectTransformer)
//             })
//         });
//         return ret;
//     },
//
//     loginResponse: function (data) {
//         try {
//             if (data['Result'] === true) {
//                 return {
//                     result: {
//                         id:          data['Data']['AccountId'],
//                         username:    data['Data']['UserName'],
//                         accountType: data['Data']['AccountType'],
//                         info:        data['Data']['Info'],
//                         sites:       thinAdapter.sitesObjectTransformer(data['Data']['ListWebsite'] || [])
//                     }
//                 };
//             } else {
//                 return {
//                     error: {
//                         code:    data['StatusCode'],
//                         message: data['Message']
//                     }
//                 }
//             }
//         } catch (err) {
//             console.log('thinAdapter loginResponse error', err);
//             return {
//                 error: {
//                     code:    -1,
//                     message: `invalid response ${err.message}`
//                 }
//             };
//         }
//     },
//
//     registerResponse: function (data) {
//         try {
//             if (data['Result'] === true) {
//                 return {
//                     result: {}
//                 };
//             } else {
//                 return {
//                     error: {
//                         code:    data['StatusCode'],
//                         message: data['Message']
//                     }
//                 }
//             }
//         } catch (ex) {
//             console.log('thinAdapter registerResponse error', ex);
//             return {
//                 error: {
//                     code:    -1,
//                     message: `invalid response ${ex.message}`
//                 }
//             };
//         }
//     },
//
//     addSiteResponse: function (data) {
//         try {
//             // TODO get more website info
//             if (data['Result'] === true && data['Data'] === true) {
//                 return {
//                     result: true
//                 }
//             } else {
//                 return {
//                     result: false
//                 }
//             }
//         } catch (ex) {
//             return {
//                 error: {
//                     code:    -1,
//                     message: `invalid response ${ex.message}`
//                 }
//             };
//         }
//     }
// };

var adapter = restAdapter;

function login(username, password) {
    var data = {
        Username: username,
        Password: password
    };

    return Ajax({
        method:      'POST',
        dataType:    'json',
        contentType: 'application/json',
        url:         adapter.loginUrl,
        data:        JSON.stringify(data)
    }).then(function (resp) {
        var ret = {
            id:          resp.AccountId,
            accountType: resp.AccountType,
            username:    resp.UserName,
            status:      resp.Status,
            info:        {
                address: resp.Info.Address,
                age:     resp.Info.Age,
                name:    resp.Info.Name,
                sex:     resp.Info.Sex
            }
        };

        return getSites(resp.AccountId, null).then(function (sites) {
            ret.sites = sites;
            return ret;
        });
    });
}

function register(data) {
    data = data || {};
    return Ajax({
        method:      'POST',
        dataType:    'json',
        contentType: 'application/json',
        url:         adapter.registerUrl,
        data:        JSON.stringify(data)
    }).then(function (resp) {
        resp = adapter.registerResponse(resp);
        return resp;
    });
}

function CreateGogsRepo(username, repositoryName) {
    return new Promise((resolve, reject) => {
        $.ajax({
            method:      'POST',
            dataType:    'json',
            contentType: 'application/json',
            url:         `${GOGS_SERVER_URL}/repos`,
            data:        JSON.stringify({
                username:       username,
                repositoryName: repositoryName
            })
        }).then(function (data, textStatus, jqXHR) {
            resolve(data);
        }, function (jqXHR, textStatus, errorThrown) {
            console.log(jqXHR, textStatus, errorThrown);
            if (jqXHR && jqXHR.responseJSON && jqXHR.responseJSON.message)
                reject(new Error(jqXHR.responseJSON.message));
            else
                reject(new Error(textStatus));
        });
    });
}

function getSites(userId, token) {
    return Ajax({
        method:      'GET',
        dataType:    'json',
        contentType: 'application/json',
        url:         `http://api.easywebhub.com/users/${userId}/websites`,
    }).then(function (resp, textStatus, jqXHR) {
        return resp;
    });
}

class AppUser {
    constructor(data) {
        this.data = data;
    }

    get accountType() {
        return this.data.accountType;
    }

    addSite(name, displayName) {
        var username = this.data.username;
        var id = this.data.id;
        // tao remote git repo
        // TODO THIS IS TEMP CODE tạo repo phai o tren server
        return CreateGogsRepo(username, name).then(function (data) {
            console.log('CreateGogsRepo resp', data);
            localStorage.setItem(`${username}-${name}`, data.url);

            // call add site (goi. sau khi goi. gogs vi` khong co API update website)
            var postData = {
                "Accounts":    [
                    {
                        "AccountId":   id,
                        "AccessLevel": ['dev']
                    }
                ],
                "Name":        name,
                "DisplayName": displayName,
                "Url":         data.url
            };

            return Ajax({
                method:      'POST',
                dataType:    'json',
                contentType: 'application/json',
                url:         adapter.addSiteUrl,
                data:        JSON.stringify(postData)
            }).then(function (resp) {
                console.log('addSite resp', resp);
                resp = adapter.addSiteResponse(resp);

                console.log('username', username);
                return {
                    url: data.url
                };
            });
        }).catch(function (error) {
            console.log('ERRRORRRR', error.message);
            if (error.message.startsWith('repository already exists')) {
                var repoUrl = localStorage.getItem(`${username}-${name}`);
                if (!repoUrl)
                    reject(new Error('Failed to get repository url'));
                return {
                    url: repoUrl
                };
            } else {
                reject(new Error('create gogs reposiory failed, ' + error.message));
            }
        });
    }

    getSites() {
        // return login(this.data.username, this.data.password).then(function (resp) {
        //     return resp.sites;
        // })
        return getSites(this.data.id, null).then(function (sites) {
            return adapter.sitesObjectTransformer(sites);
        });
    }
}

window.AppUser = AppUser;

module.exports = {
    login:    login,
    register: register
};
