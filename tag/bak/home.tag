<home>
    <nav></nav>
    <div class="container-fluid" style="padding-top: 60px;">
        <div class="tab-content">
            <content dir={opts.sitePath}></content>
            <setting dir={opts.sitePath}></setting>
            <layout dir={opts.sitePath}></layout>
            <review dir={opts.sitePath}></review>
            <build dir={opts.sitePath}></build>
        </div>
    </div>

    <script>
        var Path = require('path');
        var me = this;
//        me.layoutPath = Path.join(opts.sitePath, 'layout');
//        var sitePath = opts.sitePath;
//        riot.mount($('#browseTab'), opts);
    </script>
</home>
