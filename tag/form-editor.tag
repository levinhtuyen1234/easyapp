<form-editor id="{opts.id}" role="tabpanel" class="tab-pane {opts.active ? 'active':''}">
    <h1>FORM Editor</h1>
    <form class="form-horizontal" style="padding: 5px;">

    </form>
    <script>
        var me = this;
        me.form = null;

        me.on('mount', function () {
            me.form = me.root.querySelector('form');
            window.form = me.form;
        });

        function genSimpleInput(label, type, value) {
            if (type === 'boolean') {
                return `
                <div class="form-group">
                    <label for="" class="col-sm-2 control-label" style="text-align: left;">${label}</label>
                    <div class="col-sm-10">
                        <div class="checkbox">
                        <label>
                            <input type="checkbox" name="${label}" checked="${value}">
                        </label>
                        </div>
                    </div>
                </div>`;
            }
            return `
                <div class="form-group">
                    <label for="" class="col-sm-2 control-label" style="text-align: left;">${label}</label>
                    <div class="col-sm-10">
                        <input type="${type}" name="${label}" class="form-control" id="" placeholder="${label}" value="${value}">
                    </div>
                </div>`;
        }

        function genFormWithModel(form, model) {

        }

        function genFormWithoutModel(form) {
            var innerForm = '';

            for (var key in form) {
                if (!form.hasOwnProperty(key)) continue;
                var value = form[key];
                switch (typeof value) {
                    case 'string':
                        innerForm += genSimpleInput(key, 'text', value);
                        break;
                    case 'number':
                        innerForm += genSimpleInput(key, 'number', value);
                        break;
                    case 'boolean':
                        innerForm += genSimpleInput(key, 'boolean', value);
                        break;
                }
            }
            return innerForm;
        }

        me.getFormJson = function() {
            var inputs = me.form.find('input');
        };

        me.clear = function () {
            me.form.innerHTML = '';
        };

        me.parseForm = function (formData) {
            try {
                var formData = JSON.parse(formData);
                var innerFormInputs = genFormWithoutModel(formData);
                // TODO form with Model
                me.form.innerHTML = innerFormInputs;
                window.form = me.form;
            } catch(ex) {
                console.log('parseForm error', ex);
                me.clear();
            }
        };
    </script>
</form-editor>
