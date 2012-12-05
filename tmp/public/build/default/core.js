(function(/*! Bootstrapper !*/){
    Function.prototype.partial = function(){
        var fn = this,
            partial_args = Array.prototype.slice.call(arguments);

        return function(){
            var new_args = [], arg = 0, i;
            for (i = 0; i < partial_args.length;  i++ ){
                if ( partial_args[i] === undefined ){
                    new_args.push(arguments[arg++]);
                } else {
                    new_args.push(partial_args[i]);
                }
            }
            return fn.apply(this, new_args);
        };
    };

    var modules = {}, cache = {}, require = function(name, root, ns) {
        if (ns != undefined && !modules.hasOwnProperty(expand(root, name))) {
            name = ns + '/' + expand('', name);
        }
        var path = expand(root, name), module = cache[path], fn;
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
    this.require.define = function(ns, bundle) {
        var _require = require.partial(undefined, undefined, ns);
        for (var key in bundle) {
            modules[key] = bundle[key].partial(undefined, _require, undefined);
        }
        for(var key in bundle) {
            modules[key]({}, {});
        }
    };
}).call(this)


/* Cafe 960d0028-7556-4449-be07-07171ab03ba1 Tue Dec 04 2012 14:04:26 GMT+0200 (EET) */
/* ZB:mod2.js */

require.define("mod2",
        {
            "mod2/index": function(exports, require, module) {
                                (function() {

                                    module.exports = {index: 'module2'}

                                }).call(this);
                          },

            "mod2/module2": function(exports, require, module) {
                                (function() {
                                    "Simple common js module";

                                    module.exports = {module2:'module2'};

                                }).call(this);
                            }
        }
);


require.define("mod1", {"mod1/index": function(exports, require, module) {(function() {

  "Simple common js module";
  m1 = require('module1');
  console.log(m1);
  m2 = require('mod2/module2');
  console.log(m2)

  module.exports = {index:'module1'};

}).call(this);
}, "mod1/module1": function(exports, require, module) {(function() {

  "Simple common js module";

  module.exports = {module1: 'module1'};

}).call(this);
}});
