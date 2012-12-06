fs = require 'fs'
path = require 'path'
{wrap_bundle, wrap_module, wrap_modules} = require '../src/wrapper'


get_sources = (dirname) ->
    (fs.readdirSync path.resolve(dirname))\
    .map((f) -> path.join (path.resolve(dirname)), f)\
    .map((f) ->
            {
            filename: (path.basename f).replace('.js', '')
            source: (fs.readFileSync f).toString()
            }
        )


sources_mod1 = get_sources (path.join __dirname, './commonjs/mod1')
sources_mod2 = get_sources (path.join __dirname, './commonjs/mod2')


fs.writeFileSync('result.js',
                 wrap_bundle(wrap_modules [
                             {sources: sources_mod2, ns: "mod2"}
                             {sources: sources_mod1, ns: "mod1"}
                             ]))
