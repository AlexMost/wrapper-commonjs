fs = require 'fs'
path = require 'path'
bootstrapper_file = path.join __dirname, './bootstrapper.js'
COMMON_JS = 'commonjs'
PLAIN_JS = 'plainjs'

wrap_bundle = (source, pre_header=null) ->
    """
    @source: source code of bundle.
    """

    [
        pre_header or ''
        (fs.readFileSync bootstrapper_file).toString()
        source
    ].join('\n')


wrap_modules = (modules) ->
    """
    @moduels: list of dict with values {sources, ns}
            [
                {ns:'namespace', sources: {filename: source}}
                .
                .
                .
            ]
    """
    
    (wrap_module(m.sources, m.ns) for m in modules).join('\n')


wrap_module = (sources, ns, type) ->
    """
    @sources: dict of key values filenames and source codes {filename, source}
    """

    if sources.length
        plain_js_modules = (wrap_plainjs_file(s, s.filename) for s in sources when s.type is PLAIN_JS)
        common_js_modules = (wrap_commonjs_file(s, ns) for s in sources when s.type is COMMON_JS)

        if type is COMMON_JS
            common_js_modules = common_js_modules.concat (wrap_commonjs_file(s, ns) for s in sources when s.type isnt PLAIN_JS)

        if type is PLAIN_JS
            plain_js_modules = plain_js_modules.concat(
                (wrap_plainjs_file(s, s.filename) for s in sources when s.type isnt COMMON_JS))

        if common_js_modules.length
            [
                plain_js_modules.join '\n'
                "require.define('#{ns}', {"
                common_js_modules.join '\n'
                "});\n"
            ].join('\n')
        else
            plain_js_modules.join '\n'
    else
        if sources.type is COMMON_JS
            wrap_module [sources], ns
        else
            wrap_plainjs_file sources, sources.filename


wrap_plainjs_file = (sources) ->
    [
        "/*ZB: #{sources.filename} */"
        "#{sources.source};"
    ].join '\n'


wrap_commonjs_file = (sources, ns) ->
    ns = "#{ns}/" if ns != ''

    [
        "/*ZB:  #{ns}#{sources.filename} */"
        "'#{sources.filename}': function(exports, require, module) {(function() {"
        sources.source
        "}).call(this);}"
    ].join('\n')


module.exports = {wrap_bundle, wrap_module, wrap_modules}
