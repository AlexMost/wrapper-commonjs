->
    modules = {}
    cache = {}


    partial = (fn) ->
        partial_args = (Array::slice.call arguments)
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
        if ns? and !((expand root, name) of modules)
            name = "#{ns}/#{expand '', name}"

        path = expand(root, name)
        module = cache[path]

        if module
            module.exports
        else if fn = modules[path] or modules[path=expand(path, './index')])
            module =
                id: path
                exports: {}
            try
                cache[path] = module
                fn module.exports, module
            catch e:
                delete cache[path]
                throw e
        else
            throw "module '#{name}'"


    expand = (root, name) ->
        results = []
        if /^\.\.?(\/|$)/.test name
            parts = [root, name].join('/').split('/')
        else
            parts = name.split '/'
