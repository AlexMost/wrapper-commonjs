# -Simple common js bootstrapper.
# -Inspired by stitch.

unless this.require
    modules = {}
    cache = {}

    partial = (fn) ->
        partial_args = Array::slice.call arguments
        partial_args.shift()
        ->
            [new_args, arg] = [[], 0]

            for a, i in partial_args
                if partial_args[i] is undefined
                    new_args.push arguments[arg++]
                else
                    new_args.push partial_args[i]
            fn.apply this, new_args

    require = (name, root, ns) ->
        path = expand(root, name)
        ns_path = "#{ns}/#{expand '', name}"
        top_level_module = modules[path] or modules[(expand(path, './index'))]

        if ns and !top_level_module # TODO: handle when module is not loaded.
            path = ns_path

        ns_module = modules[ns_path] or modules[(expand(ns_path, './index'))]

        if ns and top_level_module and ns_module
            path = "#{ns}/#{expand '', name}"

        module = cache[path] or cache[expand(path, './index')]

        if module
            module.exports
        else if fn = modules[path] or modules[path=expand(path, './index')]
            module =
                id: path
                exports: {}
            try
                cache[path] = module
                fn module.exports, module
                module.exports
            catch e
                delete cache[path]
                throw e
        else
            throw "module '#{name}' is not found"

    require.modules = -> modules

    expand = (root, name) ->
        results = []

        if /^\.\.?(\/|$)/.test name
            parts = [root, name].join('/').split('/')
        else
            parts = name.split '/'

        for i in [0..parts.length - 1]
            part = parts[i]

            if part is '..'
                results.pop()
            else if part != '.' && part != ''
                results.push part

        results.join '/'

    diranme = (path) -> path.split('/')[0..-1].join '/'

    this.require = (name) -> require name, ''
    this.require.modules = -> modules
    this.require.cache = -> cache

    this.require.define = (ns, bundle) ->
        _require = partial(require, undefined, undefined, ns)

        for key, value of bundle
            _key =  if ns then "#{ns}/#{key}" else key
            modules[_key] = partial(value, undefined, _require, undefined)
            undefined
        undefined

