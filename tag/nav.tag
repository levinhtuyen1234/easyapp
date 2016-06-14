<nav class="navbar navbar-default navbar-fixed-top">
    <div class="navbar-header">
        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </button>
    </div>
    <div class="navbar-collapse collapse">
        <div class="container-fluid">
            <ul class="nav navbar-nav">
                <li><a href="#setting" data-toggle="tab"><i class="fa fa-cog"></i> Setting</a></li>
                <li class="active"><a href="#content" data-toggle="tab"><i class="fa fa-newspaper-o"></i> Content</a></li>
                <li><a href="#layout" data-toggle="tab"><i class="fa fa-file-code-o"></i> Layout</a></li>
                <li><a href="#review" title="open review tab" data-toggle="tab"><i class="fa fa-eye"></i> Review</a></li>
                <li><a href="#build" title="open build tab" data-toggle="tab"><i class="fa fa-terminal"></i> Log</a></li>
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <li class="">
                    <div class="btn-group" role="group" aria-label="...">
                        <button type="button" class="btn btn-default navbar-btn" title="Review in external browser" onclick="{openExternalReview}"><i class="fa fa-globe"></i></button>
                    </div>
                </li>
            </ul>
        </div>
    </div>

    <script>
        var me = this;
        var shell = require('electron').shell;

        me.openExternalReview = function () {
            shell.openExternal('http://electron.atom.io');
        }

    </script>
</nav>
