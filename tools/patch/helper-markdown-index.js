/*!
 * helper-markdown <https://github.com/jonschlinkert/helper-markdown>
 *
 * Copyright (c) 2014 Jon Schlinkert, contributors.
 * Licensed under the MIT license.
 */

'use strict';

var isObject = require('isobject');
var Remarkable = require('remarkable');
var merge = require('mixin-deep');

module.exports = function markdown(config) {
  var configType = typeof(config);
  //if (configType === 'undefined')
    //return '';
  if (configType === 'string') {
    return helper.apply(this, arguments);
  }

  config = config || {};
  if (config.fn || config.hash || arguments.length > 1) {
    return helper.apply(this, arguments);
  }

  function helper(context, options) {    
    var contextType = typeof(context);
    if (contextType === 'undefined') {
	    return '';		
    }
      
    if (contextType === 'string') {
      var opts = merge({}, config, options);
      var md = new Remarkable(opts);
      return md.render(context);
    }

    if (isObject(context) && typeof context.fn === 'function') {
      options = context;
      context = {};
    }

    options = merge({ html: true, breaks: true }, config, options);
    options = merge({}, options, options.markdown, options.hash);
    if (options.hasOwnProperty('lang')) {
      options.langPrefix = options.lang;
    }

    var md = new Remarkable(options);
    var ctx = merge({}, options, this.context, context);
    console.log('options.fn', options.fn);
    return md.render(options.fn(ctx));
  }

  return helper;
};
