CoffeeScript = require 'coffee-script'

wrap_bundle = (source) ->
    """
    @source: source code of bunle.
    """


wrap_module = (sources, ns) ->
    """
    @sources: dict of key values filenames and source codes {filename, source}
    """

    result = """define("#{ns}", """
    result += (s.filename for s of sources).join(',')
    result += """);"""


wrap_file = (source, filename) ->
    result = """{"#{filename}": function(exports, require, module) {(function() {"""
    result += source
    result += """}).call(this);}"""



moduel.exports = {wrap_bundle, wrap_module}
