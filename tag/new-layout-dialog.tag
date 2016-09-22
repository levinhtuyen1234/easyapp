<new-layout-dialog class="ui modal" tabindex="-1">
    <i class="close icon"></i>
    <div class="header">Create new Layout</div>
    <div class="content">
        <div class="ui form">
            <div class="ui info message">
                <div class="header"><i class="icon help circle"></i>Apply for one or multiple webpage, using HTML, CSS and <a href="http://handlebarsjs.com">HandlebarJS</a> code</div>
            </div>
            <div class="required field">
                <label>Filename</label>
                <div class="ui fluid icon right labeled input">
                    <input type="text" id="layoutNameElm" placeholder="Filename" oninput="{updateFileName}">
                    <div class="ui label">{postFix}</div>
                </div>
            </div>
            <div class="grouped fields">
                <label>Layout type (click <a href="http://blog.easywebhub.com/syntax-of-easywebhub/" target="_blank">here</a> for a clear explanation)</label>
                <div class="field">
                    <div class="ui radio checkbox">
                        <input name="categoryType" onchange="{updatePostFix}" value="partial" type="checkbox">
                        <label>Is a Partial layout
                            <a class="info" href="http://handlebarsjs.com/partials.html" target="_blank">
                                <i class="circle help icon"></i>
                            </a>
                        </label>
                    </div>
                </div>
                <div class="field">
                    <div class="ui radio checkbox">
                        <input name="categoryType" onchange="{updatePostFix}" value="category" type="checkbox">
                        <label>Is the layout of a Category</label>
                    </div>
                </div>
                <div class="field">
                    <div class="ui radio checkbox">
                        <input name="categoryType" onchange="{updatePostFix}" value="tag" type="checkbox">
                        <label>Is the layout of a Tag</label>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="actions">
        <div class="ui button cancel">Cancel</div>
        <div class="ui button positive icon" disabled="{layoutName==''}" onclick="{add}">
            <i class="add icon"></i>
            Add
        </div>
    </div>
    <script>
        var me = this;
        me.layoutName = '';
        me.postFix = '.html';
        me.isCategory = false;

        me.on('mount', function(){
            $('.ui.checkbox').checkbox();
        });

        me.edit = function (name, e) {
            switch (e.target.type) {
                case 'checkbox':
                    me[name] = e.target.checked;
                    break;
                default:
                    me[name] = e.target.value;
            }
        };

        me.add = function () {
            riot.event.trigger('addLayout', me.layoutName + me.postFix);
        };

        me.updatePostFix = function (e) {
            if (e.srcElement.checked) {
                $(me.root.querySelectorAll('input[type="checkbox"]')).attr('checked', false);
                e.srcElement.checked = true;
                me.postFix = '.' + e.srcElement.value + '.html';
            } else {
                me.postFix = '.html';
            }

            me.update();
        };

        me.updateFileName = function (e) {
            var title = e.target.value;

            var combining = /[\u0300-\u036F]/g;
            title = title
                    .toLowerCase()
                    .normalize('NFKD')
                    .replace(combining, '')
                    .replace(/đ/g, 'd')
                    .replace(/[?,!\/'":;#$@\\()\[\]{}^~]*/g, '')
                    .replace(/\s+/g, '-')
                    .trim();
            me.layoutName = title;
//
            me.update();
        };


        me.show = function () {
            me.layoutName = '';
            me.layoutNameElm.value = '';
            $(me.root).modal('show');
            $(me.root).find('.selectpicker').selectpicker();
            var fieldFileName = $(me['layout-filename']);
            fieldFileName.val('');
            setTimeout(function () {
                fieldFileName.focus();
            }, 500);

            riot.event.one('closeNewLayoutDialog', function () {
                console.log('closeNewLayoutDialog');
                $(me.root).modal('hide');
            });
        }
    </script>
</new-layout-dialog>
