'use strict';

let Fs = require('fs');
let Path = require('path');

const ignoreName = ['.git', '__PUBLIC', '.gitignore', '.gitkeep'];
const ignoreExt = ['.config.json'];
const appRoot = Path.resolve(__dirname, '../../');
const sitesRoot = Path.resolve(__dirname, '../../sites');

let ScanDir = function (siteRoot, dir, ret) {
    for (var name of Fs.readdirSync(dir)) {
        if (ignoreName.indexOf(name) != -1) continue;
        if (ignoreExt.indexOf(Path.extname(name)) != -1) continue;
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
                    type:        'Text',
                    validations: [],
                    required:    false
                });
                break;
            case 'number':
                contentConfig.push({
                    name:        key,
                    type:        'Number',
                    validations: [],
                    required:    false
                });
                break;
            case 'boolean':
                contentConfig.push({
                    name:        key,
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

function getConfigFile(siteName, contentFilePath, layoutFilePath) {
    var name = Path.basename(layoutFilePath, Path.extname(layoutFilePath));
    var contentConfigFullPath = Path.join(sitesRoot, siteName, 'layout', name) + '.config.json';
    console.log('fullPath', contentConfigFullPath);

    if (fileExists(contentConfigFullPath)) {
        // read and return config file
        return JSON.parse(Fs.readFileSync(contentConfigFullPath).toString());
    } else {
        // doc file content lay metaData
        var content = getContentFile(siteName, contentFilePath);
        // gen default config file and return
        var contentConfig = genSimpleContentConfigFile(content.metaData);
        Fs.writeFileSync(contentConfigFullPath, JSON.stringify(contentConfig, null, 4));
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

module.exports = {
    getSiteList:    getSiteList,
    getSiteFiles:   getSiteFiles,
    getConfigFile:  getConfigFile,
    getContentFile: getContentFile,
    readFile:       readFile
};
