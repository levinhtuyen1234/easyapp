#### config sites.js array or object like bellow
#### (note) root of indexPath is site's build folder

  - `fields`: {`contents`: `1`}
  - `ref`: `filePath`
  - `indexPath`: `searchIndex.json`
  
#### add config to site.js bellow metalsmith-markdown
```
'metalsmith-lunr': [
		{
			indexPath: 'index.json',
			fields: {
				title: 1,
				description: 1
			}
		},
		{
			indexPath: 'searchIndex.json',
			fields: {
				header: 1
			}
		}
	],
```

#### Usage in html page
- include [lunr.js](https://raw.githubusercontent.com/olivernn/lunr.js/master/lunr.js) or [lunr.min.js](https://raw.githubusercontent.com/olivernn/lunr.js/master/lunr.min.js) (lưu ý phải trùng phiên bản với lunr trong metalsmith-lurn, hiện tại là 0.7.2)
- load index json file and create lunrIndex object
- start search
```
// load index json file bang jquery
var searchIndex = $.ajax({url: 'searchIndex.json', method: 'GET', dataType: 'json'})
    .done(function(data) {
        // create lunr index object, lunr là global object có sau khi load lunr.js
        var idx = lunr.Index.load(data);
        var results = idx.search($('THING TO SEARCH');
        console.log('search results', results);
    });
```

#### result search
```
[
    {
        "ref": "overview-the-websites-structure.html",
        "score": 0.26385274210763865
    },
    {
        "ref": "docs-create-website.html",
        "score": 0.24503493573429486
    },
    {
        "ref": "how-to-add-content-of-websites.html",
        "score": 0.22452432919042387
    },
    {
        "ref": "advantages-of-easywebs-websites.html",
        "score": 0.15465407004344045
    },
    {
        "ref": "create-one-page-website-from-template-[sumolanding].html",
        "score": 0.1306388054193376
    },
    {
        "ref": "how-to-use-easywebbuilder-to-build-websites.html",
        "score": 0.11423117608368885
    },
    {
        "ref": "easyprototype,-an-innovative-approach-for-building-websites.html",
        "score": 0.10759030082981347
    },
    {
        "ref": "docs-build-on-local.html",
        "score": 0.046587360458940026
    },
    {
        "ref": "docs-whats-easyweb.html",
        "score": 0.012789118645989226
    },
    {
        "ref": "docs-start-installation.html",
        "score": 0.0054261842641153
    }
]
```
