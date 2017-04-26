<new-category-dialog class="ui modal" tabindex="-1">
    <i class="close icon"></i>
    <div class="header">Create new Category</div>
    <div class="content">
        <div class="ui form">
            <div class="inline fields">
                <label class="three wide field">Category Name</label>
                <div class="ui thirteen wide field">
                    <div class="ui fluid icon input">
                        <input type="text" id="categoryNameElm" placeholder="Name" oninput="{updateCategoryName}">
                    </div>
                </div>
            </div>
            <div class="inline fields">
                <label class="three wide field">Parent Category</label>
                <div class="ui thirteen wide field">
                    <div class="ui fluid selection dropdown" style="width: 100%">
                        <input class="parentCategory" type="hidden">
                        <i class="dropdown icon"></i>
                        <div class="default text">Choose Category</div>
                        <div class="menu">
                            <div class="item" data-value=""></div>
                            <div class="item" each="{category in categoryList}" data-value="{category.value}">{category.name}</div>
                        </div>
                    </div>
                </div>

            </div>
            <div class="inline fields">
                <label class="three wide field">Filename</label>
                <div class="thirteen wide field">
                    <div class="ui icon right labeled input">
                        <input type="text" id="categoryFilenameElm" readonly="{ User.accountType !== 'dev'}" placeholder="Filename">
                        <div class="ui label">.json</div>
                    </div>
                </div>
            </div>

            <!--   <div class="ui info message">
                   <div class="header"><i class="icon help circle"></i> NOTE: The "." of filename is used to define the relationship between 2 categories</div>
                   <div class="description">E.g
                       <div class="ui basic red label">category.sub-category.json</div>
                       belongs the
                       <div class="ui basic red label">category.json</div>
                   </div>
               </div>
               -->
        </div>
    </div>
    <div class="actions">
        <div class="ui button cancel">Cancel</div>
        <div class="ui button positive icon" disabled="{categoryName==''}" onclick="{add}">
            <i class="add icon"></i>
            Add
        </div>
    </div>

    <script>
        var me = this;
        var combining = /[\u0300-\u036F]/g;
        me.categoryName = '';
        me.categoryList = [];

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
            riot.event.trigger('addCategory', me.categoryName, me.categoryFilenameElm.value + '.json');
        };

        me.updateCategoryName = function (e) {
            me.categoryName = me.categoryNameElm.value;
            if (e && e.target && e.target.value) {
                me.categoryName = e.target.value.trim();
            }

            me.categoryFilenameElm.value = me.categoryName
                .toLowerCase()
                .normalize('NFKD')
                .replace(combining, '')
                .replace(/đ/g, 'd')
                .replace(/[?,!\/"*:;#$@\\()\[\]{}^~]*/g, '')
                .replace(/[.’']/g, ' ')
                .replace(/\s+/g, '-')
                .trim();
            let parentCategoryName = $(me.root).find('.parentCategory').val();
            if (parentCategoryName)
                me.categoryFilenameElm.value = parentCategoryName + '.' + me.categoryFilenameElm.value;

            me.update();
        };

        me.show = function () {
            me.categoryList = BackEnd.getCategoryList(me.opts.siteName);
            me.categoryList.forEach(function (category) {
                category.name = category.name.split('.').join(' / ');
            });

            console.log('show category add dialog');
            me.categoryName = '';
            me.categoryNameElm.value = '';
            me.categoryFilenameElm.value = '';
            $(me.root).modal('show');
            setTimeout(function () {
                $(me.categoryNameElm).focus();
            }, 500);

            $(me.root).find('.dropdown').dropdown({
                onChange: function (value, text, $choice) {
                    me.updateCategoryName();
                }
            });

            riot.event.one('closeNewCategoryDialog', function () {
                console.log('closeNewLayoutDialog');
                $(me.root).modal('hide');
            });
        }
    </script>
</new-category-dialog>
