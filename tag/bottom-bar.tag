<bottom-bar>
    <div class="ui attached tabular small menu">
        <a class="active item" data-tab="webView" style="border-radius: 0 !important;" onclick="{showWebViewTab.bind(this, 'desktop')}">
            <i class="desktop icon"></i>PC
        </a>
        <a class="item" data-tab="webView" style="border-radius: 0 !important;" onclick="{showWebViewTab.bind(this, 'tablet')}">
            <i class="tablet icon"></i>Tablet
        </a>
        <a class="item" data-tab="webView" style="border-radius: 0 !important;" onclick="{showWebViewTab.bind(this, 'mobile')}">
            <i class="mobile icon"></i>Mobile
        </a>
        <a class="ui button disabled" id="openExternalBrowserBtn" data-tab="onBrowser" style="border-radius: 0 !important;" onclick="{openExternalBrowser}">Open on Browser</a>
        <a class="right item" data-tab="buildLog" style="border-radius: 0 !important;">Build Log</a>
    </div>
    <div class="ui bottom attached active tab segment" data-tab="webView" style="padding: 0; height: calc(100% - 35px); border-right: none; border-bottom: none;">
        <webview id="webview" preload="ipc.js" src="{iframeUrl}" style="display:flex; height: 100%"></webview>
    </div>
    <div class="ui bottom attached tab segment" data-tab="buildLog" style="padding: 0; height: calc(100% - 35px); border-right: none; border-bottom: none;">
        <pre class="accesslog hljs" style="height:100%; overflow: auto; margin: 0;font-family: Consolas, monospace;">
        </pre>
    </div>

    <script>
        var Path = require('path');
        var Promise = require('bluebird');
        var Fs = Promise.promisifyAll(require('fs'));
        var me = this;

        var buildingDataUri = 'data:text/html;charset=utf-8;base64,PCFET0NUWVBFIGh0bWw+PG1ldGEgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04Imh0dHAtZXF1aXY9Y29udGVudC10eXBlPjxtZXRhIGNvbnRlbnQ9Im5vaW5kZXgsIG5vZm9sbG93Im5hbWU9cm9ib3RzPjxtZXRhIGNvbnRlbnQ9Im5vaW5kZXgsIG5vZm9sbG93Im5hbWU9Z29vZ2xlYm90PjxzY3JpcHQgc3JjPS9qcy9saWIvZHVtbXkuanM+PC9zY3JpcHQ+PGxpbmsgaHJlZj0vY3NzL3Jlc3VsdC1saWdodC5jc3MgcmVsPXN0eWxlc2hlZXQ+PHN0eWxlPmJvZHl7bWluLWhlaWdodDoxMDAlO2JhY2tncm91bmQtY29sb3I6cmdiYSgwLDAsMCwuMDMpfWgxe3Bvc2l0aW9uOmFic29sdXRlO2xlZnQ6NTAlO21hcmdpbi1sZWZ0Oi0xLjllbTtjb2xvcjpyZ2JhKDAsMCwwLC4wMyk7Zm9udDo4MDAgOTAwJSBSb2JvdG8sc2FuLXNlcmlmfWgxOmJlZm9yZXtwb3NpdGlvbjphYnNvbHV0ZTtvdmVyZmxvdzpoaWRkZW47Y29udGVudDphdHRyKGRhdGEtY29udGVudCk7Y29sb3I6I2Q0ZDVkNzttYXgtd2lkdGg6NGVtOy13ZWJraXQtYW5pbWF0aW9uOmxvYWRpbmcgM3MgbGluZWFyIGluZmluaXRlfUAtd2Via2l0LWtleWZyYW1lcyBsb2FkaW5nezAle21heC13aWR0aDowfX08L3N0eWxlPjx0aXRsZT5Mb2FkaW5nIGFuaW1hdGlvbjwvdGl0bGU+PHNjcmlwdD53aW5kb3cub25sb2FkPWZ1bmN0aW9uKCl7fTwvc2NyaXB0PjxoMSBkYXRhLWNvbnRlbnQ9QnVpbGRpbmc+QnVpbGRpbmc8L2gxPg==';
        var ewhDataUri = 'data:text/html;charset=utf-8;base64,PCFET0NUWVBFIGh0bWw+PG1ldGEgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04Imh0dHAtZXF1aXY9Y29udGVudC10eXBlPjxtZXRhIGNvbnRlbnQ9Im5vaW5kZXgsIG5vZm9sbG93Im5hbWU9cm9ib3RzPjxtZXRhIGNvbnRlbnQ9Im5vaW5kZXgsIG5vZm9sbG93Im5hbWU9Z29vZ2xlYm90PjxzY3JpcHQgc3JjPS9qcy9saWIvZHVtbXkuanM+PC9zY3JpcHQ+PGxpbmsgaHJlZj0vY3NzL3Jlc3VsdC1saWdodC5jc3MgcmVsPXN0eWxlc2hlZXQ+PHN0eWxlPmJvZHl7bWluLWhlaWdodDoxMDAlO2JhY2tncm91bmQtY29sb3I6cmdiYSgwLDAsMCwuMDMpfWgxe3Bvc2l0aW9uOmFic29sdXRlO2xlZnQ6NTAlO21hcmdpbi1sZWZ0Oi0xLjllbTttYXgtd2lkdGg6NGVtO2NvbG9yOnJnYmEoMCwwLDAsLjAzKTtmb250OjgwMCA5MDAlIFJvYm90byxzYW4tc2VyaWZ9aDE6YmVmb3Jle3Bvc2l0aW9uOmFic29sdXRlO292ZXJmbG93OmhpZGRlbjtjb250ZW50OmF0dHIoZGF0YS1jb250ZW50KTtjb2xvcjojZDRkNWQ3O21heC13aWR0aDo2ZW07LXdlYmtpdC1hbmltYXRpb246bG9hZGluZyA1cyBsaW5lYXIgaW5maW5pdGV9QC13ZWJraXQta2V5ZnJhbWVzIGxvYWRpbmd7MCV7bWF4LXdpZHRoOjB9fTwvc3R5bGU+PHRpdGxlPkxvYWRpbmcgYW5pbWF0aW9uPC90aXRsZT48c2NyaXB0PndpbmRvdy5vbmxvYWQ9ZnVuY3Rpb24oKXt9PC9zY3JpcHQ+PGgxIGRhdGEtY29udGVudD1FYXN5V2ViPkVhc3lXZWI8L2gxPg==';


        var tab;
        var resizerScript = Fs.readFileSync(__dirname + '/assets/js/resizer.min.js').toString();
        var output = '';
        var watchProcess;
        var watchProcessPids = [];
        var lastWatchMode = '';

        me.iframeUrl = me.opts.iframeUrl ? me.opts.iframeUrl : ewhDataUri;

        var nodePath = Path.resolve(Path.join('tools', 'nodejs', 'node_modules'));
        var PATH = [
            Path.resolve(Path.join('tools', 'nodejs', 'node_modules', '.bin')) + '/',
            Path.resolve(Path.join('tools', 'nodejs')) + '/',
            Path.resolve(Path.join('tools', 'git', 'bin')) + '/',
            process.env['PATH']
        ].join(process.platform === 'linux' ? ':' : ';');

        me.on('mount', function () {
            tab = $(me.root.querySelector('.ui.tabular.menu')).tab();
        });
        var ChildProcess = require('child_process');

        function spawnProcess(command, args) {
            args = args || [];
            var newProcess = ChildProcess.spawn(command, args, {
                env:   {
                    'NODE_PATH': nodePath,
                    'PATH':      PATH
                },
                cwd:   Path.resolve(Path.join('sites', opts.siteName)),
                shell: true
            });
//            watchProcessPids.push(newProcess.pid);

            var dataBuf = [];
            var logTimer;
            newProcess.stdout.on('data', function (data) {
                dataBuf.push(String.fromCharCode.apply(null, data));
                clearTimeout(logTimer);

                logTimer = setTimeout(function () {
                    // find browserSync port in stdout
                    var str = dataBuf.join('');
//                    console.log(str);
                    if (str.indexOf('[Error:') != -1) {
                        me.appendError(str);
//                        riot.event.trigger('watchFailed', str);
//                        $(me.consoleLog).show();
                    } else {
                        var reviewUrl = (/Local: (http:\/\/.+)/gm).exec(str);
                        if (reviewUrl != null) {
                            console.log('found review url', reviewUrl[1]);
//                            riot.event.trigger('watchSuccess', reviewUrl[1]);
                            me.iframeUrl = reviewUrl[1];
                            me.webview.src = me.iframeUrl;
                            $(me.openExternalBrowserBtn).removeClass('disabled');
                            // TODO inject js detect is resizer already running
//                            me.webview.executeJavaScript(resizerScript, false);
                            me.update();
                        }
                        me.append(str);
                    }
                    dataBuf = [];
                }, 500);
            });

            newProcess.stderr.on('data', function (data) {
                var str = String.fromCharCode.apply(null, data);
                me.appendError(str);
                riot.event.trigger('watchFailed', str);
            });

            return newProcess;
        }

        function scrollToBottom() {
            me.output.parentNode.scrollTop = me.output.parentNode.scrollHeight
        }

        function closeProcess(proc) {
            proc.stdin.pause();

            if (process.platform === 'linux') {
                process.kill('SIGKILL');
            } else if (process.platform === 'win32') {
                ChildProcess.execSync('taskkill /pid ' + proc.pid + ' /F /T');
            }
            me.append('close exists watch process');
        }
        //        me.npmInstall = function () {
        //            console.log('npmInstall');
        //            console.log('npm cli', Path.resolve(Path.join(opts.siteName, '..', 'tools', 'nodejs', 'node_modules', 'npm', 'bin', 'npm-cli.js')));
        //            spawnProcess('node.exe', [Path.resolve(Path.join(opts.siteName, '..', 'tools', 'nodejs', 'node_modules', 'npm', 'bin', 'npm-cli.js')), 'install']);
        //        };

        // close watch process truoc khi app exit
        window.onbeforeunload = function (e) {
            me.closeWatchProcess();
        };

        riot.event.on('refreshWatch', function () {
            me.append('refresh watch');
            me.closeWatchProcess();
            me.clear();
            if (lastWatchMode == 'user')
                me.watch();
            else if (lastWatchMode == 'dev')
                me.watchDev();
        });

        me.closeWatchProcess = function () {
            try {
                if (!watchProcess)
                    return;
                closeProcess(watchProcess);
                watchProcess = null;
            } catch (ex) {
                console.log('close watch error', ex);
                watchProcess = null;
            }
        };

        me.watch = function () {
            me.webview.src = buildingDataUri;
            me.clearLog();
            me.closeWatchProcess();

            me.append('build starting...\r\n');
            lastWatchMode = 'user';
            watchProcess = spawnProcess(process.platform === 'linux' ? 'gulp' : 'gulp.cmd', ['--continue', 'app-watch']);
        };

        me.watchDev = function () {
            me.webview.src = buildingDataUri;
            me.clearLog();
            me.closeWatchProcess();
            console.log('WATCH DEV NEED gulpfile.dev.js');

            me.append('build dev starting...\r\n');
            lastWatchMode = 'dev';
            watchProcess = spawnProcess(process.platform === 'linux' ? 'gulp' : 'gulp.cmd', ['--continue', '--gulpfile', 'gulpfile.dev.js', 'app-watch']);
        };

        // TODO on unmount close watch process

        //        me.buildDev = function () {
        //            me.clearLog();
        //            me.closeWatchProcess();
        //            spawnProcess('gulp.cmd', ['build']);
        //        };
        //
        //        me.buildProd = function () {
        //            me.clearLog();
        //            me.closeWatchProcess();
        //            spawnProcess('gulp.cmd', ['build', '--production']);
        //        };

        var executeJavaScript = Promise.coroutine(function*(script) {
            return new Promise((resolve, reject) => {
                if (!me.webview)
                    reject(new Error('no webview'));
                me.webview.executeJavaScript(script, false, result => {
                    if (result === undefined)
                        resolve();
                    else
                        resolve(result);
                });
            })
        });

        me.on('mount', function () {
            me.output = me.root.querySelector('pre');
            me.output.innerHTML = '';
            me.webview.src = ewhDataUri;

            me.webview.addEventListener('did-finish-load', Promise.coroutine(function*(event) {
                try {
                    console.log('webpage finished load, start injecting');
                    let isJqueryExists = yield executeJavaScript(`(!!jQuery)`);
                    console.log('isJqueryExists', isJqueryExists);

                    if (!isJqueryExists) {
                        console.log('injecting jQuery');
                        yield executeJavaScript((yield Fs.readFileAsync('assets/js/jquery.min.js')).toString());
                    }

                    console.log('injecting e-editable');
                    yield executeJavaScript((yield Fs.readFileAsync('assets/js/jquery.poshytip.min.js')).toString());
                    yield executeJavaScript((yield Fs.readFileAsync('assets/js/jquery-editable-poshytip.min.js')).toString());
                    me.webview.insertCSS((yield Fs.readFileAsync('assets/css/tip-yellowsimple.css')).toString());
                    me.webview.insertCSS((yield Fs.readFileAsync('assets/css/jquery-editable.css')).toString());

                    // script active x-editable of suitable element
                    // find elm with data-ea-object-path data attribute
                    // active x-editable with callback to app
                    setTimeout(function () {
                        executeJavaScript(`(function() {
                        $('*[data-ea-object-path]').each(function(index, elm) {
                            var $elm = $(elm);
                            $elm.editable({
                                success: function(response, newValue) {
                                    sendToHost('contentChanged', {
                                        objectPath: $elm.data('eaObjectPath'),
                                        type: $elm.data('eaType'),
                                        pathName: document.location.pathname,
                                        layout: $elm.data('eaLayout'),
                                        dataSrc: $elm.data('eaDataSrc'),
                                        newValue:   newValue,
                                    });
                                }
                            });
                        });
                    })();`);
                    }, 1000);
                } catch (ex) {
                    console.log('handle page load finished failed', ex);
                }
            }));


            function applyNewValue(objectPath, target, newValue) {
                let parts = objectPath.split('.');
                let cur = target;
                let parent = null;
                let found = parts.some(function(key, index) {
                    // if key is number (array index)
                    if (/^[0-9]+$/g.test(key)) {

                        key = parseInt(key);
                        parent = cur;
                        cur = cur[key];
                        console.log('number', key, cur != undefined && index == parts.length-1);
                        return cur != undefined && index == parts.length-1;
                    } else if (typeof(key) === 'string') {
                        // text
                        parent = cur;
                        cur = cur[key];
                        console.log('text', key, cur != undefined && index == parts.length-1);
                        return cur != undefined && index == parts.length-1;
                    } else {
                        return false; // not proccessable key, break
                    }
                });
                if(!found) return false;
                let lastKey = parts.pop();
                parent[lastKey] = newValue;
                return true;
            }

            me.webview.addEventListener('ipc-message', event => {
                console.log('got event', event);
                if (!event || !event.channel || event.channel !== 'contentChanged' ||
                    !event.args || !event.args.length || event.args.length == 0) {
                    return;
                }

                let info = event.args[0];
                // TODO find content file from site pathName
                let contentFile = info.pathName.trim();
                if (contentFile === '/') {
                    contentFile = 'index.md';
                } else {
                    if (contentFile.endsWith('.html')) {
                        let parts = contentFile.split('.');
                        parts.pop();
                        contentFile += parts.join('.') + '.md';
                    } else {
                        contentFile += '.md';
                    }
                }

                // get content file data from cache indexes
                var content = siteContentIndexes[contentFile];
                if (!content) {
                    console.log('on contentChanged content not found');
                    return;
                }
                // apply changes from x-editable
                let success = applyNewValue(info.objectPath, content, info.newValue);
                if (!success) {
                    console.log('on contentChanged objectPath not found in content');
                    return;
                }

                // save new content file to disk and cache index
                siteContentIndexes[contentFile] = content;
                let markdownData = content['__content__'] || '';
                BackEnd.saveContentFile(me.opts.siteName, 'content/'+contentFile, content, markdownData);

                // TODO check if update ui is necessary
            });

            window.wv = me.webview;
            window.btmSideBar = me;
        });

        me.clearLog = function () {
            me.output.innerHTML = '';
        };

        me.append = function (text) {
            var span = document.createElement('span');
            console.log('BUILD:', text);
            span.innerHTML = text;
            me.output.appendChild(span);
            scrollToBottom();
        };

        me.clear = function () {
            me.output.innerHTML = '';
        };

        me.openExternalBrowser = function () {
            console.log('openExternalBrowser', me.webview.src);
            if (me.webview.src != 'about:blank') {
                const {shell} = require('electron');
                shell.openExternal(me.webview.src);
            }
        };

        me.appendError = function (text) {
            console.log('BUILD-ERROR:', text);
            var span = document.createElement('span');
            span.innerHTML = text;
            span.style.color = 'red';
            me.output.appendChild(span);
            scrollToBottom();
        };

        me.showWebViewTab = function (deviceType, e) {
            window.wv = me.webview;
//                console.log(me.webview.width, me.webview.height);
            var aTag = $(e.srcElement).closest('a');
            if (aTag.hasClass('active')) return;
            aTag.siblings().removeClass('active');
            aTag.addClass('active');

            tab.tab('change tab', 'webview');
            var contents = me.webview.getWebContents();
            switch (deviceType) {
                case 'desktop':
                    contents.enableDeviceEmulation({
                        screenPosition: 'desktop'
                    });
                    break;
                    content.disableDeviceEmulation();
                    break;
                case 'tablet':
                    contents.enableDeviceEmulation({
                        screenPosition:    'mobile',
                        screenSize:        {width: 768, height: 1024},
                        deviceScaleFactor: 0,
                        viewPosition:      {x: 0, y: 0},
                        viewSize:          {width: 768, height: 1024},
                        fitToView:         false,
                        offset:            {x: 0, y: 0}
                    });
                    break;
                case 'mobile':
                    contents.enableDeviceEmulation({
                        screenPosition:    'mobile',
                        screenSize:        {width: 414, height: 736},
                        deviceScaleFactor: 0,
                        viewPosition:      {x: 0, y: 0},
                        viewSize:          {width: 414, height: 736},
                        fitToView:         true,
                        offset:            {x: 0, y: 0}
                    });
                    break;
            }
        }
    </script>
</bottom-bar>
