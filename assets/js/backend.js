'use strict';

let Fs = require('fs');
let Path = require('path');

var ignoreName = ['.git', '__PUBLIC', '.gitignore', '.gitkeep'];

let ScanDir = function (dir, ret) {
    for (var name of Fs.readdirSync(dir)) {
        if (ignoreName.indexOf(name) != -1) continue;
        var fullPath = Path.join(dir, name);
        var stat = Fs.statSync(fullPath);

        if (stat.isDirectory()) {
            ScanDir(fullPath, ret);
        } else {
            ret.push({name: name, path: fullPath});
        }
    }
    return ret;
};

function getSiteFiles(siteDir) {
    var folders = ['content', 'layout'];
    var files = [];
    for (var folder of folders) {
        ScanDir(Path.join(siteDir, folder), files);
    }
    return files;
}

module.exports = {
    getSiteFiles: getSiteFiles
};
