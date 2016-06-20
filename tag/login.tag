<login>
    <!-- HTML TAG START -->
    <button onclick="{login}">Login</button>
    <!-- HTML TAG END -->

    <script>
        var me = this;
        me.login = function() {
            me.unmount();
            riot.mount('landing');
        }
    </script>
</login>
