const {ipcRenderer} = require('electron');
window.sendToHost = function () {
    ipcRenderer.sendToHost.apply(this, Array.prototype.slice.call(arguments));
};
