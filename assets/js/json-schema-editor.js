"use strict";
var schemas = {
    object:  {
        "$schema":    "http://json-schema.org/draft-04/schema#",
        "type":       "object",
        "properties": {
            "description":   {
                "type":    "string",
                "default": ""
            },
            "propertyOrder": {
                "type":    "integer",
                "default": "1000"
            }
        }
    },
    string:  {
        "$schema":    "http://json-schema.org/draft-04/schema#",
        "type":       "object",
        "properties": {
            "description":   {
                "type":    "string",
                "default": ""
            },
            "default":       {
                "type":    "string",
                "default": ""
            },
            "format":        {
                "type":    "string",
                "enum":    [
                    "color", "date", "datetime", "datetime-local", "email", "month", "number", "range", "tel", "text", "textarea", "time", "url", "week"
                ],
                "default": "text"
            },
            "required":      {
                "type":    "boolean",
                "default": false
            },
            "readOnly":      {
                "type":    "boolean",
                "default": false
            },
            "pattern":       {
                "type":    "string",
                "default": ""
            },
            "propertyOrder": {
                "type":    "integer",
                "default": "1000"
            },
            "minLength":     {
                "type":      "integer",
                "default":   "",
                "minLength": 0
            },
            "maxLength":     {
                "type":    "integer",
                "default": ""
            }
        },
        "required":   ["required", "readOnly", "format", "propertyOrder"]
    },
    number:  {
        "$schema":    "http://json-schema.org/draft-04/schema#",
        "type":       "object",
        "properties": {
            "format":           {
                "type":    "string",
                "enum":    [
                    "color", "date", "datetime", "datetime-local", "email", "month", "number", "range", "tel", "text", "textarea", "time", "url", "week"
                ],
                "default": "text"
            },
            "multipleOf":       {
                "type": "integer"
            },
            "maximum":          {
                "type": "integer"
            },
            "minimum":          {
                "type": "integer"
            },
            "exclusiveMaximum": {
                "type":        "boolean",
                "description": `If "exclusiveMaximum" is true, then a numeric instance SHOULD NOT be equal to the value specified in "maximum". If "exclusiveMaximum" is false (or not specified), then a numeric instance MAY be equal to the value of "maximum"`
            },
            "exclusiveMinimum": {
                "type": "boolean"
            },
            "propertyOrder":    {
                "type":    "integer",
                "default": "1000"
            }
        }
    },
    integer: {
        "$schema":    "http://json-schema.org/draft-04/schema#",
        "type":       "object",
        "properties": {
            "format":           {
                "type":    "string",
                "enum":    [
                    "color", "date", "datetime", "datetime-local", "email", "month", "number", "range", "tel", "text", "textarea", "time", "url", "week"
                ],
                "default": "text"
            },
            "multipleOf":       {
                "type": "integer"
            },
            "maximum":          {
                "type": "integer"
            },
            "minimum":          {
                "type": "integer"
            },
            "exclusiveMaximum": {
                "type":        "boolean",
                "description": `If "exclusiveMaximum" is true, then a numeric instance SHOULD NOT be equal to the value specified in "maximum". If "exclusiveMaximum" is false (or not specified), then a numeric instance MAY be equal to the value of "maximum"`
            },
            "exclusiveMinimum": {
                "type": "boolean"
            },
            "propertyOrder":    {
                "type":    "integer",
                "default": "1000"
            }
        }
    },
    array:   {
        "$schema":    "http://json-schema.org/draft-04/schema#",
        "type":       "object",
        "properties": {
            "uniqueItems":   {
                "type":    "boolean",
                "default": false
            },
            "items":         {
                "type":       "object",
                // "default":    {type: '', properties: {}},
                "properties": {
                    "title":      {
                        "type":    "string",
                        "default": ""
                    },
                    "type":       {
                        "type":    "string",
                        "enum":    [
                            "string", "integer", "number", "array", "object"
                        ],
                        "default": "string"
                    },
                    "properties": {
                        "type": "object"
                    }
                }
            },
            "propertyOrder": {
                "type":    "integer",
                "default": "1000"
            }
        }
    }
};

function getDefaultValueFromSchema(schema) {
    let ret = {};
    if (!schema.properties) return ret;
    for (var prop in schema.properties) {
        if (!schema.properties.hasOwnProperty(prop)) continue;
        if (schema.properties[prop].default)
            ret[prop] = schema.properties[prop].default;
        else
            ret[prop] = '';
    }
    return ret;
}

// chinh sua lai property cho phu hop voi tung type
function cleanUpProperties(configType, configValue) {
    configValue.type = configType;
    switch (configType) {
        case 'string':
            delete configValue.properties;
            break;
        case 'number':
            delete configValue.properties;
            break;
        case 'interger':
            delete configValue.properties;
            break;
        case 'object':
            if (!configValue.properties || typeof(configValue.properties) != 'object' || Array.isArray(configValue.properties))
                configValue.properties = {};
            // insert default type string for property
            for (var key in configValue.properties) {
                if (!configValue.properties.hasOwnProperty(key)) continue;
                if (configValue.properties[key] == null)
                    configValue.properties[key] = {type: 'string'};
            }
            break;
        case 'array':
            delete configValue.properties;
            break;
    }
    return configValue;
}

var JsonSchemaEditor = function (schema) {
    var me = this;

    var modalTemplate = `
        <div class="ui modal" style="overflow-y: auto;">
            <div class="header">Edit Field <span class="fieldName"></span></div>
            <div class="content bootstrap-iso">        
            </div>
            <div class="actions">
                <div class="ui deny button">Cancel</div>
                <div class="ui blue right labeled icon button saveBtn">Save
                    <i class="save icon"></i>
                </div>
            </div>
        </div>`;


    function mergeConfig(schema, configPath, configValue) {
        console.log('mergeConfig', schema, configPath, configValue);
        var parts = configPath.split('.');
        parts.shift(); // remove root
        var ret = schema;

        return parts.some(function (key, index) {
            if (!ret.properties) return false;
            if (index === parts.length - 1) {
                // // merge value from object configValue to ret.properties[key]
                // for (var configKey in configValue) {
                //     if (!configValue.hasOwnProperty(configKey)) continue;
                //     ret.properties[key][configKey] = configValue[configKey];
                // }
                // simple replace
                ret.properties[key] = configValue;
                return true;
            } else {
                ret = ret.properties[key];
            }
            return typeof(ret) !== 'object';
        })
    }

    function getConfig(schema, configPath) {
        var parts = configPath.split('.');
        parts.shift(); // remove root
        var ret = schema;

        if (parts.some(function (key) {
                if (!ret.properties) return false;
                ret = ret.properties[key];
                return typeof(config) !== 'object';
            })) {
            return ret;
        }
        return null;
    }

    me.schema = schema;

    me.showConfigDialog = function (fieldType, configPath, callback) {
        console.log('showConfigDialog', configPath);
        console.log('config', getConfig(me.schema, configPath));
        var fieldName = configPath.split('.').pop();
        var config = getConfig(me.schema, configPath);

        if (me.modal) {
            me.modal.remove();
            me.modal = null;
            if (me.editor && me.editor.destroy) {
                me.editor.destroy();
                me.editor = null;
            }
        }

        me.modal = $(modalTemplate);
        me.modal.find('.fieldName').html(fieldName);
        me.modal.find('.saveBtn').click(function () {
            console.log('save schema', me.editor.getValue());
            var newValue = me.editor.getValue();
            newValue.type = fieldType;
            if (fieldType === 'string') {
                newValue.properties = null;
            }
            console.log('before clean up', newValue);
            newValue = cleanUpProperties(fieldType, newValue);
            mergeConfig(me.schema, configPath, newValue);

            console.log('new schema', me.schema);
            console.log('TEST validation', me.editor.validate());
            if (callback) {
                callback(me.schema);
            }
            me.modal.modal('hide');
        });

        var modalContent = me.modal.find('.content');
        var editorSchema = schemas[fieldType];

        var disableProperty = false;
        if (fieldType === 'string') disableProperty = true;

        me.editor = new JSONEditor(modalContent[0], {
            schema:                editorSchema,
            theme:                 'bootstrap3',
            iconlib:               'fontawesome4',
            startval:              '',
            disable_edit_json:     true,
            disable_properties:    disableProperty,
            disable_array_add:     true,
            disable_array_delete:  true,
            disable_array_reorder: true,
            disable_collapse:      true,
            disable_config:        true
        });

        me.modal.appendTo('body');
        me.modal.modal('show');

        var defaultValue = getDefaultValueFromSchema(editorSchema);
        // defaultValue.name = fieldName;
        // chi merge cac config key có trong defaultValue va exists config
        for (var key in config) {
            if (!config.hasOwnProperty(key)) continue;
            if (config[key] != undefined && defaultValue[key]) {
                defaultValue[key] = config[key];
            }
        }
        me.editor.setValue(defaultValue);
    };

    me.getSchema = function () {
        return me.schema;
    };

    me.destroy = function () {
        if (me.editor)
            me.editor.destroy();
    }
};

window.JsonSchemaEditor = JsonSchemaEditor;
module.exports = JsonSchemaEditor;
