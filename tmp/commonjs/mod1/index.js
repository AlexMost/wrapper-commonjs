console.log('index mod1 initialized');

m1 = require('module1');

console.log(m1);
m2 = require('mod2/module2');

module.exports = {module1: 'index'}