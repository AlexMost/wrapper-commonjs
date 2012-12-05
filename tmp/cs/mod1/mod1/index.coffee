"Simple common js module"

m1 = require 'module1'
console.log m1

module = () ->
    console?.log "mod1 index initialized"

module.exports = module
