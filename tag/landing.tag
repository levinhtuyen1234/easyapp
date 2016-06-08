<landing class="container">
    <div class="row">
        <new-site></new-site>
        <div class="col-sm-6 col-md-3">
            <div class="thumbnail">
                <div class="caption">
                    <div style="text-align: center"><i class="fa fa-plus fa-4x"></i></div>
                    <div style="text-align: center">
                        <p><a href="#" class="btn btn-primary" role="button" onclick={showCreateSite}>Create new site</a></p>
                        <p>OR</p>
                        <p><a href="#" class="btn btn-default" role="button" onclick={openSite}>Open exists site</a></p>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-md-3" each={sites}>
            <div class="thumbnail siteThumbnail" style="height: 202px;" onclick={selectSite.bind(this,path)}>
                <div class="caption">
                    <img src={imgSrc} class="siteThumbnailImg" alt="Site Thumbnail">
                    <h5>{name}</h5>
                </div>
            </div>
        </div>

        <script>
            //        this.sites = opts.sites
            var me = this;
            var Path = require('path');
            var root = me.root;
            var dialog = require('electron').remote.dialog;

            var newSite;
            me.sites = [
                {
                    path:   "sites/s1",
                    imgSrc: "tmp/thumbnail_1.jpg",
                    name:   "My Site 1"
                },
                {
                    path:   "sites/s2",
                    imgSrc: "tmp/thumbnail_2.jpg",
                    name:   "My Site 2"
                },
                {
                    path:   "sites/s3",
                    imgSrc: "tmp/thumbnail_1.jpg",
                    name:   "My Site 1"
                },
                {
                    path:   "sites/s4",
                    imgSrc: "tmp/thumbnail_2.jpg",
                    name:   "My Site 2"
                },
                {
                    path:   "sites/s5",
                    imgSrc: "tmp/thumbnail_1.jpg",
                    name:   "My Site 1"
                },
                {
                    path:   "sites/s6",
                    imgSrc: "tmp/thumbnail_2.jpg",
                    name:   "My Site 2"
                }
            ];

            me.selectSite = function (path) {
                console.log('select site', path);
            };

            me.createSite = function (name, sitePath) {
                return me.mixin('api').createSite(name, sitePath);
            };

            me.showCreateSite = function () {
                console.log('createSize');
                me.tags['new-site'].show();
            };

            me.openSite = function () {
                console.log('onOpenSite', Path.join(__dirname, 'sites'));

                var existSitePath = dialog.showOpenDialog({
                    title:       'Choose exists site directory',
                    defaultPath: Path.join(__dirname, '..', 'sites'),
                    properties:  ['openDirectory']
                });
                if (existSitePath === undefined) return;
                me.mixin('api').openSite(existSitePath);
                me.unmount();
            };
        </script>
    </div>
</landing>
