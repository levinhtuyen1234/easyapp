<new-layout-dialog class="ui small modal" tabindex="-1">
    <i class="close icon"></i>
    <div class="header">Create new Layout</div>
    <div class="content">
        <div class="ui form">
            <div class="ui info message">
                <div class="header"><i class="icon help circle"></i>Apply for one or multiple webpage, using HTML, CSS and <a href="http://handlebarsjs.com">HandlebarJS</a> code</div>
            </div>
            <div class="required inline fields">
                <label class="two wide field">Filename</label>
                <div class="ui fourteen wide field">
                    <div class="ui right labeled input" style="width: 100%;">
                        <div show="{prefix!=''}" class="ui label">{prefix}</div>
                        <input class="layoutName" type="text" placeholder="Filename" oninput="{updateFileName}">
                        <div class="ui label">{postfix}</div>
                    </div>
                </div>
            </div>

            <div class="grouped fields">
                <label>Layout type (click <a href="http://blog.easywebhub.com/syntax-of-easywebhub/" target="_blank">here</a> for a clear explanation)</label>
                <div class="field">
                    <div class="ui radio checkbox">
                        <input name="categoryType" onchange="{updatePath}" data-prefix="partial/" data-postfix=".html" type="checkbox">
                        <label>Is a Partial layout
                            <a class="info" href="http://handlebarsjs.com/partials.html" target="_blank">
                                <i class="circle help icon"></i>
                            </a>
                        </label>
                    </div>
                </div>
                <div class="field">
                    <div class="ui radio checkbox">
                        <input name="categoryType" onchange="{updatePath}" data-prefix="" data-postfix=".category.html" type="checkbox">
                        <label>Is the layout of a Category</label>
                    </div>
                </div>
                <div class="field">
                    <div class="ui radio checkbox">
                        <input name="categoryType" onchange="{updatePath}" data-prefix="" data-postfix=".tag.html" type="checkbox">
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
        me.mixin('form');
        me.layoutName = '';
        me.postfix = '.html';
        me.prefix = '';
        me.isCategory = false;

        me.on('mount', function () {
            $('.ui.checkbox').checkbox();
        });

        me.add = function () {
            riot.event.trigger('addLayout', me.prefix + me.layoutName + me.postfix);
        };

        me.updatePath = function (e) {
            if (e.srcElement.checked) {
                $(me.root.querySelectorAll('input[type="checkbox"]')).attr('checked', false);
                e.srcElement.checked = true;
                me.postfix = e.srcElement.dataset.postfix;
                me.prefix = e.srcElement.dataset.prefix;
            } else {
                me.postfix = '.html';
                me.prefix = '';
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
                    .replace(/[?,!\/"*:;#$@\\()\[\]{}^~]*/g, '')
                    .replace(/[.’']/g, ' ')
                    .replace(/\s+/g, '-')
                    .trim();
            me.layoutName = title;
//
            me.update();
        };


        me.show = function () {
            me.layoutName = '';
            $(me.root).modal('show');
            $(me.root).find('.selectpicker').selectpicker();
            var fieldFileName = $(me.root).find('.layoutName');
            fieldFileName.val('');
            $(me.root).find('input[type="checkbox"]').attr('checked', false);
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
