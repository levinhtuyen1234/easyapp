<progress-dialog class="ui modal" tabindex="-1" role="dialog" data-backdrop="true">
    <div class="header">{title}</div>
    <div class="content">
        <pre style="height: 300px; overflow: auto;">
                    <code class="accesslog hljs"></code>
                </pre>
        <br>
        <span style="text-align: center;" show="{msg!=''}" class="msg"></span>
    </div>
    <div class="actions">
        <button type="button" class="ui button default ok" disabled="{!closable}" data-dismiss="modal">Close</button>
    </div>

    <script>
        var me = this;
        var shell = require('electron').shell;
        var modal = null;
        var output = null;

        me.title = '';
        me.text = '';
        me.closable = true;

        me.on('mount', function () {
            modal = $(me.root).modal({
                closable: false,
                keyboard: false
            });
            output = me.root.querySelector('code');

            modal.on('hide.bs.modal', function () {
                return me.closable;
            })
        });

        me.show = function (title) {
            me.title = title;
            me.text = '';
            me.msg = '';
            output.innerHTML = '';
            modal.modal('show');
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

        me.showMessage = function (msg) {
            me.root.querySelector('.msg').innerHTML = msg;
            me.msg = msg;
            //open links externally by default
            $(me.root.querySelectorAll('a')).on('click', function (event) {
                event.preventDefault();
                shell.openExternal(this.href);
            });
            me.update();
        };

        me.getText = function () {
            return me.text;
        };

        function scrollToBottom() {
            if (!output) return;
            output.parentNode.scrollTop = output.parentNode.scrollHeight
        }

        me.appendText = function (text) {
            var span = document.createElement('span');
            span.innerHTML = text;
            me.text += '\r\n' + text;
            output.appendChild(span);
            scrollToBottom();
        };
    </script>
</progress-dialog>
