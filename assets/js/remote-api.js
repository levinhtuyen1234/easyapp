'use strict';

let Promise = require('bluebird');
let _ = require('lodash');

// const GOGS_SERVER_URL = 'http://212.47.253.180:7000'; // GOGS SERVER
const GOGS_SERVER_URL = 'http://212.47.253.180:7002'; // GITEA SERVER

const ERROR_MSG = {
    '444':           'user not exists',
    'AlreadyExists': 'Username already exists'
};

const Ajax = function (opts) {
    return new Promise((resolve, reject) => {
        return $.ajax(opts).then(function (resp, textStatus, jqXHR) {
            resolve(resp);
        }, function (xhr, textStatus, errorThrown) {
            let errMsg = errorThrown;
            if (xhr.responseJSON && xhr.responseJSON.Message) {
                let errMsg = xhr.responseJSON.Message;
                if (xhr.responseJSON.ExceptionType) {
                    errMsg = xhr.responseJSON.ExceptionType + ': ' + errMsg;
                }
                reject(new Error(errMsg));
            } else {
                reject(new Error(errorThrown));
            }
        });
    })
};

const restAdapter = {
    loginUrl:    'https://api.easywebhub.com/auth/signin',
    registerUrl: 'https://api.easywebhub.com/users',
    addSiteUrl:  'https://api.easywebhub.com/websites',

    accountObjectTransformer: function (account) {
        console.log('accountObjectTransformer', account);
        return {
            id:           account['AccountId'],
            accessLevels: account['AccessLevels']
        }
    },

    sitesObjectTransformer: function (sites) {
        // console.log('sitesObjectTransformer', sites);
        let ret = [];
        sites.forEach(function (site) {
            ret.push({
                displayName:   site['DisplayName'],
                name:          site['Name'],
                url:           site['Url'],
                id:            site['WebsiteId'],
                webTemplateId: site['WebTemplateId'],
                source:        site['Source'],
                webSiteType:   site['WebsiteType'],
                git:           site['Git']
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
            accessLevel: resp.AccessLevels || [],
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
    return Ajax({
        method:      'POST',
        dataType:    'json',
        contentType: 'application/json',
        url:         `${GOGS_SERVER_URL}/repos`,
        data:        JSON.stringify({
            username:       username,
            repositoryName: repositoryName
        })
    });
}

function CreateGogsRepoByMigration(username, repositoryName, templateName) {
    return Ajax({
        method:      'POST',
        dataType:    'json',
        contentType: 'application/json',
        url:         `${GOGS_SERVER_URL}/migration`,
        data:        JSON.stringify({
            username:       username,
            repositoryName: repositoryName,
            templateName:   templateName
        })
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

var Url = require('url');

function getTemplateNameFromUrl(url) {
    let parts = url.split('/');
    let name = parts.pop();
    parts = name.split('.');
    parts.pop();
    return parts.join('.');
}

class AppUser {
    constructor(data) {
        this.data = data;
    }

    get accountType() {
        return this.data.accountType;
    }

    addSite(name, displayName, templateId) {
        var username = this.data.username;
        var accountId = this.data.id;
        // templateId example github.com/easywebhub/easymarket.git
        // tao remote git repo

        // return CreateGogsRepo(username, name).then(function (data) {
        console.log('templateId before trim', templateId);
        // let matches = templateId.match(/\/([\w\d-]+)\.git/);
        // if (!matches || !matches.length || matches.length !== 2) {
        //     throw new Error('invalid template name');
        // }
        let templateName = getTemplateNameFromUrl(templateId);
        // console.log('CreateGogsRepoByMigration resp', data);
        // let uri = Url.parse(data.url);
        // uri.auth = `${data.username}:${data.password}`;
        // let tmpRepoUrl = Url.format(uri);

        // call add site (goi. sau khi goi. gogs vi` khong co API update website)
        var postData = {
            'Name':              name,
            'DisplayName':       displayName,
            'Source':            '',
            'WebTemplateId':     templateName,
            'EnableAutoConfirm': true,
            "Accounts":          [
                {
                    "AccountId":    accountId,
                    "AccessLevels": ['Owner']
                }
            ],
        };

        console.log('postData', JSON.stringify(postData));

        return Ajax({
            method:      'POST',
            dataType:    'json',
            contentType: 'application/json',
            url:         `https://api.easywebhub.com/websites`,
            data:        JSON.stringify(postData)
        }).then(function (resp) {
            console.log('addSite resp', resp);

            localStorage.setItem(`${username}-${name}`, resp.Source);
            localStorage.setItem(`${username}-${name}-git`, resp.Git);
            localStorage.setItem(`${username}-${name}-cname`, resp.Url);
            // resp = adapter.addSiteResponse(resp);

            // console.log('username', username);
            return {
                url: resp.Source,
                git: resp.Git,
                cname: resp.Url
            };
        });
        // }).catch(function (error) {
        //     console.log('CALL REMOTE GOT ERROR', error.message);
        //     if (error.message.startsWith('repository already exists')) {
        //         var repoUrl = localStorage.getItem(`${username}-${name}`);
        //         if (!repoUrl)
        //             throw new Error('Failed to get repository url');
        //         return {
        //             url: repoUrl
        //         };
        //     } else {
        //         throw new Error('create gogs reposiory failed, ' + error.message);
        //     }
        // });
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
