'use strict';

const Fs = require('fs');
const Path = require('path');

const BlueBird = require('bluebird');

const ignoreName = ['.git', '__PUBLIC', '.gitignore', '.gitkeep'];
const appRoot = Path.resolve(__dirname, '../../');
const sitesRoot = Path.resolve(__dirname, '../../sites');

function filterSideBarFile(name) {
    var ignoreExt = ['.config.json', '.html'];
    if (ignoreName.indexOf(name) != -1) return true;
    for (var i = 0; i < ignoreExt.length; i++) {
        if (name.endsWith(ignoreExt[i]))
            return true;
    }
    return false;
}

function filterOnlyLayoutFile(name) {
    var ignoreExt = ['.config.json'];
    if (ignoreName.indexOf(name) != -1) return true;
    for (var i = 0; i < ignoreExt.length; i++) {
        if (name.endsWith(ignoreExt[i]))
            return true;
    }
    return false;
}

let ScanDir = function (siteRoot, dir, ret) {
    for (var name of Fs.readdirSync(dir)) {
        if (filterSideBarFile(name)) continue;
        var fullPath = Path.join(dir, name);
        var stat = Fs.statSync(fullPath);

        if (stat.isDirectory()) {
            ScanDir(siteRoot, fullPath, ret);
        } else {
            ret.push({name: name, path: Path.relative(siteRoot, fullPath).replace(/\\/g, '/')});
        }
    }
    return ret;
};

function getSiteFiles(siteName) {
    var siteRoot = Path.join(sitesRoot, siteName);
    var folders = ['content', 'layout'];
    var files = [];
    for (var folder of folders) {
        ScanDir(siteRoot, Path.join(sitesRoot, siteName, folder), files);
    }
    return files;
}

function fileExists(filePath) {
    try {
        return Fs.statSync(filePath).isFile()
    } catch (e) {
        return false;
    }
}

function genSimpleContentConfigFile(metaData) {
    var contentConfig = [];
    for (var key in metaData) {
        if (!metaData.hasOwnProperty(key)) continue;
        var value = metaData[key];
        switch (typeof value) {
            case 'string':
                contentConfig.push({
                    name:        key,
                    displayName: key,
                    type:        'Text',
                    validations: [],
                    required:    false
                });
                break;
            case 'number':
                contentConfig.push({
                    name:        key,
                    displayName: key,
                    type:        'Number',
                    validations: [],
                    required:    false
                });
                break;
            case 'boolean':
                contentConfig.push({
                    name:        key,
                    displayName: key,
                    type:        'Boolean',
                    validations: [],
                    required:    false
                });
                break;
            case 'object':
                if (Array.isArray(value)) {
                    contentConfig.push({
                        name:        key,
                        displayName: key,
                        type:        'Array',
                        validations: [],
                        required:    false
                    });
                } else {
                    contentConfig.push({
                        name:        key,
                        displayName: key,
                        type:        'Object',
                        validations: [],
                        required:    false
                    });
                }
        }
    }
    return contentConfig;
}

var FORM_START = '---json';
var FORM_END = '---';
function SplitContentFile(fileContent) {
    var start = fileContent.indexOf(FORM_START);
    if (start == -1) return null;
    start += FORM_START.length;

    var end = fileContent.indexOf(FORM_END, start);
    if (end == -1) return null;

    return {
        metaData:     JSON.parse(fileContent.substr(start, end - start).trim()),
        markDownData: fileContent.substr(end + FORM_END.length).trim()
    }
}

function getContentFile(siteName, contentFilePath) {
    var contentStr = readFile(siteName, contentFilePath).trim();
    // split content thanh metaData va markdownData
    return SplitContentFile(contentStr);
}

function getRawContentFile(siteName, contentFilePath) {
    return readFile(siteName, contentFilePath).trim();
}

function saveContentFile(siteName, contentFilePath, metaData, markdownData) {
    var fullPath = Path.join(sitesRoot, siteName, contentFilePath);
    var content = `---json\r\n${JSON.stringify(metaData, null, 4)}\r\n---\r\n${markdownData}`;
    Fs.writeFileSync(fullPath, content);
}

function saveRawContentFile(siteName, filePath, content) {
    console.log('saveRawContentFile', Path.join(sitesRoot, siteName, filePath));
    Fs.writeFileSync(Path.join(sitesRoot, siteName, filePath), content);
}

function getConfigFile(siteName, contentFilePath, layoutFilePath) {
    var name = Path.basename(layoutFilePath, Path.extname(layoutFilePath));
    var contentConfigFullPath = Path.join(sitesRoot, siteName, 'layout', name) + '.config.json';

    // doc file content lay metaData
    var content = getContentFile(siteName, contentFilePath);
    // gen default config file and return
    var contentConfig = genSimpleContentConfigFile(content.metaData);

    if (fileExists(contentConfigFullPath)) {
        // read and return config file
        var existsConfig = JSON.parse(Fs.readFileSync(contentConfigFullPath).toString());
        // merge property from contentConfig -> existsConfig
        var fieldsOnlyInCurContentFile = contentConfig.filter(function (cur) {
            return existsConfig.filter(function (curB) {
                    return cur.name === curB.name;
                }).length === 0;
        });

        // update config file neu co field mới
        if (fieldsOnlyInCurContentFile.length > 0) {
            existsConfig = existsConfig.concat(fieldsOnlyInCurContentFile);
            Fs.writeFileSync(contentConfigFullPath, JSON.stringify(existsConfig, null, 4));
        }
        return existsConfig;
    } else {
        Fs.writeFileSync(contentConfigFullPath, JSON.stringify(contentConfig, null, 4));
        return contentConfig;
    }
}

function readFile(site, filePath) {
    return Fs.readFileSync(Path.join(sitesRoot, site, filePath)).toString();
}

function getLayoutList(site) {
    var sitePath = Path.join(sitesRoot, site, 'layout');
    var ret = [];
    for (var name of Fs.readdirSync(sitePath)) {
        console.log(name);
        if (filterOnlyLayoutFile(name)) continue;
        var fullPath = Path.join(sitePath, name);
        var stat = Fs.statSync(fullPath);

        if (stat.isDirectory())
            continue;
        ret.push(name);
    }
    return ret;
}

function getSiteList() {
    var ret = Fs.readdirSync(sitesRoot);
    var sites = [];
    for (var i = 0; i < ret.length; i++) {
        var sitePath = Path.join(sitesRoot, ret[i]);
        var stat = Fs.statSync(sitePath);
        if (stat.isDirectory()) {
            sites.push({name: ret[i]});
        }
    }
    return sites;
}

function saveConfigFile(siteName, layoutPath, contentConfig) {
    var name = Path.basename(layoutPath, Path.extname(layoutPath));
    var contentConfigFullPath = Path.join(sitesRoot, siteName, 'layout', name) + '.config.json';
    Fs.writeFileSync(contentConfigFullPath, contentConfig);
}

function getLayoutFile(siteName, filePath) {
    return Fs.readFileSync(Path.join(sitesRoot, siteName, 'layout', filePath)).toString();
}

function saveLayoutFile(siteName, filePath, content) {
    Fs.writeFileSync(Path.join(sitesRoot, siteName, 'layout', filePath), content);
}

function deleteFile(siteName, subFolder, filePath) {
    filePath = Path.normalize(filePath).replace(/^(\.\.[\/\\])+/, '');
    var fullPath = Path.join(sitesRoot, siteName, subFolder, filePath);
    return Fs.unlinkSync(fullPath);
}

function deleteLayoutFile(siteName, filePath) {
    return deleteFile(siteName, 'layout', filePath);
}

function deleteContentFile(siteName, filePath) {
    return deleteFile(siteName, 'content', filePath);
}

function newLayoutFile(siteName, layoutFileName) {
    var defaultLayoutContent = ``;
    var fullPath = Path.join(sitesRoot, siteName, 'layout', layoutFileName);
    Fs.writeFileSync(fullPath, defaultLayoutContent, {flag: 'wx+'});
    var layoutFilePath = Path.join('layout', layoutFileName);
    return {name: layoutFileName, path: layoutFilePath.replace(/\\/g, '/')};
}

function newContentFile(siteName, layoutFileName, contentTitle, contentFileName) {
    console.log('newContentFile', siteName, layoutFileName, contentFileName);
    var layoutBaseName = Path.basename(layoutFileName, Path.extname(layoutFileName));
    var contentBaseName = Path.basename(contentFileName, Path.extname(contentFileName));
    var defaultLayoutContent = `---json
{
    "title": "${contentTitle}",
    "url": "${contentBaseName}",
    "layout": "${layoutFileName}"
}
---
`;
    var layoutFolder = Path.basename(layoutFileName, Path.extname(layoutFileName));
    var newContentFilePath = Path.join('content', layoutFolder, contentFileName);
    var fullPath = Path.join(sitesRoot, siteName, newContentFilePath);

    // create folder for new content if not exists
    try {
        MkdirpSync(Path.join(sitesRoot, siteName, 'content', layoutFolder));
    } catch(_){}

    Fs.writeFileSync(fullPath, defaultLayoutContent, {flag: 'wx+'});
    return {name: contentFileName, path: newContentFilePath.replace(/\\/g, '/')};
}

function MkdirpSync(p, opts, made) {
    var _0777 = parseInt('0777', 8);
    if (!opts || typeof opts !== 'object') {
        opts = { mode: opts };
    }

    var mode = opts.mode;
    var xfs = opts.fs || Fs;

    if (mode === undefined) {
        mode = _0777 & (~process.umask());
    }
    if (!made) made = null;

    p = Path.resolve(p);

    try {
        xfs.mkdirSync(p, mode);
        made = made || p;
    }
    catch (err0) {
        switch (err0.code) {
            case 'ENOENT' :
                made = MkdirpSync(Path.dirname(p), opts, made);
                sync(p, opts, made);
                break;

            // In the case of any other error, just see if there's a dir
            // there already.  If so, then hooray!  If not, then something
            // is borked.
            default:
                var stat;
                try {
                    stat = xfs.statSync(p);
                }
                catch (err1) {
                    throw err0;
                }
                if (!stat.isDirectory()) throw err0;
                break;
        }
    }

    return made;
}

// const nodePath = Path.resolve(Path.join('sites', opts.site_name, 'node_modules'));
//
// const GIT_ENV_PATH = [
//     Path.resolve(Path.join('sites', opts.site_name, 'node_modules', '.bin', Path.sep)),
//     Path.resolve(Path.join(opts.site_name, '..', 'tools', 'nodejs', Path.sep)),
//     Path.resolve(Path.join(opts.site_name, '..', 'tools', 'git', 'bin', Path.sep))
// ].join(';');
// console.log('PATH', PATH);
//
// function spawnProcess(command, args) {
//     args = args || [];
//     var newProcess = ChildProcess.spawn(command, args, {
//         env:   {
//             'NODE_PATH': nodePath,
//             'PATH':      PATH
//         },
//         cwd:   Path.resolve(Path.join('sites', opts.site_name)),
//         shell: true
//     });
//
//     newProcess.stdout.on('data', function (data) {
//         console.log(data);
//         // find browserSync port in stdout
//         var str = String.fromCharCode.apply(null, data);
//         (/Local: (http:\/\/.+)/gm).exec(str);
//         var reviewUrl = str.match(/Local: (http:\/\/.+)/gm);
//         if (reviewUrl != null) {
//             console.log('found review url', reviewUrl[1]);
//             me.iframeUrl = reviewUrl[1];
//             me.update();
//         }
//         me.append(str);
//     });
//
//     newProcess.stderr.on('data', function (data) {
//         console.log(data);
//         me.appendError(data);
//     });
//
//     return newProcess;
// }
//
// function DeployToGitHub(siteName, repositoryUrl, username, password) {
//
// }
//
// function GitClone() {}

module.exports = {
    getSiteList:        getSiteList,
    getSiteFiles:       getSiteFiles,
    getConfigFile:      getConfigFile,
    saveConfigFile:     saveConfigFile,
    getRawContentFile:  getRawContentFile,
    getContentFile:     getContentFile,
    saveContentFile:    saveContentFile,
    saveRawContentFile: saveRawContentFile,
    getLayoutFile:      getLayoutFile,
    saveLayoutFile:     saveLayoutFile,
    deleteLayoutFile:   deleteLayoutFile,
    deleteContentFile:  deleteContentFile,
    getLayoutList:      getLayoutList,
    newLayoutFile:      newLayoutFile,
    newContentFile:     newContentFile,
    readFile:           readFile
};
