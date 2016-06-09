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

        me.setText = function(text) {
//            console.log('setText', text.length);
            me.code = text;
            me.update();
        }
    </script>
</code-view>
