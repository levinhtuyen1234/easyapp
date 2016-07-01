'use strict';

const Fs = require('fs');
const Path = require('path');
const ChildProcess = require('child_process');

const BlueBird = require('bluebird');
const RimRaf = BlueBird.promisify(require('rimraf'));

const ignoreName = ['.git', '__PUBLIC', '.gitignore', '.gitkeep'];
const appRoot = Path.resolve(__dirname, '../../');
const sitesRoot = Path.resolve(__dirname, '../../sites');

function getSitePath(siteName) {
    return Path.join(sitesRoot, siteName);
}

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

function newContentFile(siteName, layoutFileName, contentTitle, contentFileName, isFrontPage) {
    // console.log('newContentFile', siteName, layoutFileName, contentFileName);
    var layoutBaseName = Path.basename(layoutFileName, Path.extname(layoutFileName));
    var contentBaseName = Path.basename(contentFileName, Path.extname(contentFileName));
    var url = isFrontPage ? contentBaseName : layoutBaseName + '/' + contentBaseName;
    var defaultLayoutContent = `---json
{
    "title": "${contentTitle}",
    "url": "${url}",
    "description": "",
    "layout": "${layoutFileName}",
    "date": "${getLocalDate()}",
    "permalink": true
}
---
`;
    var layoutFolder = Path.basename(layoutFileName, Path.extname(layoutFileName));
    var newContentFilePath = isFrontPage ? Path.join('content', contentBaseName) + '.md' :
    Path.join('content', layoutFolder, contentBaseName) + '.md';
    var fullPath = Path.join(sitesRoot, siteName, newContentFilePath);

    // create folder for new content if not exists
    try {
        MkdirpSync(Path.join(sitesRoot, siteName, 'content', layoutFolder));
    } catch (_) {
    }

    Fs.writeFileSync(fullPath, defaultLayoutContent, {flag: 'wx+'});
    return {name: contentFileName, path: newContentFilePath.replace(/\\/g, '/')};
}

function MkdirpSync(p, opts, made) {
    var _0777 = parseInt('0777', 8);
    if (!opts || typeof opts !== 'object') {
        opts = {mode: opts};
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
                MkdirpSync(p, opts, made);
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

function SpawnShell(command, args, opts) {
    opts = opts || {};
    return new BlueBird((resolve, reject) => {
        var newProcess = ChildProcess.spawn(command, args, {
            env:   opts.env ? opts.env : {},
            cwd:   opts.cwd ? opts.cwd : {},
            shell: true
        });

        newProcess.stdout.on('data', function (data) {
            console.log('data', String.fromCharCode.apply(null, data));
            if (opts.onProgress) {
                opts.onProgress(String.fromCharCode.apply(null, data));
            }
        });

        newProcess.stderr.on('data', function (data) {
            console.log('data', String.fromCharCode.apply(null, data));
            if (opts.onProgress) {
                opts.onProgress(String.fromCharCode.apply(null, data));
            }
        });

        newProcess.on('exit', (code) => {
            console.log(`Child exited with code ${code}`);
            if (code === 0)
                resolve();
            else
                reject(code);
        });
    });
}

// function spawnNpmCmd(siteName, command, args, onProgress) {
//     const siteNodePath = Path.resolve(Path.join(sitesRoot, '..', 'tools', 'nodejs', 'node_modules'));
//     const ENV_PATH = [
//         Path.resolve(Path.join(sitesRoot, '..', 'tools', 'nodejs', 'node_modules', '.bin', Path.sep)),
//         Path.resolve(Path.join(sitesRoot, '..', 'tools', 'nodejs', Path.sep)),
//         Path.resolve(Path.join(sitesRoot, '..', 'tools', 'git', 'bin', Path.sep))
//     ].join(';');
//
//     return SpawnShell(command, args, {
//         cwd:        Path.resolve(Path.join(sitesRoot, siteName)),
//         env:        {
//             'NODE_PATH': siteNodePath,
//             'PATH':      ENV_PATH
//         },
//         onProgress: onProgress
//     });
// }

function spawnGitCmd(command, args, cwd, onProgress) {
    console.log('command', command);
    const ENV_PATH = [
        Path.resolve(Path.join(sitesRoot, '..', 'tools', 'git', 'bin', Path.sep)),
        Path.resolve(Path.join(sitesRoot, '..', 'tools', 'nodejs'))
    ].join(';');
    return SpawnShell(command, args, {
        cwd:        cwd,
        onProgress: onProgress,
        env:        {
            'PATH': ENV_PATH
        }
    });
}

function gitPushGhPages(siteName, onProgress) {
    const initScriptPath = Path.join(sitesRoot, '..', 'scripts', 'EWH-push-gh-pages.bat');
    const workingDirectory = Path.resolve(getSitePath(siteName));
    return spawnGitCmd(initScriptPath, [], workingDirectory, onProgress);
}

function gitPushGitHub(siteName, onProgress) {
    const initScriptPath = Path.join(sitesRoot, '..', 'scripts', 'EWH-push-github.bat');
    const workingDirectory = Path.resolve(getSitePath(siteName));
    console.log('gitPushGitHub', workingDirectory);
    return spawnGitCmd(initScriptPath, [], workingDirectory, onProgress);
}

function gitInitSite(siteName, repositoryUrl, onProgress) {
    const initScriptPath = Path.join(sitesRoot, '..', 'scripts', 'EWH-init-github.bat');
    const workingDirectory = Path.resolve(getSitePath(siteName));
    return spawnGitCmd(initScriptPath, [repositoryUrl], workingDirectory, onProgress);
}

function gitCheckout(repositoryUrl, targetDir, onProgress) {
    return spawnGitCmd('git', ['clone', '--depth', '1', repositoryUrl, targetDir], sitesRoot, onProgress).then(function () {
        return RimRaf(Path.join(targetDir, '.git'));
    });
}

function getLocalDate() {
    var now = new Date(),
        tzo = -now.getTimezoneOffset(),
        dif = tzo >= 0 ? '+' : '-',
        pad = function (num) {
            var norm = Math.abs(Math.floor(num));
            return (norm < 10 ? '0' : '') + norm;
        };
    return now.getFullYear()
        + '-' + pad(now.getMonth() + 1)
        + '-' + pad(now.getDate())
        + ' ' + pad(now.getHours())
        + ':' + pad(now.getMinutes())
        + ':' + pad(now.getSeconds())
        + ' ' + dif + pad(tzo / 60)
        + ':' + pad(tzo % 60);
}

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
    gitCheckout:        gitCheckout,
    gitInitSite:        gitInitSite,
    gitPushGhPages:     gitPushGhPages,
    gitPushGitHub:      gitPushGitHub,
    readFile:           readFile
};
