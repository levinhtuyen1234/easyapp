var path = require('path');
var fs = require('fs');
var toFn = require('to-function');
var extend = require('xtend');
var loadMetadata = require('read-metadata').sync;

var DEFAULTS = {
    "sortBy": "date",
    "reverse": false,
    "metadata": {},
    "tag": "tag",
    "displayName": "Tag",
    "perPage": 10,
    "noPageOne": true,
    "pageContents": new Buffer(''),
    "layout": "default.tag.html",
    "first": "tag/:tag/index.html",
    "path": "tag/:tag/page/:num/index.html"
}

function existsSync(filePath) {
    try {
        fs.statSync(filePath);
    } catch (err) {
        if (err.code == 'ENOENT') return false;
    }
    return true;
};

/**
 * Interpolate the page path with pagination variables.
 *
 * @param  {String} path
 * @param  {Object} data
 * @return {String}
 */
function interpolate(path, data) {
    return path.replace(/:(\w+)/g, function (match, param) {
        return data[param]
    })
}

/**
 * Group by pagination by default.
 *
 * @param  {Object} file
 * @param  {number} index
 * @param  {Object} options
 * @return {number}
 */
function groupByPagination(file, index, options) {
    return Math.ceil((index + 1) / options.perPage)
}

/**
 * Create a "get pages" utility for people to use when rendering.
 *
 * @param  {Array}    pages
 * @param  {number}   index
 * @return {Function}
 */
function createPagesUtility(pages, index) {
    return function getPages(number) {
        var offset = Math.floor(number / 2)
        var start, end

        if (index + offset >= pages.length) {
            start = Math.max(0, pages.length - number)
            end = pages.length
        } else {
            start = Math.max(0, index - offset)
            end = Math.min(start + number, pages.length)
        }

        return pages.slice(start, end)
    }
}

function trimPermanentLink(href) {
    if (href.endsWith('/index.html'))
        return href.slice(0, -11);
    return href;
}

function paginate(files, metalsmith, done, tagOption) {
    var metadata = metalsmith.metadata();
    // Iterate over all the paginate names and match with collections.
    var complete = Object.keys(metadata.AllTag).every(function (name) {
        var collection;

        // Catch nested collection reference errors.
        //try {
        //    collection = toFn(name)(metadata)
        //} catch (error) { }
        collection = metadata.AllTag[name];

        if (!collection) {
            done(new TypeError('Collection not found (' + name + ')'))

            return false
        }

        // ignore tag collection that has no config file
        if (!tagOption[name]) {
            console.log('skip tag don\'t have config', name);
            return true; // skip array don't have config options
        }

        var pageOptions = extend(DEFAULTS, tagOption[name]);
        var tagName = name;
        var toShow = collection.files;
        var groupBy = toFn(pageOptions.groupBy || groupByPagination);

        if (pageOptions.filter) {
            toShow = collection.files.filter(toFn(pageOptions.filter))
        }

        if (!pageOptions.template && !pageOptions.layout) {
            done(new TypeError('A template or layout is required (' + name + ')'))

            return false
        }

        if (pageOptions.template && pageOptions.layout) {
            done(new TypeError(
                'Template and layout can not be used simultaneosly (' + name + ')'
            ))

            return false
        }

        if (!pageOptions.path) {
            done(new TypeError('The path is required (' + name + ')'))

            return false
        }

        // Can't specify both
        if (pageOptions.noPageOne && !pageOptions.first) {
            done(new TypeError(
                'When `noPageOne` is enabled, a first page must be set (' + name + ')'
            ))

            return false
        }

        // Put a `pages` property on the original collection.
        var pages = collection.pages = []
        var pageMap = {}

        // Sort pages into "tags".
        toShow.forEach(function (file, index) {
            var name = String(groupBy(file, index, pageOptions))

            // Keep pages in the order they are returned. E.g. Allows sorting
            // by published year to work.
            if (!pageMap.hasOwnProperty(name)) {
                // Use the index to calculate pagination, page numbers, etc.
                var length = pages.length

                var pagination = {
                    name: name,
                    tag: tagName,
                    displayName: pageOptions.displayName,
                    index: length,
                    num: length + 1,
                    pages: pages,
                    files: [],
                    getPages: createPagesUtility(pages, length)
                }

                var pagePath = interpolate(pageOptions.path, pagination);
                // Generate the page data.
                var page = extend(pageOptions.pageMetadata, {
                    template: pageOptions.template,
                    layout: pageOptions.layout,
                    contents: pageOptions.pageContents,
                    href: trimPermanentLink(pagePath),
                    path: pagePath,
                    metadata: pageOptions.metadata || {},
                    pagination: pagination,
                    AllTag: metadata.AllTag
                })

                // Copy collection metadata onto every page "collection".
                pagination.files.metadata = collection.metadata

                if (length === 0) {
                    if (!pageOptions.noPageOne) {
                        files[page.path] = page
                    }

                    if (pageOptions.first) {
                        // Extend the "first page" over the top of "page one".
                        page = extend(page, {
                            path: interpolate(pageOptions.first, page.pagination)
                        })

                        files[page.path] = page
                    }
                } else {
                    files[page.path] = page

                    page.pagination.previous = pages[length - 1]
                    pages[length - 1].pagination.next = page
                }

                pages.push(page)
                pageMap[name] = pagination
            }

            // Files are kept sorted within their own tag.
            pageMap[name].files.push(file)
        })

        // Add page utilities.
        pages.forEach(function (page, index) {
            page.pagination.first = pages[0]
            page.pagination.last = pages[pages.length - 1]
        })

        return true
    })

    return complete && done();
}

module.exports = function (opts) {
    return function (files, metalsmith, done) {
        var metadata = metalsmith.metadata();
        var tag = {};
        var tagOption = {};

        metadata.AllTag = tag;

        // doc tag options from opts.directory
        if (opts.directory) {
            try {
                var configfiles = fs.readdirSync(opts.directory);
                configfiles.forEach(function (filePath) {
                    var fullPath = path.join(opts.directory, filePath);
                    var stat = fs.statSync(fullPath);
                    if (!stat.isFile()) return;
                    var key = filePath.substr(0, filePath.lastIndexOf('.')); // remove '.json'
                    tagOption[key] = loadMetadata(fullPath);
                });

                // normalize tag options
                /*
                var keys = [];
                for (var key in tagOption) {
                    if (!tagOption.hasOwnProperty(key)) continue;
                    keys.push(key);
                }

                keys.sort();

                for (var key in tagOption) {
                    var terms = key.split('.');
                    terms.pop(); // remove last tag chunk (already had options)
                    for (var i = 0; i < terms.length; i++) {
                        var checkKey = terms.slice(0, i + 1).join('.');
                        var option = tagOption[checkKey];
                        if (option) continue;
                        if (i === 0) {
                            tagOption[checkKey] = tagOption['default'];
                        } else {
                            tagOption[checkKey] = tagOption[terms.slice(0, i).join('.')];
                        }
                    }
                }
                */
            } catch (ex) {
            }
        }

        var tagFilePrefix = 'metadata' + path.sep + 'tag' + path.sep;
        var metadataFilePrefix = 'metadata' + path.sep;

        // only process file has tag metadata
        for (var filePath in files) {
            if (!files.hasOwnProperty(filePath))
                continue;

            // remove tag file from metalsmith's files
            if (filePath.startsWith(tagFilePrefix)) {
                delete files[filePath];
                continue;
            }

            // remove metadata file, this plugin must after metalsmith-category
            // TODO this should not in this module
            if (filePath.startsWith(metadataFilePrefix)) {
                delete files[filePath];
                continue;
            }

            var data = files[filePath];
            filePath = filePath.replace(/\\/g, '/'); // replace all \ with /

            // add all content file to flat map
            if (!data.tag || !Array.isArray(data.tag))
                continue; // skip file with no tag in metadata or tag is not array

            data.path = filePath // add them path property
            // add file vo cac tag array tuong ung
            data.tag.forEach(function (tagName) {
                tag[tagName] = tag[tagName] || { files: [] };
                tag[tagName].files.push(data);
            });
        }

        // sort tag
        for (var key in tag) {
            var settings = tagOption[key];
            tag[key]['AllTag'] = tag;
            if (!settings)
                settings = tagOption['default'];

            for (var settingKey in settings) {
                if (!settings.hasOwnProperty(settingKey)) continue;
                if (settingKey === 'files') continue;
                if (settingKey === 'href') continue;
                tag[key][settingKey] = settings[settingKey];
            }
            tag[key]['tag'] = key;
            // href property
            tag[key].tagPath = key.replace(/\./g, '/');
            tag[key].href = trimPermanentLink(interpolate(settings.first, tag[key]));

            var sort = settings.sortBy || 'date';
            var col = tag[key].files;

            if ('function' == typeof sort) {
                col.sort(sort);
            } else {
                col.sort(function (a, b) {
                    a = a[sort];
                    b = b[sort];
                    if (!a && !b) return 0;
                    if (!a) return -1;
                    if (!b) return 1;
                    if (b > a) return -1;
                    if (a > b) return 1;
                    return 0;
                });
            }

            if (settings.reverse) col.reverse();
        }

        return paginate(files, metalsmith, done, tagOption);
    }
}