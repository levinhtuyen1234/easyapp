module.exports = plugin;

const fs = require('fs');

const defaultOptions = {
  ref: 'filePath',
  fields: '*'
}

/*
  {
    fields: '*'
    fields: ['title', 'description']
    indexPath: 'contentIndex.json'
  }
*/

function writeIndexes(files, options) {
  if (!options.ref)
    options.ref = 'filePath';
  if (!options.indexPath) return;
  let stream = fs.createWriteStream(options.indexPath, {
    flags: 'w+',
    defaultEncoding: 'utf8',
    fd: null,
    autoClose: true
  });
  // console.log('write start json')
  stream.write('{\r\n');

  let isFirst = true;
  let propProcessor;
  if (options.fields === '*') {
    propProcessor = function (obj) {
      let props = Object.assign({}, obj);
      //delete props['contents'];
      delete props['stats'];
      delete props['mode'];
      return props;
    }
  } else if (Array.isArray(options.fields)) {
    // remove fields stats, mode from options.fields
    //if (options.fields.indexOf('contents') != -1) options.fields.splice(options.fields.indexOf('contents'), 1);
    if (options.fields.indexOf('stats') != -1) options.fields.splice(options.fields.indexOf('stats'), 1);
    if (options.fields.indexOf('mode') != -1) options.fields.splice(options.fields.indexOf('mode'), 1);
    propProcessor = function (obj) {
      let props = {};
      options.fields.forEach(function (field) {
        props[field] = obj[field];
      });
      return props;
    }
  }
  for (filePath in files) {
    if (!files.hasOwnProperty(filePath)) continue;
    if (!isFirst) {
      //console.log('write sep end prop');
      stream.write(',\r\n');
    }

    isFirst = false;

    let content = files[filePath];
    // console.log('write key', filePath)
    if (options.ref === 'filePath') {
      stream.write(`"${filePath.replace('.html', '')}": `);
    } else {
      stream.write(`"${content[options.ref]}": `);
    }

    let indexContent = propProcessor(content);
    // console.log('write value')
    stream.write(JSON.stringify(indexContent));
  }
  // console.log('write end json')
  stream.write('\r\n}\r\n');
  stream.end();
}

function plugin(options) {
  options = options || [];
  if (typeof options === 'object' && !Array.isArray(options)) {
    options = [options];
  }
  return function (files, metalsmith, done) {
    options.forEach(function (opts) {
      writeIndexes(files, opts);
    });

    done();
  };
};
