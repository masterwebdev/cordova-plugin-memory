cordova.define("com.autoivtalsinc.memory.memory", function(require, exports, module) {
/*global cordova, module*/

module.exports = {
    getmemory: function (name, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "Memory", "getmemory", [name]);
    }
};

});
