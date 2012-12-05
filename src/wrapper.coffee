CoffeeScript = require 'coffee-script'

wrap_bundle = (source) ->
    """
    @source: source code of bunle.
    """

wrap_module = (source, filename, ns) ->
    """
    @source: source code of
    """

    result = """define("#{ns}", {"#{filename}": function(exports, require, module) {(function() {"""
    result += source
    result += """}).call(this);"""

moduel.exports = {wrap_bundle, wrap_module}