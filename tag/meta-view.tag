<meta-view>
    <!--<form-editor></form-editor>-->
    <!--<script>-->
        <!--var me = this;-->

        <!--me.setContent = function (content, contentConfig) {-->
<!--//            console.log('me.tags', me.tags);-->
<!--//            console.log('contentConfig', contentConfig);-->
            <!--// gen content form-->
            <!--me.tags['form-editor'].genForm(content, contentConfig);-->
            <!--// set markdown editor content-->
        <!--};-->

        <!--me.reset = function () {-->
            <!--me.tags['form-editor'].clear();-->
        <!--};-->

        <!--me.getContent = function () {-->
            <!--return me.tags['form-editor'].getForm();-->
        <!--}-->
    <!--</script>-->
    <json-schema-form-editor site-name="{siteName}"></json-schema-form-editor>
    <script>
        var me = this;

        me.siteName = me.opts.siteName;

        console.log('meta-view', me.siteName);

        me.setContent = function (content, contentConfig) {
//            console.log('me.tags', me.tags);
//            console.log('contentConfig', contentConfig);
            // gen content form
            me.tags['json-schema-form-editor'].genForm(content, contentConfig);
            // set markdown editor content
        };

        me.reset = function () {
            me.tags['json-schema-form-editor'].clear();
        };

        me.getContent = function () {
            return me.tags['json-schema-form-editor'].getForm();
        }
    </script>
</meta-view>
