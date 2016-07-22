'use strict';

const Fs = require('fs');
const Path = require('path');
const ChildProcess = require('child_process');

const BlueBird = require('bluebird');
const Mkdir = BlueBird.promisify(Fs.mkdir);
const RimRaf = BlueBird.promisify(require('rimraf'));

const IGNORE_NAMES = ['.gitignore', '.gitkeep'];
const IGNORE_FOLDERS = ['.git', '__PUBLIC'];
const ASSET_EXTS = ['js', 'css', 'html', 'htm', 'ts', 'coffee', 'sass', 'less', 'scss'];
let appRoot;
let sitesRoot;

// if (__dirname.indexOf('resources/app') != -1 || __dirname.indexOf('resources\\app') != -1) {
sitesRoot = Path.resolve('sites');
appRoot = Path.resolve('');
console.log('DEV PATH', sitesRoot, appRoot);
// } else {
//     sitesRoot = Path.resolve(__dirname, '../../sites');
//     appRoot = Path.resolve(__dirname, '../../');
//     console.log('ASAR PATH', sitesRoot, appRoot);
// }

try {
    Fs.mkdirSync(sitesRoot);
} catch (_) {

}
console.log('sitesRoot', sitesRoot);

function getSitePath(siteName) {
    return Path.join(sitesRoot, siteName);
}

function createSiteFolder(siteName) {
    console.log('createSiteFolder', sitesRoot, siteName);
    let sitePath = Path.join(sitesRoot, siteName);
    return Mkdir(sitePath).then(function () {
        return sitePath;
    })
}

function filterSideBarFile(name, isDir) {
    var ignoreExt = ['.config.json', '.html'];
    if (IGNORE_NAMES.indexOf(name) != -1) return false;
    var ext = name.split('.').pop();
    if (ignoreExt.indexOf(ext) != -1)
        return false;
    return true;
}

function filterOnlyLayoutFile(name, isDir) {
    if (isDir) {
        return true;
    } else {
        var ext = name.split('.').pop();
        if (ext !== 'html') return false;
    }
    return true;
}

function filterAssetFile(name, isDir) {
    if (isDir) {
        if (IGNORE_FOLDERS.indexOf(name) != -1) return false;
    } else {
        if (IGNORE_NAMES.indexOf(name) != -1) return false;
        var ext = name.split('.').pop();
        if (ASSET_EXTS.indexOf(ext) == -1) return false;
    }
    return true;
}

let ScanDir = function (siteRoot, dir, ret, filter) {
    try {
        for (var name of Fs.readdirSync(dir)) {
            var fullPath = Path.join(dir, name);
            var stat = Fs.statSync(fullPath);

            var isDir = stat.isDirectory();
            if (filter && typeof(filter) === 'function')
                if (filter(name, isDir) == false)
                    continue;

            if (isDir) {
                ScanDir(siteRoot, fullPath, ret, filter);
            } else {
                ret.push({name: name, path: Path.relative(siteRoot, fullPath).replace(/\\/g, '/')});
            }
        }
        return ret;
    } catch (_) {
        return ret;
    }
};

function getSiteContentFiles(siteName) {
    var siteRoot = Path.join(sitesRoot, siteName);
    var folders = ['content'];
    var files = [];
    for (var folder of folders) {
        ScanDir(siteRoot, Path.join(sitesRoot, siteName, folder), files, filterSideBarFile);
    }
    return files;
}

function getSiteLayoutFiles(siteName) {
    var siteRoot = Path.join(sitesRoot, siteName);
    var folders = ['layout'];
    var files = [];
    for (var folder of folders) {
        ScanDir(siteRoot, Path.join(sitesRoot, siteName, folder), files, filterOnlyLayoutFile);
    }
    return files;
}

function getSiteAssetFiles(siteName) {
    var siteRoot = Path.join(sitesRoot, siteName);
    var folders = ['asset'];
    var files = [];
    for (var folder of folders) {
        console.log('getSiteAssetFiles', Path.join(sitesRoot, siteName, folder));
        ScanDir(siteRoot, Path.join(sitesRoot, siteName, folder), files, filterAssetFile);
    }
    return files;
}

function getLayoutList(siteName) {
    var siteRoot = Path.join(sitesRoot, siteName);
    var folders = ['layout'];
    var files = [];
    for (var folder of folders) {
        console.log('getSiteAssetFiles', Path.join(sitesRoot, siteName, folder));
        ScanDir(siteRoot, Path.join(sitesRoot, siteName, folder), files, filterOnlyLayoutFile);
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
                    viewOnly:    key === 'layout',
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
    var slug = isFrontPage ? contentBaseName : layoutBaseName + '/' + contentBaseName;
    var defaultLayoutContent = `---json
{
    "title": "${contentTitle}",
    "slug": "${slug}",
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
    const privateNodePath = Path.resolve(Path.join(sitesRoot, '..', 'tools', 'nodejs', 'node_modules'));

    const ENV_PATH = [
        Path.resolve(Path.join(sitesRoot, '..', 'tools', 'git', 'bin', Path.sep)),
        Path.resolve(Path.join(sitesRoot, '..', 'tools', 'nodejs', 'node_modules', '.bin')),
        Path.resolve(Path.join(sitesRoot, '..', 'tools', 'nodejs'))
    ].join(';');
    console.log('command', command, 'args', args, 'cwd', cwd, 'privateNodePath', privateNodePath, 'ENV_PATH', ENV_PATH);
    return SpawnShell(command, args, {
        cwd:        cwd,
        onProgress: onProgress,
        env:        {
            'NODE_PATH': privateNodePath,
            'PATH':      ENV_PATH
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
    // console.log('gitPushGitHub', workingDirectory);
    return spawnGitCmd(initScriptPath, [], workingDirectory, onProgress);
}

function gitInitSite(siteName, repositoryUrl, onProgress) {
    const initScriptPath = Path.join(sitesRoot, '..', 'scripts', 'EWH-init-github.bat');
    const workingDirectory = Path.resolve(getSitePath(siteName));
    return spawnGitCmd(initScriptPath, [repositoryUrl], workingDirectory, onProgress);
}

function gitImportGitHub(siteName, repositoryUrl, onProgress) {
    const initScriptPath = Path.join(sitesRoot, '..', 'scripts', 'EWH-import-github.bat');
    const workingDirectory = Path.resolve(getSitePath(siteName));
    MkdirpSync(workingDirectory);
    return spawnGitCmd(initScriptPath, [repositoryUrl, '.'], workingDirectory, onProgress);
}

function gitCheckout(repositoryUrl, branch, targetDir, onProgress) {
    return spawnGitCmd('git', ['clone', '-b', branch, '--single-branch', '--depth', '1', repositoryUrl, targetDir], sitesRoot, onProgress).then(function () {
        return RimRaf(Path.join(targetDir, '.git'));
    });
}

function gitCommit(siteName, message, onProgress) {
    const workingDirectory = Path.resolve(getSitePath(siteName));
    return spawnGitCmd('git', ['commit', '-am', message], workingDirectory, onProgress);
}

function gitGenMessage(siteName) {
    const workingDirectory = Path.resolve(getSitePath(siteName));
    return new BlueBird((resolve, reject)=> {
        var output = '';
        return spawnGitCmd('git', ['status'], workingDirectory, function (data) {
            output += data + '\r\n';
        }).catch(ex => {
            reject(ex);
        }).then(()=> {
            output = '"' + output.match(/((new file:)|(deleted:)|(modified:))[\s\t]+(.+)/g).join('" -m "') + '"';
            resolve(output);
        });
    });
}

function gitAdd(siteName, filePath, onProgress) {
    const workingDirectory = Path.resolve(getSitePath(siteName));
    return spawnGitCmd('git', ['add', filePath], workingDirectory, onProgress);
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

function copyAssetFile(siteName, source, target, cb) {
    MkdirpSync(Path.join(sitesRoot, siteName, 'asset', 'img')); // TODO generalize this
    target = Path.join(sitesRoot, siteName, target);

    var cbCalled = false;

    var rd = Fs.createReadStream(source);
    rd.on('error', done);

    var wr = Fs.createWriteStream(target);
    wr.on('error', done);
    wr.on('close', function (ex) {
        done();
    });
    rd.pipe(wr);

    function done(err) {
        if (!cbCalled) {
            cb(err);
            cbCalled = true;
        }
    }
}

function getMetaFile(siteName, filePath) {
    return Fs.readFileSync(Path.join(sitesRoot, siteName, filePath)).toString();
}

function getMetaConfigFile(siteName, metaFilePath) {
    // TODO detect metaConfig file exists, if not create
    var metaFileContent = readFile(siteName, metaFilePath);
    var metaData = JSON.parse(metaFileContent);
    console.log('metaData', metaData);
    var name = Path.basename(metaFilePath, Path.extname(metaFilePath));
    var configFullPath = Path.join(sitesRoot, siteName, 'layout', name) + '.meta.json';
    var metaConfig = genSimpleContentConfigFile(metaData);

    if (fileExists(configFullPath)) {
        // read and return config file
        var existsConfig = JSON.parse(Fs.readFileSync(configFullPath).toString());
        // merge property from metaConfig -> existsConfig
        var fieldsOnlyInCurMetaFile = metaConfig.filter(function (cur) {
            return existsConfig.filter(function (curB) {
                    return cur.name === curB.name;
                }).length === 0;
        });

        // update config file neu co field mới
        if (fieldsOnlyInCurMetaFile.length > 0) {
            existsConfig = existsConfig.concat(fieldsOnlyInCurMetaFile);
            Fs.writeFileSync(configFullPath, JSON.stringify(existsConfig, null, 4));
        }
        return existsConfig;
    } else {
        Fs.writeFileSync(configFullPath, JSON.stringify(metaConfig, null, 4));
        return metaConfig;
    }
}

function saveMetaFile(siteName, contentFilePath, metaData) {
    var fullPath = Path.join(sitesRoot, siteName, contentFilePath);
    Fs.writeFileSync(fullPath, JSON.stringify(metaData, null, 4));
}

function saveMetaConfigFile(siteName, metaFilePath, metaConfig) {
    var name = Path.basename(metaFilePath, Path.extname(metaFilePath));
    var configFullPath = Path.join(sitesRoot, siteName, 'layout', name) + '.meta.json';
    Fs.writeFileSync(configFullPath, metaConfig);
}

module.exports = {
    getMetaFile:         getMetaFile,
    getMetaConfigFile:   getMetaConfigFile,
    saveMetaFile:        saveMetaFile,
    saveMetaConfigFile:  saveMetaConfigFile,
    createSiteFolder:    createSiteFolder,
    getSiteList:         getSiteList,
    getConfigFile:       getConfigFile,
    saveConfigFile:      saveConfigFile,
    getRawContentFile:   getRawContentFile,
    getContentFile:      getContentFile,
    saveContentFile:     saveContentFile,
    saveRawContentFile:  saveRawContentFile,
    getLayoutFile:       getLayoutFile,
    saveLayoutFile:      saveLayoutFile,
    deleteLayoutFile:    deleteLayoutFile,
    deleteContentFile:   deleteContentFile,
    getLayoutList:       getLayoutList,
    newLayoutFile:       newLayoutFile,
    gitAdd:              gitAdd,
    newContentFile:      newContentFile,
    gitCheckout:         gitCheckout,
    gitInitSite:         gitInitSite,
    gitGenMessage:       gitGenMessage,
    gitImportGitHub:     gitImportGitHub,
    gitCommit:           gitCommit,
    gitPushGhPages:      gitPushGhPages,
    gitPushGitHub:       gitPushGitHub,
    getSiteLayoutFiles:  getSiteLayoutFiles,
    getSiteAssetFiles:   getSiteAssetFiles,
    getSiteContentFiles: getSiteContentFiles,
    readFile:            readFile,
    copyAssetFile:       copyAssetFile
};
