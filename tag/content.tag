<content role="tabpanel" class="tab-pane active" id="content">
    <div class="row">
        <div class="col-sm-5 col-lg-4">
            <browse dir="{contentPath}"></browse>
        </div>
        <div class="col-sm-7 col-lg-8">
            <!-- Nav tabs -->
            <ul class="nav nav-tabs" role="tablist">
                <li role="presentation" class="active"><a href="#content-form-editor" aria-controls="form-editor" role="tab" data-toggle="tab" data-name="form">Form</a></li>
                <li role="presentation"><a href="#content-raw-editor" aria-controls="raw-editor" role="tab" data-toggle="tab" data-name="raw">Raw</a></li>
            </ul>
            <!-- Tab panes -->
            <div class="tab-content">
                <form-editor id="{'content-form-editor'}" active="{'true'}"></form-editor>
                <code-editor id="{'content-raw-editor'}"></code-editor>
            </div>
        </div>
    </div>

    <script>
        var Path = require('path');
        var me = this;
        window.me = me;

        me.contentPath = Path.join(opts.dir, 'content');

        me.on('mount', function() {
            // refresh codemirror editor khi tab duoc active
            $(me.root).find('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                if (e.target.dataset.name === 'raw') {
                    me.tags['code-editor'].refresh();
                }
            })
        });

        me.openFile = function (filePath) {
            try {
                var fileContent = Fs.readFileSync(filePath).toString();
                me.tags['code-editor'].setValue(fileContent);
            } catch(ex) {
                console.log('content tab open file failed', ex);
            }
        };
    </script>
</content>
