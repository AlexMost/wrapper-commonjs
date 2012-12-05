
(function(/*! Stitch !*/) {
  if (!this.require) {
    var modules = {}, cache = {}, require = function(name, root) {
      var path = expand(root, name), module = cache[path], fn;
      if (module) {
        return module.exports;
      } else if (fn = modules[path] || modules[path = expand(path, './index')]) {
        module = {id: path, exports: {}};
        try {
          cache[path] = module;
          fn(module.exports, function(name) {
            return require(name, dirname(path));
          }, module);
          return module.exports;
        } catch (err) {
          delete cache[path];
          throw err;
        }
      } else {
        throw 'module \'' + name + '\' not found';
      }
    }, expand = function(root, name) {
      var results = [], parts, part;
      if (/^\.\.?(\/|$)/.test(name)) {
        parts = [root, name].join('/').split('/');
      } else {
        parts = name.split('/');
      }
      for (var i = 0, length = parts.length; i < length; i++) {
        part = parts[i];
        if (part == '..') {
          results.pop();
        } else if (part != '.' && part != '') {
          results.push(part);
        }
      }
      return results.join('/');
    }, dirname = function(path) {
      return path.split('/').slice(0, -1).join('/');
    };
    this.require = function(name) {
      return require(name, '');
    }
    this.require.define = function(bundle) {
      for (var key in bundle)
        modules[key] = bundle[key];
      for(var key in bundle){
        var mod = {};
        bundle[key]({}, require, mod)
        if(mod.hasOwnProperty('load_time_exports'))
            mod.load_time_exports(this)
        }
    };
  }
  return this.require.define;
}).call(this)({"index": function(exports, require, module) {(function() {

  "Simple common js module";

  var m2, module;

  m2 = require('./module2');

  console.log(m2);

  module = function() {
    return typeof console !== "undefined" && console !== null ? console.log("mod2 index initialized") : void 0;
  };

  module.exports = module;

}).call(this);
}, "module2": function(exports, require, module) {(function() {

  "Simple common js module";

  var module;

  module = function() {
    return typeof console !== "undefined" && console !== null ? console.log("mod2 initialized") : void 0;
  };

  module.exports = {
    one: function() {},
    two: function() {}
  };

}).call(this);
}});
