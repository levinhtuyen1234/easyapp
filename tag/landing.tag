<landing >
    <section class="featurette pb-0 pt-6">
      <div class="container-responsive">
        <div class="row">
            <new-site></new-site>
            <div class="col-sm-6 col-md-3">
                  <div class="pricing-card pricing-card-horizontal"> <div class="pricing-card-cta">
                  <div class="caption">
                      <div style="text-align: center"><i class="fa fa-plus fa-4x"></i></div>
                      <div>
                          <a href="#" class="btn btn-block btn-theme-green btn-jumbotron" role="button" onclick={showCreateSite}>Create new site</a>
                      </div>
                  </div>
            </div>
        </div>
      </div>
    </section>
    <section class="featurette pb-0 pt-6 shade-gray border-top">
      <div class="container-responsive">
        <h2 class="featurette-heading display-heading-2 mt-3">List of your websites</h2>
        <div class="row">
            <div class="col-sm-6 col-md-3" each={sites}>
                <div onclick={openSite.bind(this,name)}>
                    <div class="pricing-card pricing-card-horizontal"> <div class="pricing-card-cta">
                    <div class="caption" style="text-align: center">
                        <div style="text-align: center"><i class="fa fa-4x glyphicon glyphicon-cloud"></i></div>
                        <!--<img src={imgSrc} class="siteThumbnailImg" alt="Site Thumbnail">-->
                        <h1>{name}</h1>
                    </div>
                </div>
            </div>
        </div>
      </div>
    </section>

    <section class="featurette pb-0 pt-6 border-top">
      <div class="container-responsive">
          <h2 class="featurette-heading display-heading-2 mt-3">How to build website?</h2>
          <div class="pricing-card pricing-card-horizontal"> <div class="pricing-card-cta">
          <a class="btn btn-block btn-theme-green btn-jumbotron" onclick="{openTutorial}" rel="nofollow">Hướng dẫn sử dụng</a> </div>
          <div class="pricing-card-text display-heading-3 mb-0 text-thin">EasyWebHub cung cấp tất cả các thông tin bạn cần để xây dựng website, từ cơ bản như trang blog cá nhân tới phức tạp như website Ecommerce.</div> </div>
      </div>
    </section>
    <section class="featurette shade-gradient pb-4">
      <div class="container-responsive">
        <h2 class="featurette-heading display-heading-2 mt-3">Build website faster, easier?</h2>
        <div class="pricing-card pricing-card-horizontal"> <div class="pricing-card-cta">
          <a class="btn btn-block btn-theme-green btn-jumbotron" onclick="{openDevTool}" rel="nofollow">Công cụ hỗ trợ</a> </div>
          <div class="pricing-card-text display-heading-3 mb-0 text-thin">GitHub fosters a fast, flexible, and collaborative development process that lets you work on your own or with others.</div> </div>
      </div>
    </section>
        <script>
            var me = this;
            var root = me.root;

            var dialog = require('electron').remote.dialog;

            var newSite;
            me.sites = BackEnd.getSiteList();

            me.openSite = function (siteName) {
                me.unmount();
                riot.mount('home', {siteName: siteName});
            };

            me.createSite = function (name, sitePath) {
                return riot.api.createSite(name, sitePath);
            };

            me.showCreateSite = function () {
                me.tags['new-site'].show();
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
            //                riot.api.openSite(existSitePath);
            //                me.unmount();
            //            };
            const BrowserWindow = require('electron').remote.BrowserWindow
            const newWindowBtn = document.getElementById('frameless-window')

            me.openTutorial = function (event) {
              let win = new BrowserWindow({ frame: true,   width:1280, minWidth: 1080, height:   840, icon:     'favicon.ico' })
              win.on('closed', function () { win = null })
              win.loadURL('http://book.easywebhub.com/')
              win.show()
            }

            me.openDevTool = function (event) {
              let win = new BrowserWindow({ frame: true,   width:1280, minWidth: 1080, height:   840, icon:     'favicon.ico' })
              win.on('closed', function () { win = null })
              win.loadURL('http://electron.atom.io/docs/api/menu/')
              win.show()
            }
        </script>

</landing>
