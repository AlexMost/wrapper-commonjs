(function() {
  var cache, diranme, expand, modules, partial, require;

  if (!this.require) {
    modules = {};
    cache = {};
    partial = function(fn) {
      var partial_args;
      partial_args = Array.prototype.slice.call(arguments);
      partial_args.shift();
      return function() {
        var a, arg, i, new_args, _i, _len, _ref;
        _ref = [[], 0], new_args = _ref[0], arg = _ref[1];
        for (i = _i = 0, _len = partial_args.length; _i < _len; i = ++_i) {
          a = partial_args[i];
          if (partial_args[i] === void 0) {
            new_args.push(arguments[arg++]);
          } else {
            new_args.push(partial_args[i]);
          }
        }
        return fn.apply(this, new_args);
      };
    };
    require = function(name, root, ns) {
      var fn, module, path;
      if ((ns != null) && !((expand(root, name)) in modules)) {
        name = "" + ns + "/" + (expand('', name));
      }
      path = expand(root, name);
      module = cache[path];
      if (module) {
        return module.exports;
      } else if (fn = modules[path] || modules[path = expand(path, './index')]) {
        module = {
          id: path,
          exports: {}
        };
        try {
          cache[path] = module;
          fn(module.exports, module);
          return module.exports;
        } catch (e) {
          delete cache[path];
          throw e;
        }
      } else {
        throw "module '" + name + "' is not found";
      }
    };
    expand = function(root, name) {
      var i, part, parts, results, _i, _ref;
      results = [];
      if (/^\.\.?(\/|$)/.test(name)) {
        parts = [root, name].join('/').split('/');
      } else {
        parts = name.split('/');
      }
      for (i = _i = 0, _ref = parts.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        part = parts[i];
        if (part === '..') {
          results.pop();
        } else if (part !== '.' && part !== '') {
          results.push(part);
        }
      }
      return results.join('/');
    };
    diranme = function(path) {
      return path.split('/').slice(0).join('/');
    };
    this.require = function(name) {
      return require(name, '');
    };
    this.require.define = function(ns, bundle) {
      var key, value, _key, _require;
      _require = partial(require, void 0, void 0, ns);
      for (key in bundle) {
        value = bundle[key];
        _key = ns ? "" + ns + "/" + key : key;
        modules[_key] = partial(value, void 0, _require, void 0);
        void 0;
      }
      for (key in bundle) {
        value = bundle[key];
        _key = ns ? "" + ns + "/" + key : key;
        modules[_key]({}, {});
        void 0;
      }
      return void 0;
    };
  }

}).call(this);

require.define('mod2', {
'index': function(exports, require, module) {(function() {
console.log('index mod2 initialized');

module.exports = {module2: 'index'}
}).call(this);},
'module2': function(exports, require, module) {(function() {
console.log('module1 initialized');

module.exports = {module2:'module2'}
}).call(this);}
});


require.define('mod1', {
'index': function(exports, require, module) {(function() {
console.log('index mod1 initialized');

m1 = require('module1');

console.log(m1);
m2 = require('mod2/module2');

module.exports = {module1: 'index'}
}).call(this);},
'module1': function(exports, require, module) {(function() {
console.log('module1 initialized');

module.exports = {module1:'module1'}
}).call(this);}
});

