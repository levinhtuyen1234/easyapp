'use strict';

const Promise = require('bluebird');
const Path = require('path');
const ChildProcess = require('child_process');
const Matter = require('gray-matter');
const Remote = require('electron').remote;
const Shell = Remote.shell;

const _ = require('lodash');
const Fs = Promise.promisifyAll(require('fs'));
const Fse = Promise.promisifyAll(require('fs-extra'));
const Mkdir = Promise.promisify(Fs.mkdir);

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
    // let ignoreExt = ['.json', '.html'];
    // if (IGNORE_NAMES.indexOf(name) != -1) return false;
    // let ext = name.split('.').pop();
    // if (ignoreExt.indexOf(ext) != -1)
    //     return false;
    // return true;
}

function filterOnlyLayoutFile(name, isDir) {
    if (isDir) {
        return true;
    } else {
        let ext = name.split('.').pop();
        if (ext !== 'html') return false;
    }
    return true;
}

function filterOnlyRootLayoutFile(name, isDir) {
    if (isDir) {
        return false;
    } else {
        let ext = name.split('.').pop();
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
        let ext = name.split('.').pop();
        if (ASSET_EXTS.indexOf(ext) == -1) return false;
    }
    return true;
}

let ScanDir = function (siteRoot, dir, ret, filter) {
    try {
        for (let name of Fs.readdirSync(dir)) {
            let fullPath = Path.join(dir, name);
            let stat = Fs.statSync(fullPath);

            let isDir = stat.isDirectory();
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
    let siteRoot = Path.join(sitesRoot, siteName);
    let folders = ['content'];
    let files = [];
    for (let folder of folders) {
        ScanDir(siteRoot, Path.join(sitesRoot, siteName, folder), files, filterContentFile);
    }
    // console.log('getSiteContentFiles', files);
    return files;
}

function getSiteLayoutFiles(siteName) {
    let siteRoot = Path.join(sitesRoot, siteName);
    let folders = ['layout'];
    let files = [];
    for (let folder of folders) {
        ScanDir(siteRoot, Path.join(sitesRoot, siteName, folder), files, filterOnlyLayoutFile);
    }
    return files;
}

function getSiteAssetFiles(siteName) {
    let siteRoot = Path.join(sitesRoot, siteName);
    let folders = ['asset'];
    let files = [];
    for (let folder of folders) {
        // console.log('getSiteAssetFiles', Path.join(sitesRoot, siteName, folder));
        ScanDir(siteRoot, Path.join(sitesRoot, siteName, folder), files, filterAssetFile);
    }
    return files;
}

function getLayoutList(siteName) {
    let siteRoot = Path.join(sitesRoot, siteName);
    let folders = ['layout'];
    let files = [];
    for (let folder of folders) {
        // console.log('getLayoutList', Path.join(sitesRoot, siteName, folder));
        ScanDir(siteRoot, Path.join(sitesRoot, siteName, folder), files, filterOnlyLayoutFile);
    }
    return files;
}

function getRootLayoutList(siteName) {
    let siteRoot = Path.join(sitesRoot, siteName);
    let folders = ['layout'];
    let files = [];
    for (let folder of folders) {
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

function getDefaultContentConfig(key, valueType) {
    valueType = valueType.toLowerCase();
    // console.log('getDefaultContentConfig valueType', valueType);
    switch (valueType) {
        case 'string':
            return {
                name:         key,
                displayName:  key,
                type:         'Text',
                displayType:  'ShortText',
                defaultValue: '',
                validations:  [],
                viewOnly:     false,
                required:     false
            };
        case 'media':
            return {
                name:         key,
                displayName:  key,
                type:         'Media',
                displayType:  '',
                defaultValue: '',
                validations:  [],
                required:     false
            };
        case 'datatime':
            return {
                name:         key,
                displayName:  key,
                type:         'DateTime',
                displayType:  'DateTime',
                defaultValue: '',
                validations:  [],
                required:     false
            };
        case 'number':
            return {
                name:         key,
                displayName:  key,
                type:         'Number',
                displayType:  'Number',
                defaultValue: 0,
                validations:  [],
                required:     false
            };
        case 'boolean':
            return {
                name:         key,
                displayName:  key,
                type:         'Boolean',
                defaultValue: false,
                validations:  [],
                required:     false
            };
        case 'array':
            return {
                name:        key,
                displayName: key,
                type:        'Array',
                validations: [],
                required:    false,
                children:    []
            };
        case 'object':
            return {
                name:        key,
                displayName: key,
                type:        'Object',
                validations: [],
                required:    false,
                children:    []
            };
        default:
            return {
                name:         key,
                displayName:  key,
                type:         'Text',
                displayType:  'ShortText',
                defaultValue: '',
                validations:  [],
                viewOnly:     false,
                required:     false
            };
    }
}

let DefaultFixedFieldNames = ['title', 'slug', 'layout', 'category', 'tag', 'publishDate', 'draft'];

function genSimpleContentConfig(metaData, fixedFieldNames) {
    let fixedFields = [];
    let tmpFields = [];
    let fixedField = false;

    for (let key in metaData) {
        if (!metaData.hasOwnProperty(key)) {
            continue;
        }

        let fields = tmpFields;
        if (fixedFieldNames && fixedFieldNames.indexOf(key) != -1) {
            fields = fixedFields;
            fixedField = true;
        }


        let value = metaData[key];
        let valueType = typeof value;
        switch (valueType) {
            case 'string':
                switch (key) {
                    case 'date':
                        fields.push({
                            name:         key,
                            displayName:  key,
                            displayType:  'DateTime',
                            type:         'DateTime',
                            defaultValue: '',
                            validations:  [],
                            viewOnly:     (fixedField && key === 'layout'),
                            required:     false
                        });
                        break;
                    default:
                        fields.push({
                            name:         key,
                            displayName:  key,
                            type:         'Text',
                            displayType:  'ShortText',
                            defaultValue: '',
                            validations:  [],
                            viewOnly:     (fixedField && (key === 'layout' || key === 'slug')),
                            required:     false
                        });
                }
                break;
            case 'number':
                fields.push({
                    name:         key,
                    displayName:  key,
                    type:         'Number',
                    displayType:  'Number',
                    defaultValue: 0,
                    validations:  [],
                    required:     false
                });
                break;
            case 'boolean':
                fields.push({
                    name:         key,
                    displayName:  key,
                    type:         'Boolean',
                    defaultValue: false,
                    validations:  [],
                    required:     false
                });
                break;
            case 'object':
                if (Array.isArray(value)) {
                    // use first object in array value to gen model
                    let children = [];
                    // chi? tao model khi value[0] type la object
                    if (value.length >= 1 && typeof(value[0]) === 'object') {
                        children = genSimpleContentConfig(value[0]);
                    }
                    fields.push({
                        name:        key,
                        displayName: key,
                        type:        'Array',
                        validations: [],
                        required:    false,
                        children:    children
                    });
                } else {
                    fields.push({
                        name:        key,
                        displayName: key,
                        type:        'Object',
                        validations: [],
                        required:    false,
                        children:    genSimpleContentConfig(value)
                    });
                }
                break;
        }
    }

    // add _config to fixed fields if not exists
    if (fixedFields.length > 0) {
        let contentField = _.find(fixedFields, {name: '__content__'});
        if (!contentField) {
            fixedFields.push({
                name:         '__content__',
                displayName:  '[Content]',
                type:         'Text',
                displayType:  'MarkDown',
                defaultValue: '',
                validations:  [],
                hidden:       false,
                viewOnly:     false,
                required:     true
            });
        }

        contentField = _.find(fixedFields, {name: 'publishDate'});
        if (!contentField) {
            fixedFields.push({
                name:         'publishDate',
                displayName:  'Publish Date',
                type:         'DateTime',
                displayType:  'DateTime',
                defaultValue: '',
                validations:  [],
                hidden:       false,
                viewOnly:     false,
                required:     true
            });
        }

        contentField = _.find(fixedFields, {name: 'draft'});
        if (!contentField) {
            fixedFields.push({
                name:         'draft',
                displayName:  'Draft',
                type:         'Boolean',
                displayType:  '',
                defaultValue: false,
                validations:  [],
                hidden:       false,
                viewOnly:     false,
                required:     true
            });
        }
    }
    return tmpFields.concat(fixedFields);
}

String.prototype.regexIndexOf = function (regex, startpos) {
    let indexOf = this.substring(startpos || 0).search(regex);
    return (indexOf >= 0) ? (indexOf + (startpos || 0)) : indexOf;
};

// let FORM_START = /^---json/;
// let FORM_END_1 = /---$/;
// let FORM_END_2 = /---[\r\n]/;
// function SplitContentFile(fileContent) {
//     let start = fileContent.regexIndexOf(FORM_START);
//     if (start == -1) return null;
//     start += 7;
//
//     let end = fileContent.regexIndexOf(FORM_END_1, start);
//     if (end == -1)
//         end = fileContent.regexIndexOf(FORM_END_2, start);
//     if (end == -1) return null;
//     return {
//         metaData:     JSON.parse(fileContent.substr(start, end - start).trim()),
//         markDownData: fileContent.substr(end + 3).trim()
//     }
// }

function SplitContentFile(fileContent) {
    let parsed = Matter(fileContent);
    let ret = {
        metaData:     parsed.data,
        markDownData: parsed.content
    };
    ret['__content__'] = parsed.content;
    return ret;
}

function getContentFile(siteName, contentFilePath) {
    let contentStr = readFile(siteName, contentFilePath).trim();
    // split content thanh metaData va markdownData
    return SplitContentFile(contentStr);
}

function getRawContentFile(siteName, contentFilePath) {
    return readFile(siteName, contentFilePath).trim();
}

function saveContentFile(siteName, contentFilePath, metaData, markdownData) {
    let fullPath = Path.join(sitesRoot, siteName, contentFilePath);
    let content = `---json\r\n${JSON.stringify(metaData, null, 4)}\r\n---\r\n${markdownData}`;
    Fs.writeFileSync(fullPath, content);
}

function saveRawContentFile(siteName, filePath, content) {
    console.log('saveRawContentFile', Path.join(sitesRoot, siteName, filePath));
    Fs.writeFileSync(Path.join(sitesRoot, siteName, filePath), content);
}

function isObjectEqual(lhs, rhs) {
    return JSON.stringify(lhs) === JSON.stringify(rhs);
}

let mergeConfig = function (existsConfigs, newGenConfigs) {
    // find new config object
    let newConfigObjects = _.differenceBy(newGenConfigs, existsConfigs, 'name');

    // merge children
    for (let i = 0; i < existsConfigs.length; i++) {
        let existsConfig = existsConfigs[i];
        let newConfig = _.find(newGenConfigs, {name: existsConfig.name});
        if (!newConfig) continue;

        // merge field exists in newConfig and not in existsConfig
        for (let key in newConfig) {
            if (!newConfig.hasOwnProperty(key)) continue;
            if (key === 'children') continue;
            if (existsConfig[key]) continue;
            existsConfig[key] = newConfig[key];
        }

        if (!existsConfig.children && newConfig.children) {
            existsConfig.children = newConfig.children;
        } else if (existsConfig.children && newConfig.children) {
            existsConfig.children = mergeConfig(existsConfig.children, newConfig.children);
        }
    }

    return existsConfigs.concat(newConfigObjects);
};

const schemaSetArrayFormat = function (obj, type) {
    if (typeof(obj) !== 'object') return;
    if (obj && obj.type && obj.type === 'array') {
        obj.format = type;
    }

    if (obj.properties) {
        _.forOwn(obj.properties, prop => {
            schemaSetArrayFormat(prop, type);
        })
    }

    if (obj.items && obj.items.properties) {
        _.forOwn(obj.items.properties, prop => {
            schemaSetArrayFormat(prop, type);
        });
    }
};

function genJsonSchemaMetaConfig(metaData, DefaultFixedFieldNames) {
    let schema = JSON.parse(window.ToJsonSchema(JSON.stringify(metaData)));
    schemaSetArrayFormat(schema, 'table');
    return schema;
}

function genJsonSchemaContentConfig(metaData, DefaultFixedFieldNames) {
    let schema = JSON.parse(window.ToJsonSchema(JSON.stringify(metaData)));
    schemaSetArrayFormat(schema, 'table');
    let defaultProperties = {
        title:       {
            type:          'string',
            propertyOrder: 100,
            options:       {
                hidden: false
            }
        },
        slug:        {
            type:          'string',
            propertyOrder: 100,
            readOnly:      true,
            options:       {
                hidden: false
            }
        },
        layout:      {
            type:          'string',
            propertyOrder: 100,
            options:       {
                hidden: true
            }
        },
        category:    {
            type:          'string',
            propertyOrder: 100,
            options:       {
                hidden: false
            }
        },
        tag:         {
            type:          'array',
            format:        'checkbox',
            propertyOrder: 100,
            uniqueItems:   true,
            items:         {
                type: 'string',
                enum: []
            }
        },
        date:        {
            type:          'string',
            format:        'datetime',
            propertyOrder: 100,
            options:       {
                hidden: false
            }
        },
        __content__: {
            type:          'string',
            format:        'text',
            propertyOrder: 100,
            options:       {
                hidden: true
            }
        },
        publishDate: {
            type:          'string',
            format:        'datetime',
            propertyOrder: 100,
            options:       {
                hidden: true
            }
        },
        draft:       {
            type:          'boolean',
            format:        'checkbox',
            propertyOrder: 100,
            options:       {
                hidden: true
            }
        }
    };

    // add propertyOrder to generated schema
    // console.log('schema.properties', schema.properties);
    for (let property in schema.properties) {
        if (!schema.properties.hasOwnProperty(property)) continue;
        schema.properties[property]['propertyOrder'] = 1000;
    }

    // merge default properties to
    // console.log('defaultProperties', defaultProperties);
    for (let property in defaultProperties) {
        if (!defaultProperties.hasOwnProperty(property)) continue;

        schema.properties[property] = defaultProperties[property];
    }

    return schema;
}

function getConfigFile(siteName, contentFilePath, layoutFilePath) {
    let name = Path.basename(layoutFilePath, Path.extname(layoutFilePath));
    let contentConfigFullPath = Path.join(sitesRoot, siteName, 'layout', name) + '.schema.json';

    // doc file content lay metaData
    let content = getContentFile(siteName, contentFilePath);
    // gen default config file and return
    // let contentConfig = genSimpleContentConfig(content.metaData, DefaultFixedFieldNames);

    if (fileExists(contentConfigFullPath)) {
        // doc va tra ve config, khong tu dong update merge
        let existsConfig = JSON.parse(Fs.readFileSync(contentConfigFullPath).toString());
        // code for old config type detect old config file by check _$schema key exists
        if (!existsConfig['_$schema']) {
            let contentConfig = genJsonSchemaContentConfig(content.metaData, DefaultFixedFieldNames);
            Fs.writeFileSync(contentConfigFullPath, JSON.stringify(contentConfig, null, 4));
            return contentConfig;
        }
        // let newConfig = mergeConfig(existsConfig, contentConfig);
        // console.log('write config file');
        // Fs.writeFileSync(contentConfigFullPath, JSON.stringify(newConfig, null, 4));
        return existsConfig;
    } else {
        let contentConfig = genJsonSchemaContentConfig(content.metaData, DefaultFixedFieldNames);
        Fs.writeFileSync(contentConfigFullPath, JSON.stringify(contentConfig, null, 4));
        return contentConfig;
    }
}

function createDefaultConfigFile(siteName, layoutFilePath) {
    let name = Path.basename(layoutFilePath, Path.extname(layoutFilePath));
    let contentConfigFullPath = Path.join(sitesRoot, siteName, 'layout', name) + '.schema.json';
    let contentConfig = genJsonSchemaContentConfig({}, DefaultFixedFieldNames);
    Fs.writeFileSync(contentConfigFullPath, JSON.stringify(contentConfig, null, 4));
    return contentConfig;
}

function readFile(site, filePath) {
    return Fs.readFileSync(Path.join(sitesRoot, site, filePath)).toString();
}

function getSiteList() {
    let ret = Fs.readdirSync(sitesRoot);
    let sites = [];
    for (let i = 0; i < ret.length; i++) {
        let sitePath = Path.join(sitesRoot, ret[i]);
        let stat = Fs.statSync(sitePath);
        if (stat.isDirectory()) {
            sites.push({name: ret[i]});
        }
    }
    return sites;
}

function saveConfigFile(siteName, layoutPath, contentConfig) {
    let name = Path.basename(layoutPath, Path.extname(layoutPath));
    let contentConfigFullPath = Path.join(sitesRoot, siteName, 'layout', name) + '.schema.json';
    Fs.writeFileSync(contentConfigFullPath, contentConfig);
}

function savePartialFile(siteName, partialName, content) {
    let partialFullPath = Path.join(sitesRoot, siteName, 'layout', 'partial', partialName) + '.html';
    Fs.writeFileSync(partialFullPath, content);
}

function getLayoutFile(siteName, filePath) {
    return Fs.readFileSync(Path.join(sitesRoot, siteName, 'layout', filePath)).toString();
}

function saveLayoutFile(siteName, filePath, content) {
    Fs.writeFileSync(Path.join(sitesRoot, siteName, 'layout', filePath), content);
}

function deleteFile(siteName, subFolder, filePath) {
    filePath = Path.normalize(filePath).replace(/^(\.\.[\/\\])+/, '');
    let fullPath = Path.join(sitesRoot, siteName, subFolder, filePath);
    return Fs.unlinkSync(fullPath);
}

function deleteLayoutFile(siteName, filePath) {
    return deleteFile(siteName, 'layout', filePath);
}

function deleteContentFile(siteName, filePath) {
    return deleteFile(siteName, 'content', filePath);
}

function softDeleteContentFile(siteName, filePath) {
    let contentFilePath = Path.join('content', filePath);
    // read content file
    let content = getContentFile(siteName, contentFilePath);
    // set layout -> delete.html
    content.metaData['layout'] = '404.html';
    // save file
    saveContentFile(siteName, contentFilePath, content.metaData, content.markDownData);
    // update memory index
    let metaData = siteContentIndexes[filePath];
    if (metaData instanceof Object)
        metaData['layout'] = '404.html';
}

function newLayoutFile(siteName, layoutFileName) {
    let defaultLayoutContent = ``;
    let fullPath = Path.join(sitesRoot, siteName, 'layout', layoutFileName);
    Fs.writeFileSync(fullPath, defaultLayoutContent, {flag: 'wx+'});
    let layoutFilePath = Path.join('layout', layoutFileName);
    return {name: layoutFileName, path: layoutFilePath.replace(/\\/g, '/')};
}

function newContentFile(siteName, layoutFileName, contentTitle, contentFileName, category, tag, isFrontPage) {
    // console.log('newContentFile', siteName, layoutFileName, contentFileName);
    let contentBaseName = Path.basename(contentFileName, Path.extname(contentFileName));
    let layoutBaseName = Path.basename(layoutFileName, Path.extname(layoutFileName));
    let slug = isFrontPage ? contentBaseName : layoutBaseName + '/' + contentBaseName;
    // let slug = contentBaseName;
    if (layoutFileName === '') layoutFileName = 'index.html';
    let defaultMeta = {
        "slug":        slug,
        "title":       contentTitle,
        "category":    category,
        "tag":         tag,
        "layout":      layoutFileName,
        "date":        getCurrentISODate(),
        "publishDate": getCurrentISODate(),
        "draft":       false
    };
    let defaultLayoutContent = `---json
${JSON.stringify(defaultMeta, null, 4)}
---
`;
    let layoutFolder = Path.basename(layoutFileName, Path.extname(layoutFileName));
    let newContentFilePath = isFrontPage ? Path.join('content', contentBaseName) + '.md' :
        Path.join('content', layoutFolder, contentBaseName) + '.md';
    let fullPath = Path.join(sitesRoot, siteName, newContentFilePath);

    // create folder for new content if not exists
    try {
        MkdirpSync(Path.join(sitesRoot, siteName, 'content', layoutFolder));
    } catch (_) {
    }
    console.log('Add new meta to IndexFile', newContentFilePath);

    let key = newContentFilePath.replace(/\\/g, '/');
    if (key.startsWith('content/')) key = key.slice(8);
    siteContentIndexes[key] = defaultMeta;
    Fs.writeFileSync(fullPath, defaultLayoutContent, {flag: 'wx+'});
    return {name: contentFileName, path: newContentFilePath.replace(/\\/g, '/')};
}

function MkdirpSync(p, opts, made) {
    let _0777 = parseInt('0777', 8);
    if (!opts || typeof opts !== 'object') {
        opts = {mode: opts};
    }

    let mode = opts.mode;
    let xfs = opts.fs || Fs;

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
                let stat;
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
    return new Promise((resolve, reject) => {
        let out = '';
        let env = opts.env ? opts.env : {};

        if (User.data && User.data.username) {
            console.log('set git user env');
            env.NAME = env.GIT_AUTHOR_NAME = env.GIT_COMMITTER_NAME = User.data.username;
            env.ENAIL = env.GIT_AUTHOR_EMAIL = env.GIT_COMMITTER_EMAIL = User.data.username + '@email.com';
        }

        let newProcess = ChildProcess.spawn(command, args, {
            env:   env,
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
            console.log(`Child exited with code ${code} output ${out}`);
            if (code === 0)
                resolve(out);
            else
                reject({code: code, message: out});
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

    let env = {
        'NODE_PATH': privateNodePath,
        'PATH':      ENV_PATH
    };

    return SpawnShell(command, args, {
        cwd:        cwd,
        onProgress: onProgress,
        env:        env
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
    return spawnGitCmd('git', ['clone', '-b', branch, '--single-branch', '--depth', '1', repositoryUrl, targetDir], '', onProgress).then(function () {
        return Fse.removeAsync(Path.join(targetDir, '.git'));
    });
}

function gitInitNewSiteRepository(targetDir, repositoryUrl) {
    return spawnGitCmd('git', ['init', '.'], targetDir).then(function () {
        return spawnGitCmd('git', ['remote', 'add', 'origin', repositoryUrl], targetDir).then(function () {
            return spawnGitCmd('git', ['add', '-A'], targetDir).then(function () {
                return spawnGitCmd('git', ['commit', '-m', '"init repository"'], targetDir);
            });
        });
    });
}

function gitCommit(siteName, message, onProgress) {
    const workingDirectory = Path.resolve(getSitePath(siteName));
    return spawnGitCmd('git', ['commit', '-am', message], workingDirectory, onProgress);
}

function gitGenMessage(siteName) {
    const workingDirectory = Path.resolve(getSitePath(siteName));
    return new Promise((resolve, reject) => {
        let output = '';
        return spawnGitCmd('git', ['status'], workingDirectory, function (data) {
            output += data + '\r\n';
        }).catch(ex => {
            reject(ex);
        }).then(() => {
            console.log('output', output);
            let match = output.match(/((new file:)|(deleted:)|(modified:))[\s\t]+(.+)/g);
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

function getCurrentISODate() {
    return (new Date()).toISOString();
}

function addMediaFile(siteName, filePath, cb) {
    let sitePath = getSitePath(siteName);
    // check if file already in site's asset folder
    let relativePath = Path.relative(sitePath, filePath);
    if (relativePath.startsWith('asset' + Path.sep)) {
        // file is in sites' asset folder
        relativePath = relativePath.substr(6); // remove "asset/"
        cb(null, relativePath.replace(/\\/g, '/'));
    } else {
        // copy file vo asset/img
        let fileName = filePath.split(/[\\\/]/).pop();
        let targetDir = Path.join(sitesRoot, siteName, 'asset', 'img');
        let target = Path.join(targetDir, fileName);
        MkdirpSync(targetDir);

        let cbCalled = false;
        let done = function (err, filePath) {
            if (!cbCalled) {
                if (err) cb(err);
                else cb(null, filePath);
                cbCalled = true;
            }
        };

        let rd = Fs.createReadStream(filePath);
        rd.on('error', done);

        let wr = Fs.createWriteStream(target);
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

/*
 * 'content/metadata/category/document.json' ->  category.document.meta-schema.json
 * 'content/metadata/footer.json' -> footer.meta-schema.json
 * */
function genMetaConfigFileName(contentMetaDataPath) {
    let parts = contentMetaDataPath.split('/');
    if (contentMetaDataPath.startsWith('content/metadata')) {
        parts.shift(); // remove 'content'
        parts.shift(); // remove 'metadata'
    }
    let ret = parts.join('.').replace(/\.[^/.]+$/, '');
    if (!ret.endsWith('.meta-schema'))
        ret += '.meta-schema.json';
    else
        ret += '.json';
    return ret;
}

function getMetaConfigFile(siteName, metaFilePath) {
    console.log('getMetaConfigFile', metaFilePath);
    let metaFileContent = readFile(siteName, metaFilePath);
    let metaData = JSON.parse(metaFileContent);
    let name = genMetaConfigFileName(metaFilePath);
    let configFullPath = Path.join(sitesRoot, siteName, 'layout', name);
    // let metaConfig = genSimpleContentConfig(metaData);

    if (fileExists(configFullPath)) {
        let existsConfig = JSON.parse(Fs.readFileSync(configFullPath).toString());
        // let newConfig = mergeConfig(existsConfig, metaConfig);
        // Fs.writeFileSync(configFullPath, JSON.stringify(newConfig, null, 4));
        // return newConfig;
        return existsConfig;
    } else {
        let metaConfig = genJsonSchemaMetaConfig(metaData);
        Fs.writeFileSync(configFullPath, JSON.stringify(metaConfig, null, 4));
        return metaConfig;
    }
}

function saveMetaFile(siteName, contentFilePath, metaData) {
    let fullPath = Path.join(sitesRoot, siteName, contentFilePath);
    Fs.writeFileSync(fullPath, JSON.stringify(metaData, null, 4));
}

function saveMetaConfigFile(siteName, metaFilePath, metaConfig) {
    // let name = Path.basename(metaFilePath, Path.extname(metaFilePath));
    let name = genMetaConfigFileName(metaFilePath);
    let configFullPath = Path.join(sitesRoot, siteName, 'layout', name);
    Fs.writeFileSync(configFullPath, metaConfig);
}

function isGhPageInitialized(siteName) {
    return spawnGitCmd('git', ['branch'], getSitePath(siteName)).then(data => {
        return data.indexOf('* gh-pages') !== -1;
    })
}

function setDomain(siteName, domain) {
    let fullPath = Path.join(sitesRoot, siteName, 'asset', 'CNAME');
    Fs.writeFileSync(fullPath, domain);
}

function getListConfig(dir) {
    try {
        let filePathList = Fs.readdirSync(dir);
        // console.log('filePathList', filePathList);
        let ret = [];
        filePathList.forEach(function (filePath) {
            // console.log('filePath', filePath);
            filePath = Path.join(dir, filePath);
            let stat = Fs.statSync(filePath);
            if (!stat.isFile()) return;
            let fileName = filePath.split(/[\\\/]/g).pop();
            let categoryValue = fileName.substr(0, fileName.lastIndexOf('.'));
            let config = JSON.parse(Fs.readFileSync(filePath));
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

let categoryListCache;
function getCategoryList(siteName) {
    console.log('getCategoryList', sitesRoot, siteName);
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
    let ret = [];
    let siteRoot = Path.join(sitesRoot, siteName);
    let filter = function (fileName, isDir) {
        if (isDir) return false; // no recursive
        if (fileName.endsWith('.category.html')) return false;
        if (fileName.endsWith('.tag.html')) return false;
        return true;
    };
    return scanDir(siteRoot, 'layout', ret, filter)
}

function newTag(siteName, tagName, tagFileName) {
    let defaultTagConfig = JSON.stringify({
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
    let fullPath = Path.join(sitesRoot, siteName, 'content', 'metadata', 'tag', tagFileName);
    Fs.writeFileSync(fullPath, defaultTagConfig, {flag: 'wx+'});
    let categoryFilePath = Path.join('content', 'metadata', 'category', tagFileName);
    return {name: tagName, path: categoryFilePath.replace(/\\/g, '/')};
}

function newCategory(siteName, categoryName, categoryFileName) {
    let defaultCategoryConfig = JSON.stringify({
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
    let fullPath = Path.join(sitesRoot, siteName, 'content', 'metadata', 'category', categoryFileName);
    Fs.writeFileSync(fullPath, defaultCategoryConfig, {flag: 'wx+'});
    let categoryFilePath = Path.join('content', 'metadata', 'category', categoryFileName);
    return {name: categoryName, path: categoryFilePath.replace(/\\/g, '/')};
}

function filterOnlyMetadataFile(name, isDir) {
    if (isDir) {
        return true;
    } else {
        let ext = name.split('.').pop();
        if (ext !== 'json') return false;
    }
    return true;
}

function getSiteMetadataFiles(siteName) {
    let siteRoot = Path.join(sitesRoot, siteName);
    let folders = ['content/metadata'];
    let files = [];
    for (let folder of folders) {
        ScanDir(siteRoot, Path.join(sitesRoot, siteName, folder), files, filterOnlyMetadataFile);
    }
    return files;
}

function showItemInFolder(siteName, filePath) {
    Shell.showItemInFolder(Path.join(sitesRoot, siteName, filePath));
}

let createSiteIndex = Promise.coroutine(function*(siteName) {
    let siteContentPath = Path.join(sitesRoot, siteName, 'content');
    let contents = {};

    let readContentFiles = Promise.coroutine(function*(root, dir) {
        let searchPath = Path.join(root, dir);
        let files = yield Fs.readdirAsync(searchPath);
        yield Promise.map(files, Promise.coroutine(function *(file) {
            let filePath = Path.join(root, dir, file);
            // console.log('filePath', filePath);
            let stat = yield Fs.statAsync(filePath);
            if (stat.isFile()) {
                if (!file.endsWith('.md')) return;
                let content = (yield Fs.readFileAsync(filePath)).toString();
                content = SplitContentFile(content);
                content.metaData['__content__'] = content.markDownData;
                contents[dir === '' ? file : `${dir}/${file}`] = content.metaData;
            } else if (stat.isDirectory()) {
                // support recursive content
                yield readContentFiles(siteContentPath, dir === '' ? file : `${dir}/${file}`);
            }
        }), {concurrency: 3});
    });

    yield readContentFiles(siteContentPath, '');

    let readMetaFile = Promise.coroutine(function*(searchPath, ret) {
        try {
            let files = yield Fs.readdirAsync(searchPath);
            yield Promise.map(files, Promise.coroutine(function *(fileName) {
                let filePath = Path.join(searchPath, fileName);
                let stat = yield Fs.statAsync(filePath);
                if (!stat.isFile()) return;
                if (!filePath.endsWith('.json')) return;
                let content = (yield Fs.readFileAsync(filePath)).toString();
                let meta = JSON.parse(content);
                let parts = fileName.split('.');
                parts.pop(); // remove .json
                let key = parts.join('.');
                ret[key] = meta;

            }));
        } catch (ex) {
            console.log('read meta file for index error', ex);
        }
    });

    let readPartialFile = Promise.coroutine(function*(searchPath, ret) {
        try {
            let files = yield Fs.readdirAsync(searchPath);
            yield Promise.map(files, Promise.coroutine(function *(fileName) {
                let filePath = Path.join(searchPath, fileName);
                let stat = yield Fs.statAsync(filePath);
                if (!stat.isFile()) return;
                let parts = fileName.split('.');
                let ext = parts.pop(); // remove extension;
                if (ext !== 'html') return;
                ret[parts.join('.')] = true;
            }));
        } catch (ex) {
            console.log('read meta file for index error', ex);
        }
    });

    let readConfigFile = Promise.coroutine(function*(searchPath, contentConfig, globalConfig, metaConfig) {
        try {
            let files = yield Fs.readdirAsync(searchPath);

            yield Promise.map(files, Promise.coroutine(function *(fileName) {
                let filePath = Path.join(searchPath, fileName);
                if (!fileName.endsWith('.json')) return;
                let stat = yield Fs.statAsync(filePath);
                if (!stat.isFile()) return;

                let content = (yield Fs.readFileAsync(filePath)).toString();
                let meta;
                try {
                    meta = JSON.parse(content);
                } catch (ex) {
                    console.log('parse config file json failed, file', filePath);
                    return;
                }

                if (fileName.endsWith('.meta-schema.json')) {
                    if (fileName.startsWith('category.') || fileName.startsWith('tag.')) {
                        metaConfig[fileName] = meta;
                    } else {
                        globalConfig[fileName] = meta;
                    }
                } else if (fileName.endsWith('.schema.json')) {
                    contentConfig[fileName] = meta;
                }
            }));
        } catch (ex) {
            console.log('read config file for index error', ex);
        }
    });

    let metaCategory = {}; // { categoryFileName without .json : metadata }
    yield readMetaFile(Path.join(sitesRoot, siteName, 'content', 'metadata', 'category'), metaCategory);

    let metaGlobal = {};
    yield readMetaFile(Path.join(sitesRoot, siteName, 'content', 'metadata'), metaGlobal);

    let metaTag = {};
    yield readMetaFile(Path.join(sitesRoot, siteName, 'content', 'metadata', 'tag'), metaTag);

    let partials = {};
    yield readPartialFile(Path.join(sitesRoot, siteName, 'layout', 'partial'), partials);

    // read meta config
    // category meta config category.document.content.meta-schema.json
    // global meta config menu.meta-schema.json
    // content config Huong-Dan.schema.json
    let contentConfig = {};
    let globalConfig = {};
    let metaConfig = {};
    yield readConfigFile(Path.join(sitesRoot, siteName, 'layout'), contentConfig, globalConfig, metaConfig);
    // debugger;
    return {
        contents:      contents,
        categories:    metaCategory,
        global:        metaGlobal,
        tags:          metaTag,
        partials:      partials,
        contentConfig: contentConfig,
        globalConfig:  globalConfig,
        metaConfig:    metaConfig,
    };
});

const deleteAllExcept = Promise.coroutine(function*(targetDir, excepts) {
    let names = yield Fse.readdirAsync(targetDir);
    if (typeof(excepts) === 'string') excepts = [excepts];
    names.forEach(Promise.coroutine(function*(name) {
        // delete if not in excepts list
        if (excepts.indexOf(name) === -1) {
            console.log('deleteAllExcept remove', Path.join(targetDir, name));
            yield Fse.removeAsync(Path.join(targetDir, name));
        }
    }))
});

function gitCheckOutSkeleton(repositoryUrl, branch, targetDir, onProgress) {
    // clone project skeleton
    return spawnGitCmd('git', ['clone', '-b', branch, '--single-branch', '--depth', '1', repositoryUrl, targetDir], '', onProgress).then(function () {
        // delete .git
        return Fse.removeAsync(Path.join(targetDir, '.git'));
    });
}

const initNewSiteRootFolder = Promise.coroutine(function*(repositoryUrl, targetDir) {
    // init repos
    yield spawnGitCmd('git', ['init', '.'], targetDir);
    // add .gitignore (ingore build + node_modules)
    yield Fs.writeFileAsync(Path.join(targetDir, '.gitignore'), `build/\r\nnode_modules/\r\n`);

    yield spawnGitCmd('git', ['add', '.'], targetDir);
    // set remote gogs repo
    yield spawnGitCmd('git', ['remote', 'add', 'origin', repositoryUrl], targetDir);
    // commit
    yield spawnGitCmd('git', ['commit', '-m"init root"'], targetDir);
    // push
    yield spawnGitCmd('git', ['push', 'origin', 'master'], targetDir);
});

const initNewSiteBuildFolder = Promise.coroutine(function*(repositoryUrl, targetDir) {
    let buildFolderPath = Path.join(targetDir, 'build');

    // remove build dir if exsits
    try {
        yield Fse.removeAsync(buildFolderPath);
    } catch (ex) {
        console.log('remove build folder failed', ex);
    }

    try {
        // create build folder
        yield Fse.mkdirAsync(buildFolderPath);

        // git clone gogs repo
        yield spawnGitCmd('git', ['clone', repositoryUrl, buildFolderPath]);

        // in build folder delete all except .git folder
        yield deleteAllExcept(buildFolderPath, '.git');

        // git checkout --orphan gh-pages
        yield spawnGitCmd('git', ['checkout', '--orphan', 'gh-pages'], buildFolderPath);

        console.log('create empty index.html');
        yield Fse.writeFileAsync(Path.join(buildFolderPath, 'index.html'), '');

        console.log('add index.html to git');
        yield spawnGitCmd('git', ['add', 'index.html'], buildFolderPath);

        console.log('commit');
        yield spawnGitCmd('git', ['commit', '-m"init build"'], buildFolderPath);

        // git push --set-upstream origin gh-pages
        yield spawnGitCmd('git', ['push', '--set-upstream', 'origin', 'gh-pages'], buildFolderPath);

        // delete master branch
        yield spawnGitCmd('git', ['branch', '-d', 'master'], buildFolderPath);
        console.log('DONE');
        // push
        // yield spawnGitCmd('git', ['push', 'origin', 'gh-pages'], targetDir);
    } catch (ex) {
        console.log('Init new site failed, error', ex);
    }
});


module.exports = {
    gitCheckOutSkeleton:      gitCheckOutSkeleton,
    initNewSiteRootFolder:    initNewSiteRootFolder,
    initNewSiteBuildFolder:   initNewSiteBuildFolder,
    createSiteIndex:          createSiteIndex,
    genSimpleContentConfig:   genSimpleContentConfig,
    getDefaultContentConfig:  getDefaultContentConfig,
    showItemInFolder:         showItemInFolder,
    fileExists:               fileExists,
    newCategory:              newCategory,
    getCategoryLayoutList:    getCategoryLayoutList,
    getCategoryList:          getCategoryList,
    purgeCategoryListCache:   purgeCategoryListCache,
    newTag:                   newTag,
    getTagList:               getTagList,
    getMetaFile:              getMetaFile,
    getSiteMetadataFiles:     getSiteMetadataFiles,
    createDefaultConfigFile:  createDefaultConfigFile,
    getMetaConfigFile:        getMetaConfigFile,
    saveMetaFile:             saveMetaFile,
    saveMetaConfigFile:       saveMetaConfigFile,
    createSiteFolder:         createSiteFolder,
    getSiteList:              getSiteList,
    getConfigFile:            getConfigFile,
    saveConfigFile:           saveConfigFile,
    savePartialFile:          savePartialFile,
    getRawContentFile:        getRawContentFile,
    getContentFile:           getContentFile,
    saveContentFile:          saveContentFile,
    saveRawContentFile:       saveRawContentFile,
    getLayoutFile:            getLayoutFile,
    saveLayoutFile:           saveLayoutFile,
    deleteLayoutFile:         deleteLayoutFile,
    deleteContentFile:        deleteContentFile,
    softDeleteContentFile:    softDeleteContentFile,
    getLayoutList:            getLayoutList,
    getRootLayoutList:        getRootLayoutList,
    newLayoutFile:            newLayoutFile,
    gitAdd:                   gitAdd,
    newContentFile:           newContentFile,
    gitCheckout:              gitCheckout,
    gitInitSite:              gitInitSite,
    gitGenMessage:            gitGenMessage,
    gitImportGitHub:          gitImportGitHub,
    gitInitNewSiteRepository: gitInitNewSiteRepository,
    gitCommit:                gitCommit,
    gitPushGhPages:           gitPushGhPages,
    gitPushGitHub:            gitPushGitHub,
    getSiteLayoutFiles:       getSiteLayoutFiles,
    getSiteAssetFiles:        getSiteAssetFiles,
    getSiteContentFiles:      getSiteContentFiles,
    readFile:                 readFile,
    addMediaFile:             addMediaFile,
    isGhPageInitialized:      isGhPageInitialized,
    setDomain:                setDomain
};
