<code-view>
    <pre>
        <code class="{ opts.language ? opts.language : ''}">{code}</code>
    </pre>

    <script>
        var me = this;
        me.code = opts.code;

        me.on('mount', function(){
            var codeElm = me.root.querySelector('code');
//            console.log(codeElm);
            hljs.highlightBlock(codeElm);
        });

        me.value = function(text) {
            if (text == undefined) {
                return me.code;
            } else {
                me.code = text;
                me.update();
            }
        }
    </script>
</code-view>
