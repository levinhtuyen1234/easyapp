<landing class="container">
    <button onclick="{goToHome}">GotoHome</button>
    <div class="row">
        <new-site></new-site>
        <div class="col-sm-6 col-md-3">
            <div class="thumbnail">
                <div class="caption">
                    <div style="text-align: center"><i class="fa fa-plus fa-4x"></i></div>
                    <div style="text-align: center">
                        <p><a href="#" class="btn btn-primary" role="button" onclick={showCreateSite}>Create new site</a></p>
                        <!--<p>OR</p>-->
                        <!--<p><a href="#" class="btn btn-default" role="button" onclick={openSite}>Open exists site</a></p>-->
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
                riot.mount('home', {siteName: 'aaa'});
            }
        </script>
    </div>
</landing>
