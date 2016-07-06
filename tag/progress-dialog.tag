<progress-dialog class="modal fade" tabindex="-1" role="dialog" data-backdrop="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">{title}</h4>
            </div>
            <div class="modal-body">
                <pre style="height: 300px; overflow: auto;">
                    <code class="accesslog hljs"></code>
                </pre>
                <br>
                <center>
                    <button type="button" class="btn btn-default" disabled="{closable}" data-dismiss="modal">Close</button>
                </center>
            </div>
        </div>
    </div>
    <script>
        var me = this;
        var modal = null;
        var output = null;

        me.title = '';
        me.closable = true;

        me.on('mount', function () {
            modal = $(me.root);
            output = me.root.querySelector('code');

            modal.on('hide.bs.modal', function(){
                return me.closable;
            })
        });

        me.show = function (title) {
            me.title = title;
            output.innerHTML = '';
            modal.modal({
                backdrop: 'static',
                keyboard: false
            });
            me.closable = false;
            me.update();
        };

        me.hide = function () {
            me.closable = true;
            me.update();
            modal.modal('hide');
        };

        me.enableClose = function () {
            me.closable = true;
            me.update();
        };

        me.disableClose = function () {
            me.closable = false;
            me.update();
        };

        function scrollToBottom() {
            if (!output) return;
            output.parentNode.scrollTop = output.parentNode.scrollHeight
        }

        me.appendText = function (text) {
            var span = document.createElement('span');
            span.innerHTML = text;
            output.appendChild(span);
            scrollToBottom();
        };
    </script>
</progress-dialog>
