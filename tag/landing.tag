<landing>
    <dialog-new-site-local></dialog-new-site-local>
    <dialog-new-site-import></dialog-new-site-import>
    <progress-dialog></progress-dialog>
    <br>
    <div class="ui one column centered grid">
        <div class="ui horizontal list">
            <div class="item">
                <div class="ui card" style="text-align: center">
                    <a class="icon" href="#" onclick="{showCreateSite}">
                        <i class="add huge link icon"></i>
                    </a>
                    <div class="content">
                        <a class="header" href="#" onclick="{showCreateSite}">Create new site</a>
                    </div>
                </div>
            </div>
            <div class="item" style="padding-top: 3em; vertical-align: middle;"><h1>OR</h1></div>
            <div class="item">
                <div class="ui card" style="text-align: center">
                    <a class="icon" href="#" onclick="{showImportGithub}">
                        <i class="github huge link icon"></i>
                    </a>
                    <div class="content">
                        <a class="header" href="#" onclick="{showImportGithub}">Import GitHub repository</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <h2 class="header">List of your websites</h2>
    <div class="ui grid">
        <div class="three wide column" each="{site in sites}">
            <div class="ui card site" style="text-align: center;" onclick="{openSite(site)}">
                <div class="content">
                    <i class="{getSiteIcon(site)} big link icon"></i>
                    <h2 class="header" style="padding-top:0.5em">{site.name}</h2>
                </div>
            </div>
        </div>
    </div>

    <div class="ui two column grid">
        <div class="column">
            <div class="ui fluid card">
                <div class="content">
                    <div class="header">How to build website?</div>
                    <div class="description">
                        EasyWebHub cung cấp tất cả các thông tin bạn cần để xây dựng website, từ cơ bản như trang blog cá nhân tới phức tạp như website Ecommerce.
                    </div>
                </div>
                <div class="extra content">
                    <div class="ui two buttons">
                        <a class="ui basic green link button" href="#" onclick="{openTutorial}" rel="nofollow">Hướng dẫn sử dụng</a>
                    </div>
                </div>
            </div>
        </div>
        <div class="column">
            <div class="ui fluid card">
                <div class="content">
                    <div class="header">Build website faster, easier?</div>
                    <div class="description">
                        EasyWebHub cung cấp tất cả các thông tin bạn cần để xây dựng website, từ cơ bản như trang blog cá nhân tới phức tạp như website Ecommerce.
                    </div>
                </div>
                <div class="extra content">
                    <div class="ui two buttons">
                        <a class="ui basic green link button" href="http://electron.atom.io/docs/api/menu/" target="_blank" rel="nofollow">Công cụ hỗ trợ</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="ui cards">

    </div>


    <style scoped>
        .site, .site>.content>.header {
            cursor: pointer;
            color: black !important;
        }

        .site:hover {
            cursor: pointer;
            color: #1e70bf !important;
        }

        .site>.content>.header:hover  {
            cursor: pointer;
            color: #1e70bf !important;
        }
    </style>

    <script>
        var me = this;
        var root = me.root;

        var dialog = require('electron').remote.dialog;

        var newSite;
        me.sites = [];

        me.getSiteIcon = function (site) {
            if (site.remote && site.local) {
                return 'cloud';
            } else if (site.remote) {
                return 'cloud download';
            } else if (site.local) {
                return 'folder outline';
            }
        };

        me.on('mount', function () {
            var sites = BackEnd.getSiteList();

            var remoteSites = Object.assign(User.sites || [], {});
            console.log('remoteSites', remoteSites);
            // merge with remote site

            // set local, remote status for local sites
            sites.forEach(site => {
                site.local = true;
                site.remote = false;

                remoteSites.some(remoteSite => {
                    if (site.name === remoteSite.name) {
                        site.remote = true;
                        return true;
                    }
                    return false;
                });
            });

            // add remote site if not exists
            remoteSites.forEach(remoteSite => {
                var exists = sites.some(site => {
                    return site.name === remoteSite.name;
                });
                if (!exists) {
                    console.log('not exists site', remoteSite);
                    remoteSite.local = false;
                    remoteSite.remote = true;
                    sites.push(remoteSite);
                }
            });

            me.sites = sites;
            me.update();
        });

        me.openSite = function (site) {
            return function (e) {
                if (site.remote && !site.url) {
                    alert('Remote repository not exists in site data');
                    return;
                }
                var siteName = site.name;
                me.unmount(true);
                window.curPage = riot.mount('home', {siteName: siteName})[0];
            }
        };

        me.createSite = function (name, repoUrl, branch) {
            return riot.event.createSite(name, repoUrl, branch).then(function () {
                me.unmount(true);
            });
        };

        me.showCreateSite = function () {
            console.log('showCreateSite', me.tags['dialog-new-site-local']);
            me.tags['dialog-new-site-local'].show();
        };

        //            me.openSite = function () {
        //                console.log('onOpenSite', Path.join(__dirname, 'sites'));
        //
        //                var existSitePath = dialog.showOpenDialog({
        //                    title:       'Choose exists site directory',
        //                    defaultPath: Path.join(__dirname, '..', 'sites'),
        //                    properties:  ['openDirectory']
        //                });
        //                if (existSitePath === undefined) return;
        //                riot.event.openSite(existSitePath);
        //                me.unmount();
        //            };
        const BrowserWindow = require('electron').remote.BrowserWindow;
        const newWindowBtn = document.getElementById('frameless-window');

        me.openTutorial = function (event) {
            let win = new BrowserWindow({frame: true, width: 1280, minWidth: 1080, height: 840, icon: 'favicon.ico'});
            win.on('closed', function () {
                win = null
            });
            win.loadURL('http://blog.easywebhub.com/');
            win.show()
        };


        me.showImportGithub = function () {
            me.tags['dialog-new-site-import'].show();
            me.tags['dialog-new-site-import'].event.one('create', function (info) {
                me.tags['dialog-new-site-import'].hide();
                var repoUrl = 'https://' + encodeURIComponent(info.username) + ':' + encodeURIComponent(info.password) + '@' + (info.url.split('https://')[1]);
                console.log('repoUrl', repoUrl);
                me.tags['progress-dialog'].show('Import GitHub Project');
                BackEnd.gitImportGitHub(info.siteName, repoUrl, me.tags['progress-dialog'].appendText).then(function () {
                    me.tags['progress-dialog'].enableClose();
                    me.tags['progress-dialog'].hide();
                    me.openSite(info.siteName);
                }).catch(function (err) {
                    console.log(err);
                    me.tags['progress-dialog'].enableClose();
                });
            });
        };
    </script>

</landing>
