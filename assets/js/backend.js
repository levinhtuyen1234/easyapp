'use strict';

let Fs = require('fs');
let Path = require('path');

const ignoreName = ['.git', '__PUBLIC', '.gitignore', '.gitkeep'];
const ignoreExt = ['.config.json', '.html'];
const appRoot = Path.resolve(__dirname, '../../');
const sitesRoot = Path.resolve(__dirname, '../../sites');

function IsIgnoreFile(name) {
    if (ignoreName.indexOf(name) != -1) return true;
    for (var i = 0; i < ignoreExt.length; i++) {
        if (name.endsWith(ignoreExt[i]))
            return true;
    }
    return false;
}

let ScanDir = function (siteRoot, dir, ret) {
    for (var name of Fs.readdirSync(dir)) {
        if (IsIgnoreFile(name)) continue;
        var fullPath = Path.join(dir, name);
        var stat = Fs.statSync(fullPath);

        if (stat.isDirectory()) {
            ScanDir(siteRoot, fullPath, ret);
        } else {
            ret.push({name: name, path: Path.relative(siteRoot, fullPath)});
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
    var content = readFile(siteName, contentFilePath).trim();
    // split content thanh metaData va markdownData
    return SplitContentFile(content);
}

function saveContentFile(siteName, contentFilePath, metaData, markdownData) {
    var fullPath = Path.join(sitesRoot, siteName, contentFilePath);
    var content = `---json\r\n${JSON.stringify(metaData, null, 4)}\r\n---\r\n${markdownData}`;
    Fs.writeFileSync(fullPath, content);
}

function getConfigFile(siteName, contentFilePath, layoutFilePath) {
    var name = Path.basename(layoutFilePath, Path.extname(layoutFilePath));
    var contentConfigFullPath = Path.join(sitesRoot, siteName, 'layout', name) + '.config.json';

    if (fileExists(contentConfigFullPath)) {
        // read and return config file
        return JSON.parse(Fs.readFileSync(contentConfigFullPath).toString());
    } else {
        // doc file content lay metaData
        var content = getContentFile(siteName, contentFilePath);
        // gen default config file and return
        var contentConfig = genSimpleContentConfigFile(content.metaData);
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
    var filePath = Path.normalize(filePath).replace(/^(\.\.[\/\\])+/, '');
    var fullPath = Path.join(sitesRoot, siteName, subFolder, filePath);
    return Fs.unlinkSync(fullPath);
}

function deleteLayoutFile(siteName, filePath) {
    return deleteFile(siteName, 'layout', filePath);
}

function deleteContentFile(siteName, filePath) {
    return deleteFile(siteName, 'content', filePath);
}

module.exports = {
    getSiteList:       getSiteList,
    getSiteFiles:      getSiteFiles,
    getConfigFile:     getConfigFile,
    saveConfigFile:    saveConfigFile,
    getContentFile:    getContentFile,
    saveContentFile:   saveContentFile,
    getLayoutFile:     getLayoutFile,
    saveLayoutFile:    saveLayoutFile,
    deleteLayoutFile:  deleteLayoutFile,
    deleteContentFile: deleteContentFile,
    readFile:          readFile
};
