<code-view>
    <pre>
        <code class="{ opts.language ? opts.language : ''}">{code}</code>
    </pre>

    <script>
        var me = this;
        me.code = opts.code ? opts.code : '';

        me.on('mount', function(){
            var codeElm = me.root.querySelector('code');
            hljs.highlightBlock(codeElm);
        });

        me.value = function(text) {
            if (text == undefined) {
                return me.code;
            } else {
                me.code = text;
                var codeElm = me.root.querySelector('code');
                codeElm.innerHTML = text;
                hljs.highlightBlock(codeElm);
            }
        }
    </script>
</code-view>
