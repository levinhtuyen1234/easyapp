<content role="tabpanel" class="tab-pane" id="content">
    <div class="row">
        <div class="col-sm-4 col-md-2">
            <table class="table table-responsive">
                <thead>
                <tr>
                    <th>Name</th>
                </tr>
                </thead>
                <tbody>
                <tr each="{dirEntries}">
                    <td>
                        <i class="fa { isDir ? 'fa-folder' : 'fa-file'}"></i>
                        <a class="pathName" onclick="{isDir ? scanDir.bind(this,path) : openFile.bind(this,path)}">
                            <i class="fa fa-level-up" show="{path == '..'}"></i> {name}
                        </a>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <div class="col-sm-5 col-md-7">
            <h1>EDITOR</h1>
        </div>
    </div>

    <script>
        //
//        var myCodeMirror = CodeMirror(document.body, {
//            value: "function myScript(){return 100;}\n",
//            mode:  "javascript"
//        });

    </script>
</content>
