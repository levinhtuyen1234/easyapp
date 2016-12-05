<dialog-new-site-local class="ui modal" tabindex="-1">
    <i class="close icon" show="{!cloning}"></i>
    <div class="header">Create new website</div>
    <div class="content">
        <!--<h3>List of EasyWebHub website template:</h3>-->
        <!--<div class="ui grid">-->
        <!--<div class="three wide column" each="{template in templateList}">-->
        <!--<div class="ui card site" style="text-align: center;" onclick="{selectSkeleton(template)}">-->
        <!--<div class="content">-->
        <!--<i class="add big link icon"></i>-->
        <!--<h4 class="header">{template.name}</h4>-->
        <!--</div>-->
        <!--</div>-->
        <!--</div>-->
        <!--</div>-->
        <!--<br>-->
        <div class="ui form error">
            <div class="field">
                <label>Choose name for your website</label>
                <input type="text" class="form-control" name="siteName" placeholder="" value={siteName} onkeyup="{siteNameChange}" disabled="{cloning}">
            </div>
            <div show="{errorMsg != ''}" class="ui error message">
                <p>{errorMsg}</p>
            </div>
        </div>

    </div>
    <div class="actions">
        <div class="ui deny button">Cancel</div>
        <div class="ui positive right labeled icon button {cloning ? 'loading' : ''}" disabled="{siteName==='' || template==null || cloning}" onclick="{createSite.bind(this, siteName)}">Create
            <i class="add icon"></i>
        </div>
    </div>

    <script>
        var me = this;
        me.mixin('form');
        var root = me.root;
        var dialog = require('electron').remote.dialog;

        me.templateList = [];
        try {
            me.templateList = JSON.parse(require('fs').readFileSync('template.json').toString()).templates;
        } catch (ex) {
            console.log(ex);
        }
        me.siteName = '';
        me.errorMsg = '';
        //        me.template = me.opts.template;
        me.cloning = false;

        me.show = function (template) {
            console.log('show', template);
            me.errorMsg = '';
            me.siteName = '';
            me.template = template;
            me.cloning = false;
            // active first skeleton
//            setTimeout(function () {
//                $(me.root.querySelector('.ui.card'))[0].click();
//            }, 1);

            me.update();
            $(root).modal({closable: false}).modal('show');
        };

        //        me.selectSkeleton = function (template) {
        //            return function (e) {
        //                me.template = template;
        //                console.log('selected template', template);
        //                $(me.root.querySelectorAll('.ui.card')).removeClass('blue');
        //                $(e.currentTarget).addClass('blue');
        //            }
        //        };

        me.siteNameChange = function (e) {
            if (e.keyCode == 13) { // ENTER key
                me.createSite(me.siteName);
            } else {
                me.siteName = e.target.value;
            }
        };

        me.hide = function () {
            $(root).modal('hide');
        };

        me.createSite = function (siteName) {
            me.cloning = 1;
            me.errorMsg = '';
            me.update();
            return me.parent.createSite(siteName, me.template.url, me.template.branch)
                .then(function (siteFolderName) {
                    me.cloning = 0;
                    me.update();
                    me.hide();
                    console.log('start open site', siteFolderName);
                    // open site using site folder name in disk not displayName
                    return me.parent.openSite({
                        name: siteFolderName
                    });
                }).catch(function (err) {
                    console.log('dialog-new-site-local createSite failed', err);
                    // stop loading animation
                    me.cloning = 0;
                    me.errorMsg = err.message;
                    me.update();
                });
        };

        me.showSelectDirDialog = function () {
            me.sitePath = dialog.showOpenDialog({
                title:      "Choose new site directory",
                properties: ['openDirectory']
            });
        }
    </script>
</dialog-new-site-local>
