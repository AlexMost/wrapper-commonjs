"Simple common js module"

m2 = require './module2'
console.log m2

module = () ->
    console?.log "mod2 index initialized"

module.exports = module
