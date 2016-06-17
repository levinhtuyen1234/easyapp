<setting role="tabpanel" class="tab-pane" id="setting">
    <!-- Nav tabs -->
    <ul class="nav nav-tabs" role="tablist">
        <li role="presentation" class="active"><a href="#settingForm" aria-controls="home" role="tab" data-toggle="tab">Form</a></li>
        <li role="presentation"><a href="#settingRaw" aria-controls="settingRaw" role="tab" data-toggle="tab">Raw</a></li>
    </ul>
    <!-- Tab panes -->
    <div class="tab-content">
        <div role="tabpanel" class="tab-pane active" id="settingForm">

        </div>
        <div role="tabpanel" class="tab-pane" id="settingRaw">
            <code-view></code-view>
        </div>
    </div>

    <script>
        var me = this;
        var Fs = require('fs');
        var Path = require('path');

        var siteFolder = opts.dir.split(Path.sep).pop();
        var root = Path.join(__dirname, 'sites', siteFolder);

        me.on('mount', function() {
            var siteFileContent = Fs.readFileSync(Path.join(root, 'site.js')).toString();
            this.tags['code-view'].setText(siteFileContent);
        });

    </script>
</setting>
