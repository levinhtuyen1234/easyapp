<copy-progress-dialog class="ui modal" data-id="copyProgressDialog">
    <div class="header">{title}</div>
    <div class="content" style="padding: 0">
        <div class="ui segment" style="height: 110px">
            <div class="ui active inverted dimmer">
                <div class="ui indeterminate text loader"></div>
            </div>
            <p></p>
        </div>
    </div>

    <script>
        var me = this;
        me.title = '';
        me.closable = false;
        var modalElm, textLoaderElm;

        me.show = function (title) {
//            console.log('show copy dialog');
            me.reset();
            me.title = title;
            me.update();

            modalElm.modal('show');
        };

        me.hide = function () {
//            console.log('hide copy dialog');
            modalElm.modal('hide');
        };

        me.step = function (copyingFile) {
//            console.log('on step', copyingFile, textLoaderElm);
            window.textLoaderElm = textLoaderElm;
            textLoaderElm.text(`Copying File ${copyingFile}`);
        };

        me.reset = function () {
            me.currentFile = '';
            me.update();
            me.closable = false;
        };

        me.on('mount', function () {
            modalElm = $(me.root).modal({closable: false});
            textLoaderElm = $(me.root).find('.text.loader');
        });

        me.on('unmount', function () {

        });
    </script>

    <style>

    </style>
</copy-progress-dialog>
