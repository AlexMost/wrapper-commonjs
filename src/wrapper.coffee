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
    @modules: list of dicts {sources, ns}
            [
                {ns:'namespace', sources: {filename: source}}
                .
                .
                .
            ]
    """
    
    ((wrap_module m.sources, m.ns) for m in modules).join('\n')


wrap_module = (sources, ns, type) ->
    """
    @sources: dict of key values filenames and source codes {filename, source}
    """

    get_m_type = (m) ->  m.type or type

    if sources.length
        plain_sources = sources.filter (s) -> get_m_type(s) is PLAIN_JS
        commonjs_sources = sources.filter (s) -> get_m_type(s) is COMMON_JS

        result = [
            ((wrap_plain s.source, s.filename) for s in plain_sources).join '\n'
        ]

        if commonjs_sources.length
            result.push "\n/*ZB: #{ns} */"
            result.push "require.define('#{ns}', {"
            result.push ((wrap_file s.source, s.filename, s.type, ns) for s in commonjs_sources).join ',\n'
            result.push "});"

        result.join('\n')
    else
        wrap_module [sources], ns, type


wrap_plain = (source, filename) ->
    [
        "\n/*ZB:  #{filename} */"
        "#{source};"
    ].join('\n')


wrap_file = (source, filename, type, ns) ->
    [
        "\n/*ZB:  #{ns}/#{filename} */"
        "'#{filename}': function(exports, require, module) {(function() {"
        source
        "}).call(this);}"
        
    ].join('\n')


module.exports = {wrap_bundle, wrap_module, wrap_modules}
