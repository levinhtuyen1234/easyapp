<config-view>
    <ul class="list-group" each="{contentConfig}">
        <li class="list-group-item">
            {name} - <strong>{type}</strong>
            <button class="btn btn-xs btn-danger pull-right" style="margin-left: 15px;"><i class="fa fa-close"></i></button>
            <button class="btn btn-xs btn-default pull-right"><i class="fa fa-gear"></i> Setting</button>
            <div class="clearfix"></div>
        </li>
    </ul>


    <script>
        var me = this;
        me.contentConfig = [];

        me.loadContentConfig = function (contentConfig) {
            console.log('[config-view] loadContentConfig', contentConfig);
            me.contentConfig = contentConfig;
            me.update();
        };
    </script>
</config-view>
