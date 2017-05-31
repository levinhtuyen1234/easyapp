<ckeditor>
    <textarea ref="ckeditorInput" style="display:none"></textarea>

    <script>
        var me = this;
        me.value = me.opts.value || '';
        me.editor = null;
        me.viewOnly = me.opts.viewonly;

        var defaultToolbarGroups = [
            { name: 'clipboard', groups: [ 'undo', 'clipboard' ] },
			{ name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
			{ name: 'colors', groups: [ 'colors' ] },
			{ name: 'document', groups: [ 'mode', 'document', 'doctools' ] },
			{ name: 'editing', groups: [ 'find', 'selection', 'spellchecker', 'editing' ] },
			{ name: 'forms', groups: [ 'forms' ] },
			{ name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align', 'bidi', 'paragraph' ] },
			{ name: 'styles', groups: [ 'styles' ] },
			{ name: 'insert', groups: [ 'insert' ] },
			{ name: 'links', groups: [ 'links' ] },
			{ name: 'tools', groups: [ 'tools' ] },
			{ name: 'others', groups: [ 'others' ] },
			{ name: 'about', groups: [ 'about' ] }
        ];
	    
		me.toolbarGroups = me.opts.toolbarGroups || defaultToolbarGroups;
         
		var MaximumRemoveButton = 'Form,Checkbox,Radio,TextField,Textarea,Select,Button,ImageButton,HiddenField,About,Maximize,ShowBlocks,Styles,Format,Font,FontSize,Image,Flash,SpecialChar,PageBreak,Iframe,Link,Unlink,Anchor,BidiLtr,BidiRtl,Language,CreateDiv,CopyFormatting,RemoveFormat,Print,Preview,NewPage,Save,PasteFromWord,Find,Replace,Cut,Copy,Paste,PasteText,Templates,JustifyBlock';
		
        var removeButtons = 'Templates,Preview,Print,Save,NewPage,SelectAll,Language,Flash,PageBreak,Iframe,Maximize,ShowBlocks,About,RemoveFormat,CopyFormatting,Find,Textarea,Select,Button,ImageButton,HiddenField,Checkbox,Radio,TextField,Form,CreateDiv,BidiLtr,BidiRtl,Anchor';
		
		me.removeButtons = removeButtons;
		
        me.on('mount', function () {
            var ckeditorElm = $(me.root).find('[ref="ckeditorInput"]');
            me.editor = $(ckeditorElm).ckeditor({
                toolbarGroups: me.toolbarGroups,
				removeButtons : me.removeButtons
            });
        });

        me.on('unmount', function () {
            try {
                CKEDITOR.instances[me.editor[0].name].destroy(false);
            } catch (err) {
                console.log('unmount ckeditor error', err);
            }
        });

        me.getValue = function () {
            if (!me.editor) return '';
            return me.editor.val();
        };

        me.setValue = function (val) {
            if (!me.editor) return;
            me.editor.val(val);
        };
    </script>

    <style>

    </style>
</ckeditor>
