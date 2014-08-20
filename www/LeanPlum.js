var exec = require('cordova/exec');
var channel = require('cordova/channel');

function Leanplum(){
	var me = this;
}

Leanplum.prototype.start = function(userId, successCallback, errorCallback){
		exec(successCallback,errorCallback, "Leanplum", "start", [userId]);
};

Leanplum.prototype.start = function(successCallback, errorCallback){
		exec(successCallback, errorCallback, "Leanplum", "start");
};

Leanplum.prototype.define = function(name, value, successCallback, errorCallback){
    exec(successCallback, errorCallback, "Leanplum", "define", [name, value]);
};

Leanplum.prototype.track = function(name, successCallback, errorCallback){
		exec(successCallback, errorCallback, "Leanplum", "track", [name]);
};

Leanplum.prototype.track = function(name, data, successCallback, errorCallback){
		exec(successCallback, errorCallback, "Leanplum", "track", [name, data]);
};

Leanplum.prototype.registerPush = function(successCallback, errorCallback, options){
	exec(successCallback, errorCallback, "Leanplum", "registerPush", [options]);
}

if (typeof module != 'undefined' && module.exports) {
  module.exports = new Leanplum();
};
