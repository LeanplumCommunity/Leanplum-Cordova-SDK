var exec = require('cordova/exec');
var channel = require('cordova/channel');

function Leanplum(){
	this.debug = false;
}

Leanplum.prototype.enableDebugging = function(){
	this.debug = true;
};

Leanplum.prototype.start = function(successCallback, errorCallback, userId){
	if (userId === undefined) {
		exec(successCallback,errorCallback, "Leanplum", "start", [this.debug]);
	} else {
		exec(successCallback,errorCallback, "Leanplum", "start", [this.debug, userId]);        
	}
};

Leanplum.prototype.track = function(successCallback, errorCallback, name, data){
	if (data === undefined) {
		exec(successCallback, errorCallback, "Leanplum", "track", [name]);
	} else {
		exec(successCallback, errorCallback, "Leanplum", "track", [name, data]);
	}
};

Leanplum.prototype.registerPush = function(options){
	exec(function(success){ }, function(error){}, "Leanplum", "registerPush", [options]);
};

Leanplum.prototype.unregisterPush = function(){
	exec(function(success){ }, function(error){}, "Leanplum", "unregisterPush", []);
};

if (typeof module != 'undefined' && module.exports) {
  module.exports = new Leanplum();
};
