<home>
    <nav></nav>
    <div class="tab-content">
        <content></content>
        <setting></setting>
        <browse dir={opts.sitePath}></browse>
        <review></review>
    </div>

    <script>
        var sitePath = opts.sitePath;
        riot.mount($('#browseTab'), opts);
    </script>
</home>
