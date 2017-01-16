<new-tag-dialog class="ui modal" tabindex="-1">
    <i class="close icon"></i>
    <div class="header">Create new Tag</div>
    <div class="content">
        <div class="ui form">
            <div class="inline fields">
                <label class="two wide field">Tag Name</label>
                <div class="ui fourteen wide field">
                    <div class="ui icon input">
                        <input type="text" id="tagNameElm" placeholder="Name" oninput="{updateTagName}">
                    </div>
                </div>
            </div>
            <div class="inline fields">
                <label class="two wide field">Filename</label>
                <div class="fourteen wide field">
                    <div class="ui icon right labeled input">
                        <input type="text" id="tagFilenameElm" readonly="{ User.accountType !== 'dev'}" placeholder="Filename">
                        <div class="ui label">.json</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="actions">
        <div class="ui button cancel">Cancel</div>
        <div class="ui button positive icon" disabled="{tagName==''}" onclick="{add}">
            <i class="add icon"></i>
            Add
        </div>
    </div>

    <script>
        var me = this;
        var combining = /[\u0300-\u036F]/g;
        me.tagName = '';

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
            riot.event.trigger('addTag', me.tagName, me.tagFilenameElm.value + '.json');
        };

        me.updateTagName = function (e) {
            me.tagName = e.target.value.trim();
            me.tagFilenameElm.value = me.tagName
                    .toLowerCase()
                    .normalize('NFKD')
                    .replace(combining, '')
                    .replace(/đ/g, 'd')
                    .replace(/[?,!\/"*:;#$@\\()\[\]{}^~]*/g, '')
                    .replace(/[.’']/g, ' ')
                    .replace(/\s+/g, '-')
                    .trim();
            me.update();
        };

        me.show = function () {
            me.tagName = '';
            me.tagNameElm.value = '';
            me.tagFilenameElm.value = '';

            $(me.root).modal('show');
//            $(me.root).find('.selectpicker').selectpicker();
            setTimeout(function () {
                $(me.tagNameElm).focus();
            }, 500);

            riot.event.one('closeNewTagDialog', function () {
                $(me.root).modal('hide');
            });
        }
    </script>
</new-tag-dialog>
