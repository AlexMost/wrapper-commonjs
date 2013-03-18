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
        [
            ((wrap_plain s.source, s.filename) for s in sources when get_m_type(s) is PLAIN_JS).join '\n'
            ((wrap_file s.source, s.filename, s.type, ns) for s in sources when get_m_type(s) is COMMON_JS).join '\n'
        ].join('\n')
    else
        wrap_module [sources], ns, type


wrap_plain = (source, filename) ->
    [
        "/*ZB:  #{filename} */"
        "#{source};"
    ].join('\n')


wrap_file = (source, filename, type, ns) ->
    [
        "/*ZB:  #{ns}/#{filename} */"
        "require.define('#{ns}', {"
        "'#{filename}': function(exports, require, module) {(function() {"
        source
        "}).call(this);}"
        "});"
    ].join('\n')


module.exports = {wrap_bundle, wrap_module, wrap_modules}
