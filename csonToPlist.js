var plist = require('plist');
var fs = require('fs');
var CSON = require('cson');

function convert(fileName) {
    var content = fs.readFileSync(fileName);
    
    var obj = CSON.parseCSONString(content);
    
    console.log(plist.build(obj));
} 

convert(process.argv[2]);