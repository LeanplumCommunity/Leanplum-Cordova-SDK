var exec = require('cordova/exec');
var channel = require('cordova/channel');

function LeanPlum(){
	var me = this;
}

LeanPlum.prototype.define = function(name, value, successCallback){
    exec(successCallback,null, "LeanPlum", "define", [name, value]);
}

if (typeof module != 'undefined' && module.exports) {
  module.exports = new LeanPlum();
}
