$(function() {
    $(".response").hide();

    window.responses = {};

    $(".global-input.header").change(function() {
        name = $(this).attr("data-name");
        $(".global.header[data-name=" + name + "]").val($(this).val());
    });

    $("form").submit(function(event) {
        event.preventDefault();

        var form = $(this);
        var req = form.serializeObject().request;
        form.parent(".request").children(".status").html("Requesting...");

        console.log(req);
        path = req.path;
        if (req.url_params) {
            $.each(req.url_params, function(p, v) {
                path = path.replace(":" + p, v);
            });
        }

        $.ajax({
            url: path,
            type: req.method,
            headers: req.headers,
            data: req.params,
            dataType: 'json'
        }).always(function(data, status, error) {
            if(status == 'success') {
                code = 200;
                window.responses[req.method + ":" + req.path] = data;
            } else {
                code = data.status;
                data = $.parseJSON(data.responseText);
            }
            form.parent(".request").children(".status").text(code);
            form.parent(".request").children(".response").text(JSON.stringify(data, null, 4)).show();
        });
    });
});


$.fn.serializeObject = function(){

    var self = this,
    json = {},
    push_counters = {},
    patterns = {
        "validate": /^[a-zA-Z][a-zA-Z0-9_\-]*(?:\[(?:\d*|[a-zA-Z0-9_\-]+)\])*$/,
        "key":      /[a-zA-Z0-9_\-]+|(?=\[\])/g,
        "push":     /^$/,
        "fixed":    /^\d+$/,
        "named":    /^[a-zA-Z0-9_\-]+$/
    };


    this.build = function(base, key, value){
        base[key] = value;
        return base;
    };

    this.push_counter = function(key){
        if(push_counters[key] === undefined){
            push_counters[key] = 0;
        }
        return push_counters[key]++;
    };

    $.each($(this).serializeArray(), function(){

        // skip invalid keys
        if(!patterns.validate.test(this.name)){
            return;
        }

        var k,
        keys = this.name.match(patterns.key),
        merge = this.value,
        reverse_key = this.name;

        while((k = keys.pop()) !== undefined){

            // adjust reverse_key
            reverse_key = reverse_key.replace(new RegExp("\\[" + k + "\\]$"), '');

            // push
            if(k.match(patterns.push)){
                merge = self.build([], self.push_counter(reverse_key), merge);
            }

            // fixed
            else if(k.match(patterns.fixed)){
                merge = self.build([], k, merge);
            }

            // named
            else if(k.match(patterns.named)){
                merge = self.build({}, k, merge);
            }
        }

        json = $.extend(true, json, merge);
    });

    return json;
};
