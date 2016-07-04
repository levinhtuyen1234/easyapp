'use strict';

const debug = /--debug/.test(process.argv);

const fs = require('fs');
const path = require('path');

const electron = require('electron');
const app = electron.app;
const ipcMain = electron.ipcMain;
const browserWindow = electron.BrowserWindow;

// setup relative electron data path
const appDataPath = path.join(process.cwd(), 'data');
app.setPath('appData', appDataPath);
app.setPath('userData', appDataPath);
app.setPath('home', appDataPath);

let mainWindow, webContents;

// setup log
let console = {
    log: () => {
        webContents.send('log', arguments);
    }
};


app.on('window-all-closed', () => {
    if (process.platform != 'darwin')
        app.quit();
});

app.on('ready', () => {
    mainWindow = new browserWindow({
        width:    1080,
        minWidth: 680,
        height:   840,
        icon:     'favicon.ico'
    });

    // if (process.platform === 'linux') {
    //     windowOptions.icon = path.join(__dirname, '/assets/app-icon/png/512.png')
    // }

    mainWindow.on('closed', function () {
        mainWindow = null
    });

    mainWindow.loadURL('file:/' + __dirname + '/index.html');
    mainWindow.setMenu(null);

    if (debug) {
        mainWindow.webContents.openDevTools();
        mainWindow.maximize();
        // auto reload
        ['tag', 'assets/css', 'assets/js', 'index.html'].forEach(dir => {
            fs.watch(dir, {persistent: true, recursive: true}, (event, filename) => {
                if (filename) {
                    mainWindow.reload();
                }
            });
        });
    }

    // ipcMain.on('toggleDevTools', ()=> {
    //     mainWindow.toggleDevTools();
    // });

    app.on('window-all-closed', function () {
        if (process.platform !== 'darwin') {
            app.quit()
        }
    });


    webContents = mainWindow.webContents;
});
