<markdown-editor>
    <div></div>
    <script>
        var me = this;
        var simplemde = new SimpleMDE({element: $("#MyID")[0]});
        var editor;

        me.on('mount', function () {
            editor = new SimpleMDE({element: me.root.querySelector('div')});
        });

        me.value = function (val) {
            if (val === undefined)
                return editor.value();
            editor.value(val);
        };

        window.onresize(function (e) {
            window.e = e;
            console.log(e.target);
            // editor.toggleSideBySide();
        });
    </script>
</markdown-editor>
