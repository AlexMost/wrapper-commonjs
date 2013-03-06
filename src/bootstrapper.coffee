"""
Simple common js bootstrapper.
Inspired by stitch.
"""

unless this.require
    modules = {}
    cache = {}
    queues = ['init_queue', 'document_ready_queue', 'document_loaded_queue']
    Q = {}
    Q[q] = [] for q in queues

    unless window.bootstrapper
        window.bootstrapper = {}

    window.bootstrapper.modules = modules # for debug
    window.bootstrapper.cache = cache # for debug
    window.bootstrapper.queues = Q # for debug

    window.bootstrapper.put_to_queue = (q, f) ->
        if q in queues
            fs = if (Array.isArray f) then f else [f]
            fs.map (f) -> Q[q].push f
        else
            throw "Invalid queue: #{q}"

    window.bootstrapper.run_queue = (qname) ->
        if qname in queues
            while f = Q[qname].shift()
                f()
        else
            throw "Invalid queue: #{qname}"

    window.bootstrapper.run_init_queue = ->
            window.bootstrapper.run_queue 'init_queue'

    doc = window.document
    add = if doc.addEventListener then 'addEventListener' else 'attachEvent'
    rem = if doc.addEventListener then 'removeEventListener' else 'detachEvent'
    pre = if doc.addEventListener then '' else 'on'

    if doc.readyState is 'complete'
        # run everything if all events has been fired already
        window.bootstrapper.run_queue 'document_ready_queue'
        window.bootstrapper.run_queue 'document_loaded_queue'

    else
        # postpone queues processing
        doc[add](pre + 'DOMContentLoaded',
                    -> window.bootstrapper.run_queue 'document_ready_queue')
        window[add](pre + 'load',
                    -> window.bootstrapper.run_queue 'document_loaded_queue')




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
        # special case
        if name is 'bootstrapper'
            return window.bootstrapper

        path = expand(root, name)

        if ns? and !(modules[path] or modules[(expand(path, './index'))]) # TODO: handle when module is not loaded.
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


    this.require.define = (ns, bundle) ->
        _require = partial(require, undefined, undefined, ns)

        for key, value of bundle
            _key =  if ns then "#{ns}/#{key}" else key
            modules[_key] = partial(value, undefined, _require, undefined)
            undefined
        undefined

