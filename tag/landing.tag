<landing>
    <dialog-new-site-local></dialog-new-site-local>
    <dialog-new-site-import></dialog-new-site-import>
    <progress-dialog></progress-dialog>

    <div class="des-hero">

        <div class="ui grid container ">
            <div class="eight wide column">
                <img src="https://cdn1.vienthonga.vn/image/2016/10/4/100000_logo-easyweb-white-1.png" class="ui image" width="200" alt="">
            </div>

            <div class="eight wide column" style="text-align: right">
                <div class="ui dropdown top right pointing">
                    <input type="hidden" name="gender">
                    <img class="ui avatar image" src="http://semantic-ui.com/images/avatar/small/jenny.jpg">
                    <span>{username}</span>
                    <i class="dropdown icon"></i>

                    <div class="menu">
                        <a class="item disabled" data-value="changeUserData"><i class="edit icon"></i> Sửa thông tin</a>
                        <a class="item disabled" data-value="changeUserPassword"><i class="lock icon"></i> Đổi mật khẩu</a>
                        <div class="divider"></div>
                        <a class="item" data-value="signOut"><i class="sign out icon"></i> Đăng xuất</a>
                    </div>
                </div>
            </div>
        </div>


        <div class="ui grid container ">
            <div class="wide column">
                <h1 class="ui header huge">Present your website, easily</h1>
                <p>An open framework lets you build up websites <br/> with only HTML, CSS, JS skills</p>
                <br/>
                <div><i class="angle down icon large"></i></div>
            </div>
        </div>
    </div>
    <div class="user-project">
        <div class="ui grid container ">
            <div class="sixteen wide column">
                <h2 class="ui header weight-300">
                    Your projects:
                    <div class="sub header">Choose your projects to continue make your own awesome website</div>
                </h2>

                <div class="ui four stackable doubling cards">
                    <a each="{site, index in sites}" class="ui card" href="" onclick="{openSite.bind(this, site)}">
                        <div class="image">
                            <img src="{marketPlaceTemplateImageList[(index + 1) % 4]}">
                        </div>
                        <div class="content">
                            <div class="header">{site.name}</div>
                            <div class="description">
                                <p>Landing page for your company</p>
                            </div>
                        </div>
                        <div class="extra content">
                            <i class="edit icon"></i>
                            {moment("2016-10-20T08:54:54.924Z").fromNow()}
                        </div>
                    </a>

                </div>
            </div>
        </div>
    </div>


    <div class="marketplace">
        <div class="ui grid container ">
            <div class="sixteen wide column">
                <h1 class="ui header weight-300" style="
    margin: 0;
    "> Marketplace </h1>
                <h1 class="ui header weight-300 orange" style="margin: 20px 0 15px; font-size: 3em">Website template</h1>
                <!--<h2 class="ui header weight-300" style="margin: 0px 0 30px;"> Lorem ipslum dollar isset </h2>-->

                <div class="ui three stackable doubling cards">
                    <a each="{template, index in templateList}" class="ui card" href="" onclick="{showCreateSite.bind(this, template)}">
                        <div class="image">
                            <img src="{marketPlaceTemplateImageList[index %4]}">
                        </div>
                        <div class="content">
                            <div class="header">{template.name}</div>
                            <div class="description">
                                <p>Landing page for your company</p>
                            </div>
                        </div>

                        <div class="extra content">
                            <i>by</i> <b style="color:black">{ template.author || 'Someone' }</b>
                        </div>
                    </a>
                </div>
            </div>
        </div>
    </div>


    <!--<div class="ui hidden section divider"></div>-->
    <!--<div class="ui one column centered grid container">-->
    <!--<h2 class="ui horizontal divider header">-->
    <!--<i class="bar chart icon"></i>-->
    <!--Website Marketplace-->
    <!--</h2>-->
    <!--<div class="ui left aligned search">-->
    <!--<div class="ui icon input">-->
    <!--<input class="prompt" type="text" placeholder="Search websites...">-->
    <!--<i class="search icon"></i>-->
    <!--</div>-->
    <!--<div class="results"></div>-->
    <!--</div>-->
    <!--<div class="ui two column stackable grid container">-->
    <!--<div class="three wide column" each="{template in templateList}">-->
    <!--<div class="ui card site" style="text-align: center;" onclick="{selectSkeleton(template)}">-->
    <!--<div class="content">-->
    <!--<i class="add big link icon"></i>-->
    <!--<div class="ui hidden divider"></div>-->
    <!--<h4 class="header">{template.name}</h4>-->
    <!--</div>-->
    <!--</div>-->
    <!--</div>-->
    <!--</div>-->
    <!--<div class="ui hidden section divider"></div>-->
    <!--<div class="ui horizontal list">-->
    <!--<div class="item">-->
    <!--<div class="ui card">-->
    <!--<button class="ui primary huge icon button" onclick="{showCreateSite}">-->
    <!--<i class="add icon"></i>-->
    <!--Create new site-->
    <!--</button>-->


    <!--</div>-->
    <!--</div>-->
    <!--<div class="item"><h1>OR</h1></div>-->
    <!--<div class="item">-->
    <!--<div class="ui card">-->
    <!--<button class="ui primary huge icon button" onclick="{showImportGithub}">-->
    <!--<i class="github icon left aligned"></i>-->
    <!--Import repository-->
    <!--</button>-->

    <!--</div>-->
    <!--</div>-->
    <!--</div>-->
    <!--</div>-->
    <!--<div class="ui hidden section divider"></div>-->
    <!--<div class="ui two column stackable grid container">-->
    <!--<h2 class="ui horizontal divider header">-->
    <!--<i class="bar chart icon"></i>-->
    <!--List of your websites-->
    <!--</h2>-->
    <!--<div class="three wide column" each="{site in sites}">-->
    <!--<div class="ui card site" onclick="{openSite(site)}">-->
    <!--<div class="ui center aligned content">-->
    <!--<i class="{getSiteIcon(site)} big link icon"></i>-->
    <!--<div class="ui hidden divider"></div>-->
    <!--<h2 class="header">{site.name}</h2>-->
    <!--</div>-->
    <!--</div>-->
    <!--</div>-->
    <!--</div>-->

    <!--<div class="ui hidden section divider"></div>-->

    <!--<div class="ui two column grid container">-->
    <!--<div class="column">-->
    <!--<div class="ui fluid card">-->
    <!--<div class="content">-->
    <!--<div class="header">How to build website?</div>-->
    <!--<div class="description">-->
    <!--EasyWebHub cung cấp tất cả các thông tin bạn cần để xây dựng website, từ cơ bản như trang blog cá nhân tới phức tạp như website Ecommerce.-->
    <!--</div>-->
    <!--</div>-->
    <!--<div class="extra content">-->
    <!--<div class="ui two buttons">-->
    <!--<a class="ui basic green center button" href="#" onclick="{openTutorial}" rel="nofollow">Hướng dẫn sử dụng</a>-->
    <!--</div>-->
    <!--</div>-->
    <!--</div>-->
    <!--</div>-->
    <!--<div class="column">-->
    <!--<div class="ui fluid card">-->
    <!--<div class="content">-->
    <!--<div class="header">Build website faster, easier?</div>-->
    <!--<div class="description">-->
    <!--EasyWebHub cung cấp tất cả các thông tin bạn cần để xây dựng website, từ cơ bản như trang blog cá nhân tới phức tạp như website Ecommerce.-->
    <!--</div>-->
    <!--</div>-->
    <!--<div class="extra content">-->
    <!--<div class="ui two buttons">-->
    <!--<a class="ui basic green link button" href="http://electron.atom.io/docs/api/menu/" target="_blank" rel="nofollow">Công cụ hỗ trợ</a>-->
    <!--</div>-->
    <!--</div>-->
    <!--</div>-->
    <!--</div>-->
    <!--</div>-->
    <!--<div class="ui cards">-->

    <!--</div>-->


    <style scoped>
        .site, .site > .content > .header {
            cursor: pointer;
            color: black !important;
        }

        .site:hover {
            cursor: pointer;
            color: #1e70bf !important;
        }

        .site > .content > .header:hover {
            cursor: pointer;
            color: #1e70bf !important;
        }
    </style>

    <script>
        var me = this;
        var root = me.root;
        var dialog = require('electron').remote.dialog;
        me.username = '';

        me.marketPlaceTemplateImageList = [
            'https://cdn1.vienthonga.vn/image/2016/10/4/100000_01-preview-oneui-large-preview.jpg',
            'https://cdn1.vienthonga.vn/image/2016/10/4/100000_01preview-main-large-preview.jpg',
            'https://cdn1.vienthonga.vn/image/2016/10/4/100000_01-homepage-edit10-large-preview.jpg',
            'https://cdn1.vienthonga.vn/image/2016/10/4/100000_01-preview-large-preview.jpg'
        ];

        me.templateList = [];
        try {
            me.templateList = JSON.parse(require('fs').readFileSync('template.json').toString()).templates;
        } catch (ex) {
            console.log(ex);
        }

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

        me.on('unmount', function () {
            me.tags['dialog-new-site-local'].hide();
        });

        me.mergeLocalRemoteSites = function() {
            var sites = BackEnd.getSiteList();
//            console.log('User.sites', User.sites)
            var remoteSites = Object.assign(User.data.sites || [], {});
//            console.log('remoteSites', remoteSites);
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
//                    console.log('not exists site', remoteSite);
                    remoteSite.local = false;
                    remoteSite.remote = true;
                    sites.push(remoteSite);
                }
            });

            me.sites = sites;
            me.update();
        };

        me.on('mount', function () {
            me.username = User.data.username;
            $(me.root).find('.ui.dropdown').dropdown({
                onChange: function (value) {
                    switch (value) {
                        case 'signOut':
                            console.log('signOut');
                                riot.event.trigger('logout');
                            break;
                        case 'changeUserPassword':
                            console.log('changeUserPassword');
                            break;
                        case 'changeUserData':
                            console.log('changeUserData');
                            break;
                    }
                }
            });
            me.mergeLocalRemoteSites();
        });

        me.openSite = function (site, e) {
            console.log('register openSite', site);
            if (site.local == false && site.remote && !site.url) {
                alert('Remote repository not exists in site data');
                return;
            }
            var siteName = site.name;
            me.unmount(true);
            window.curPage = riot.mount('home', {siteName: siteName})[0];
        };

        me.createSite = function (displayName, repoUrl, branch) {
//            var localPath = Path.join(__dirname, 'sites', name);
            var name = displayName.toLowerCase()
                    .normalize('NFKD')
                    .replace(/[\u0300-\u036F]/g, '')
                    .replace(/đ/g, 'd')
                    .replace(/[?,!\/'":;#$@\\()\[\]{}^~]*/g, '')
                    .replace(/\s+/g, '-')
                    .trim();
            return User.addSite(name, displayName).then(function (resp) {
                return BackEnd.createSiteFolder(name).then(function (sitePath) {
                    return BackEnd.gitCheckout(repoUrl, branch, sitePath).then(function () {
                        console.log('git checkout done', name);
//                    if (window.curPage) window.curPage.unmount(true);
//                    window.curPage = riot.mount('home', {siteName: name})[0];
                        return name;
                    })
                });
            });
        };

        me.showCreateSite = function (template, e) {
//                console.log('show binding showCreateSite', template);
//                console.log('e', e);
//                return function (e) {
//                    console.log('showCreateSite', me.tags['dialog-new-site-local']);
            me.tags['dialog-new-site-local'].show(template);
//                }
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
                    me.openSite(info.siteName)();
                }).catch(function (err) {
                    console.log(err);
                    me.tags['progress-dialog'].enableClose();
                });
            });
        };
    </script>
</landing>
