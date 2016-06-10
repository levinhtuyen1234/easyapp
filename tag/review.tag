<review role="tabpanel" class="tab-pane" id="review">
    <iframe width="100%" height="100%" frameborder="0" src="{extUrl}"></iframe>

    <script>
        var me = this;
        me.extUrl = 'http://localhost:8088';

        me.setUrl = function(url) {
            me.extUrl = url;
            me.update();
        }
    </script>
</review>
