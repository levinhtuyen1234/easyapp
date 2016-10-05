'use strict';

const Fs = require('fs');
const Path = require('path');
const ChildProcess = require('child_process');
const Remote = require('electron').remote;
const Shell = Remote.shell;

const _ = require('lodash');
const BlueBird = require('bluebird');
const Mkdir = BlueBird.promisify(Fs.mkdir);
const RimRaf = BlueBird.promisify(require('rimraf'));

const IGNORE_NAMES = ['.gitignore', '.gitkeep'];
const IGNORE_FOLDERS = ['.git', '__PUBLIC'];
const ASSET_EXTS = ['js', 'css', 'html', 'htm', 'ts', 'coffee', 'sass', 'less', 'scss'];
let appRoot;
let sitesRoot;

sitesRoot = Path.resolve('sites');
appRoot = Path.resolve('');
console.log('DEV PATH', sitesRoot, appRoot);

try {
    Fs.mkdirSync(sitesRoot);
} catch (_) {

}
console.log('sitesRoot', sitesRoot);

function getSitePath(siteName) {
    return Path.join(sitesRoot, siteName);
}

function createSiteFolder(siteName) {
    // console.log('createSiteFolder', sitesRoot, siteName);
    let sitePath = Path.join(sitesRoot, siteName);
    return Mkdir(sitePath).then(function () {
        return sitePath;
    })
}

function filterContentFile(name, isDir) {
    if (isDir) return true;
    if (name.endsWith('.md'))
        return true;
    return false;
    // var ignoreExt = ['.json', '.html'];
    // if (IGNORE_NAMES.indexOf(name) != -1) return false;
    // var ext = name.split('.').pop();
    // if (ignoreExt.indexOf(ext) != -1)
    //     return false;
    // return true;
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

function filterOnlyRootLayoutFile(name, isDir) {
    if (isDir) {
        return false;
    } else {
        var ext = name.split('.').pop();
        if (ext !== 'html') return false;
        if (name.endsWith('.category.html') || name.endsWith('.tag.html')) return false;
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
        ScanDir(siteRoot, Path.join(sitesRoot, siteName, folder), files, filterContentFile);
    }
    // console.log('getSiteContentFiles', files);
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
        // console.log('getSiteAssetFiles', Path.join(sitesRoot, siteName, folder));
        ScanDir(siteRoot, Path.join(sitesRoot, siteName, folder), files, filterAssetFile);
    }
    return files;
}

function getLayoutList(siteName) {
    var siteRoot = Path.join(sitesRoot, siteName);
    var folders = ['layout'];
    var files = [];
    for (var folder of folders) {
        // console.log('getLayoutList', Path.join(sitesRoot, siteName, folder));
        ScanDir(siteRoot, Path.join(sitesRoot, siteName, folder), files, filterOnlyLayoutFile);
    }
    return files;
}

function getRootLayoutList(siteName) {
    var siteRoot = Path.join(sitesRoot, siteName);
    var folders = ['layout'];
    var files = [];
    for (var folder of folders) {
        // console.log('getRootLayoutList', Path.join(sitesRoot, siteName, folder));
        ScanDir(siteRoot, Path.join(sitesRoot, siteName, folder), files, filterOnlyRootLayoutFile);
    }
    return files;
}

function fileExists(filePath) {
    try {
        return (Fs.statSync(filePath).isFile());
    } catch (e) {
        return (false);
    }
}

function genSimpleContentConfigFile(metaData) {
    var contentConfig = [];

    var fixedFields = [];
    var tmpFields = [];

    for (var key in metaData) {
        var fields = (key === 'slug' || key === 'layout' || key === 'category' || key === 'tag') ? fixedFields : tmpFields;
        if (!metaData.hasOwnProperty(key)) continue;
        var value = metaData[key];

        switch (typeof value) {
            case 'string':
                switch (key) {
                    case 'date':
                        fields.push({
                            name:        key,
                            displayName: key,
                            displayType: 'DateTime',
                            type:        'DateTime',
                            validations: [],
                            viewOnly:    key === 'layout',
                            required:    false
                        });
                        break;
                    default:
                        fields.push({
                            name:        key,
                            displayName: key,
                            type:        'Text',
                            validations: [],
                            viewOnly:    key === 'layout' || key === 'slug',
                            required:    false
                        });
                }
                break;
            case 'number':
                fields.push({
                    name:        key,
                    displayName: key,
                    type:        'Number',
                    validations: [],
                    required:    false
                });
                break;
            case 'boolean':
                fields.push({
                    name:        key,
                    displayName: key,
                    type:        'Boolean',
                    validations: [],
                    required:    false
                });
                break;
            case 'object':
                if (Array.isArray(value)) {
                    fields.push({
                        name:        key,
                        displayName: key,
                        type:        'Array',
                        validations: [],
                        required:    false,
                        children:    []
                    });
                } else {
                    fields.push({
                        name:        key,
                        displayName: key,
                        type:        'Object',
                        validations: [],
                        required:    false,
                        children:    genSimpleContentConfigFile(value)
                    });
                }
        }
    }
    return fixedFields.concat(tmpFields);
}

String.prototype.regexIndexOf = function (regex, startpos) {
    var indexOf = this.substring(startpos || 0).search(regex);
    return (indexOf >= 0) ? (indexOf + (startpos || 0)) : indexOf;
};

var FORM_START = /^---json/;
var FORM_END_1 = /---$/;
var FORM_END_2 = /---[\r\n]/;
function SplitContentFile(fileContent) {
    var start = fileContent.regexIndexOf(FORM_START);
    if (start == -1) return null;
    start += 7;

    var end = fileContent.regexIndexOf(FORM_END_1, start);
    if (end == -1)
        end = fileContent.regexIndexOf(FORM_END_2, start);
    if (end == -1) return null;
    return {
        metaData:     JSON.parse(fileContent.substr(start, end - start).trim()),
        markDownData: fileContent.substr(end + 3).trim()
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
        var newConfig = _.merge(existsConfig, contentConfig);
        // // merge property from contentConfig -> existsConfig
        // var fieldsOnlyInCurContentFile = contentConfig.filter(function (cur) {
        //     return existsConfig.filter(function (curB) {
        //             return cur.name === curB.name;
        //         }).length === 0;
        // });
        //
        // // update config file neu co field mới
        // if (fieldsOnlyInCurContentFile.length > 0) {
        //     existsConfig = existsConfig.concat(fieldsOnlyInCurContentFile);
        //     Fs.writeFileSync(contentConfigFullPath, JSON.stringify(existsConfig, null, 4));
        // }
        return newConfig;
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

function newContentFile(siteName, layoutFileName, contentTitle, contentFileName, category, tag, isFrontPage) {
    // console.log('newContentFile', siteName, layoutFileName, contentFileName);
    var contentBaseName = Path.basename(contentFileName, Path.extname(contentFileName));
    var layoutBaseName = Path.basename(layoutFileName, Path.extname(layoutFileName));
    var slug = isFrontPage ? contentBaseName : layoutBaseName + '/' + contentBaseName;
    // var slug = contentBaseName;
    var defaultLayoutContent = `---json
{
    "title": "${contentTitle}",
    "slug": "${slug}",
    "description": "",
    "category": "${category}",
    "tag": ${tag},
    "layout": "${layoutFileName}",
    "date": "${getLocalDate()}"
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
        let out = '';
        let newProcess = ChildProcess.spawn(command, args, {
            env:   opts.env ? opts.env : {},
            cwd:   opts.cwd ? opts.cwd : {},
            shell: true
        });

        newProcess.on('error', function (err) {
            reject(err);
        });

        newProcess.stdout.on('data', function (data) {
            let str = String.fromCharCode.apply(null, data);
            out += str;
            if (opts.onProgress)
                opts.onProgress(str);
        });

        newProcess.stderr.on('data', function (data) {
            let str = String.fromCharCode.apply(null, data);
            out += str;
            if (opts.onProgress)
                opts.onProgress(str);
        });

        newProcess.on('exit', (code) => {
            console.log(`Child exited with code ${code}`);
            if (code === 0)
                resolve(out);
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
    return new BlueBird((resolve, reject) => {
        var output = '';
        return spawnGitCmd('git', ['status'], workingDirectory, function (data) {
            output += data + '\r\n';
        }).catch(ex => {
            reject(ex);
        }).then(() => {
            console.log('output', output);
            var match = output.match(/((new file:)|(deleted:)|(modified:))[\s\t]+(.+)/g);
            if (match == null) {
                output = new Date().toString();
            } else {
                output = '"' + match.join('" -m "') + '"';
            }

            resolve(output);
        });
    });
}

function gitAdd(siteName, filePath, onProgress) {
    const workingDirectory = Path.resolve(getSitePath(siteName));
    return spawnGitCmd('git', ['add', filePath], workingDirectory, onProgress);
}

function getLocalDate() {
    return moment().format('DD-MM-YYYY HH:mm:ss');
}

function addMediaFile(siteName, filePath, cb) {
    var sitePath = getSitePath(siteName);
    // check if file already in site's asset folder
    var relativePath = Path.relative(sitePath, filePath);
    if (relativePath.startsWith('asset' + Path.sep)) {
        // file is in sites' asset folder
        relativePath = relativePath.substr(6); // remove "asset/"
        cb(null, relativePath.replace(/\\/g, '/'));
    } else {
        // copy file vo asset/img
        var fileName = filePath.split(/[\\\/]/).pop();
        var targetDir = Path.join(sitesRoot, siteName, 'asset', 'img');
        var target = Path.join(targetDir, fileName);
        MkdirpSync(targetDir);

        var cbCalled = false;
        var done = function (err, filePath) {
            if (!cbCalled) {
                if (err) cb(err);
                else cb(null, filePath);
                cbCalled = true;
            }
        };

        var rd = Fs.createReadStream(filePath);
        rd.on('error', done);

        var wr = Fs.createWriteStream(target);
        wr.on('error', done);
        wr.on('close', function (ex) {
            relativePath = Path.join('img', fileName);
            done(null, relativePath.replace(/\\/g, '/'));
        });
        rd.pipe(wr);
    }
}

function getMetaFile(siteName, filePath) {
    return Fs.readFileSync(Path.join(sitesRoot, siteName, filePath)).toString();
}

function getMetaConfigFile(siteName, metaFilePath) {
    var metaFileContent = readFile(siteName, metaFilePath);
    var metaData = JSON.parse(metaFileContent);
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

function isGhPageInitialized(siteName) {
    return spawnGitCmd('git', ['branch'], getSitePath(siteName)).then(data => {
        return data.indexOf('* gh-pages') !== -1;
    })
}

function setDomain(siteName, domain) {
    var fullPath = Path.join(sitesRoot, siteName, 'asset', 'CNAME');
    Fs.writeFileSync(fullPath, domain);
}

function getListConfig(dir) {
    try {
        var filePathList = Fs.readdirSync(dir);
        // console.log('filePathList', filePathList);
        let ret = [];
        filePathList.forEach(function (filePath) {
            // console.log('filePath', filePath);
            filePath = Path.join(dir, filePath);
            var stat = Fs.statSync(filePath);
            if (!stat.isFile()) return;
            var fileName = filePath.split(/[\\\/]/g).pop();
            var categoryValue = fileName.substr(0, fileName.lastIndexOf('.'));
            var config = JSON.parse(Fs.readFileSync(filePath));
            ret.push({
                name:  config.displayName,
                value: categoryValue
            });
        });
        return ret;
    } catch (ex) {
        console.log(ex);
        return [];
    }
}

var categoryListCache;
function getCategoryList(siteName) {
    // if (categoryListCache)
    //     return categoryListCache;
    // else
    categoryListCache = getListConfig(Path.join(sitesRoot, siteName, 'content', 'metadata', 'category'));
    return categoryListCache;
}

function purgeCategoryListCache() {
    // categoryListCache = null;
}

// TODO cache getTagList and getCategoryList
function getTagList(siteName) {
    return getListConfig(Path.join(sitesRoot, siteName, 'content', 'metadata', 'tag'));
}


function getCategoryLayoutList(siteName) {
    var ret = [];
    var siteRoot = Path.join(sitesRoot, siteName);
    var filter = function (fileName, isDir) {
        if (isDir) return false; // no recursive
        if (fileName.endsWith('.category.html')) return false;
        if (fileName.endsWith('.tag.html')) return false;
        return true;
    };
    return scanDir(siteRoot, 'layout', ret, filter)
}

function newTag(siteName, tagName, tagFileName) {
    var defaultTagConfig = JSON.stringify({
        "sortBy":      "date",
        "reverse":     false,
        "metadata":    {},
        "displayName": tagName,
        "perPage":     10,
        "noPageOne":   true,
        "layout":      "default.tag.html",
        "first":       "tag/:tag/index.html",
        "path":        "tag/:tag/page/:num/index.html"
    }, null, 4);
    try {
        Fs.mkdirSync(Path.join(sitesRoot, siteName, 'content', 'metadata', 'tag'));
    } catch (_) {
    }
    var fullPath = Path.join(sitesRoot, siteName, 'content', 'metadata', 'tag', tagFileName);
    Fs.writeFileSync(fullPath, defaultTagConfig, {flag: 'wx+'});
    var categoryFilePath = Path.join('content', 'metadata', 'category', tagFileName);
    return {name: tagName, path: categoryFilePath.replace(/\\/g, '/')};
}

function newCategory(siteName, categoryName, categoryFileName) {
    var defaultCategoryConfig = JSON.stringify({
        "sortBy":      "date",
        "reverse":     false,
        "metadata":    {},
        "displayName": categoryName,
        "perPage":     10,
        "noPageOne":   true,
        "layout":      "default.category.html",
        "first":       ":categoryPath/index.html",
        "path":        ":categoryPath/page/:num/index.html"
    }, null, 4);
    try {
        Fs.mkdirSync(Path.join(sitesRoot, siteName, 'content', 'metadata', 'category'));
    } catch (_) {
    }
    var fullPath = Path.join(sitesRoot, siteName, 'content', 'metadata', 'category', categoryFileName);
    Fs.writeFileSync(fullPath, defaultCategoryConfig, {flag: 'wx+'});
    var categoryFilePath = Path.join('content', 'metadata', 'category', categoryFileName);
    return {name: categoryName, path: categoryFilePath.replace(/\\/g, '/')};
}

function filterOnlyMetadataFile(name, isDir) {
    if (isDir) {
        return true;
    } else {
        var ext = name.split('.').pop();
        if (ext !== 'json') return false;
    }
    return true;
}

function getSiteMetadataFiles(siteName) {
    var siteRoot = Path.join(sitesRoot, siteName);
    var folders = ['content/metadata'];
    var files = [];
    for (var folder of folders) {
        ScanDir(siteRoot, Path.join(sitesRoot, siteName, folder), files, filterOnlyMetadataFile);
    }
    return files;
}

function showItemInFolder(siteName, filePath) {
    Shell.showItemInFolder(Path.join(sitesRoot, siteName, filePath));
}

module.exports = {
    showItemInFolder:       showItemInFolder,
    fileExists:             fileExists,
    newCategory:            newCategory,
    getCategoryLayoutList:  getCategoryLayoutList,
    getCategoryList:        getCategoryList,
    purgeCategoryListCache: purgeCategoryListCache,
    newTag:                 newTag,
    getTagList:             getTagList,
    getMetaFile:            getMetaFile,
    getSiteMetadataFiles:   getSiteMetadataFiles,
    getMetaConfigFile:      getMetaConfigFile,
    saveMetaFile:           saveMetaFile,
    saveMetaConfigFile:     saveMetaConfigFile,
    createSiteFolder:       createSiteFolder,
    getSiteList:            getSiteList,
    getConfigFile:          getConfigFile,
    saveConfigFile:         saveConfigFile,
    getRawContentFile:      getRawContentFile,
    getContentFile:         getContentFile,
    saveContentFile:        saveContentFile,
    saveRawContentFile:     saveRawContentFile,
    getLayoutFile:          getLayoutFile,
    saveLayoutFile:         saveLayoutFile,
    deleteLayoutFile:       deleteLayoutFile,
    deleteContentFile:      deleteContentFile,
    getLayoutList:          getLayoutList,
    getRootLayoutList:      getRootLayoutList,
    newLayoutFile:          newLayoutFile,
    gitAdd:                 gitAdd,
    newContentFile:         newContentFile,
    gitCheckout:            gitCheckout,
    gitInitSite:            gitInitSite,
    gitGenMessage:          gitGenMessage,
    gitImportGitHub:        gitImportGitHub,
    gitCommit:              gitCommit,
    gitPushGhPages:         gitPushGhPages,
    gitPushGitHub:          gitPushGitHub,
    getSiteLayoutFiles:     getSiteLayoutFiles,
    getSiteAssetFiles:      getSiteAssetFiles,
    getSiteContentFiles:    getSiteContentFiles,
    readFile:               readFile,
    addMediaFile:           addMediaFile,
    isGhPageInitialized:    isGhPageInitialized,
    setDomain:              setDomain
};
