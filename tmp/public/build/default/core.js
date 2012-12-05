/* Cafe 960d0028-7556-4449-be07-07171ab03ba1 Tue Dec 04 2012 14:04:26 GMT+0200 (EET) */
/* ZB:mod2.js */
Function.prototype.partial = function(){
    var fn = this, args = Array.prototype.slice.call(arguments);
    return function(){
        var arg = 0;
        for ( var i = 0; i < args.length && arg < arguments.length; i++ )
            if ( args[i] === undefined )
                args[i] = arguments[arg++];
        return fn.apply(this, args);
    };
};

(function(/*! Stitch !*/) {
    if (!this.require) {
        var
        modules = {},
        cache = {},

        require = function(name, root, ns) {
            if (ns !== undefined) {
                name = ns + '/' + expand('', name);
            }

            var path = expand(root, name),
                module = cache[path],
                fn;

            if (module) {
                return module.exports;

            } else if (fn = modules[path] || modules[path = expand(path, './index')]) {
                module = {id: path, exports: {}};

                try {
                    cache[path] = module;

                    fn(module.exports, module);

                    return module.exports;

                } catch (err) {
                    delete cache[path];
                    throw err;
                }

            } else {
                throw 'module \'' + name + '\' not found';
            }
        },

        expand = function(root, name) {
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
        },

        dirname = function(path) {
            return path.split('/').slice(0, -1).join('/');
        };

        this.require = function(name) {
            return require(name, '');
        };

        this.require.define = function(bundle, ns) {
            var _require = require.partial(undefined, undefined, ns);

            for (var key in bundle) {
                modules[key] = bundle[key].partial(undefined, _require, undefined);
            }

            for(var key in bundle) {
                modules[key]({}, {});
            }
        };
    }
    var ns = 'mod2';
    return this.require.define.partial(undefined, ns);

}).call(this)({"mod2/index": function(exports, require, module) {(function() {

  module.exports = {index: 'module2'}

}).call(this);
}, "mod2/module2": function(exports, require, module) {(function() {

  "Simple common js module";

  module.exports = {module2:'module2'};

}).call(this);
}});
;
/* ZB:mod1.js */

(function(/*! Stitch !*/) {
    return this.require.define.partial(undefined, "mod1");
}).call(this)({"mod1/index": function(exports, require, module) {(function() {

  "Simple common js module";
  m = require('module1');
  m2 = require('mod2/module2');
  console.log('---> 1', m);
  console.log('---> 2', m2);

  module.exports = {index:'module1'};

}).call(this);
}, "mod1/module1": function(exports, require, module) {(function() {

  "Simple common js module";

  module.exports = {module1: 'module1'};

}).call(this);
}});
;

