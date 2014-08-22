var exec = require('cordova/exec');
var channel = require('cordova/channel');

function Leanplum(){
	this.debug = false;
}

Leanplum.prototype.enableDebugging = function(){
	this.debug = true;
};

Leanplum.prototype.start = function(successCallback, errorCallback, userId){
		exec(successCallback,errorCallback, "Leanplum", "start", [this.debug, userId]);
};

Leanplum.prototype.start = function(successCallback, errorCallback){
		exec(successCallback, errorCallback, "Leanplum", "start", [this.debug]);
};

Leanplum.prototype.track = function(name, successCallback, errorCallback){
		exec(successCallback, errorCallback, "Leanplum", "track", [name]);
};

Leanplum.prototype.track = function(name, data, successCallback, errorCallback){
		exec(successCallback, errorCallback, "Leanplum", "track", [name, data]);
};

Leanplum.prototype.registerPush = function(options){
	exec(function(success){ }, function(error){}, "Leanplum", "registerPush", [options]);
}

if (typeof module != 'undefined' && module.exports) {
  module.exports = new Leanplum();
};
