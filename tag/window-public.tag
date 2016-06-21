<window-public>
    <!-- HTML TAG START -->
    <h1>PUBLIC WINDOW</h1>

    <!-- HTML TAG END -->

    <script>
        var me = this;
        me.backtoHome = function() {
            me.unmount();
            riot.mount('login');
        }
    </script>
</window-public>
