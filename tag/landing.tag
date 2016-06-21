<landing >
    <button onclick="{goToHome}">Logout</button>
    <section >
      <div class="container">
        <div class="row">
            <new-site></new-site>
            <div class="col-sm-6 col-md-3">
                <div class="thumbnail">
                    <div class="caption">
                        <div style="text-align: center"><i class="fa fa-plus fa-4x"></i></div>
                        <div style="text-align: center">
                            <p><a href="#" class="btn btn-primary" role="button" onclick={showCreateSite}>Create new site</a></p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-md-3" each={sites}>
                <div class="thumbnail siteThumbnail" style="height: 126px;" onclick={openSite.bind(this,name)}>
                    <div class="caption" style="text-align: center">
                        <!--<img src={imgSrc} class="siteThumbnailImg" alt="Site Thumbnail">-->
                        <h1>{name}</h1>
                    </div>
                </div>
            </div>
        </div>
      </div>
    </section>

    <section class="section-call-action bg-gray-light" style="opacity: 1;background-color: #EBEBEB;color: #5B5B5B;padding-top: 40px; padding-bottom: 40px;">
      <div class="container center">
        <div class="row">
          <div class="col-md-12">
            <h3 class="section-title">A New Member? We have a lot of Tutorials, help you build website.</h3>
          </div>
          <div class="col-md-12">
            <button class="btn btn-primary">Getting Started</button>
          </div>
        </div>
      </div>
    </section>
    <section class="section-call-action" style="background-color: #7F8C8D; color: #5B5B5B; padding-top: 40px; padding-bottom: 40px;">
      <div class="container center">
        <div class="row">
          <div class="col-md-12">
            <h3 class="section-title">To speed up progress? We have a lot of Tools to help you build website faster.</h3>
          </div>
          <div class="col-md-12">
            <button class="btn btn-primary">View Tools</button>
          </div>
        </div>
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

            me.goToHome = function(){
                me.unmount();
                riot.mount('login');
            }
        </script>

</landing>
