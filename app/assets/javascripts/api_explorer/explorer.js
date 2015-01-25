$(function() {
    $(".hidden").hide().removeClass("hidden");

    window.responses = {};

    $(".shared-input.header").change(function() {
        updateShareds();
    });
    $(".shared-link").click(function() {
        $($(this).attr("href")).find("input").focus();
    });

    function updateShareds() {
        $(".shared-input.header").each(function() {
            name = $(this).attr("data-name");
            $(".shared.header[data-name=" + name + "]").val($(this).val());
        });
    }

    function setValuesFromRequest(request) {
        $("[data-source-request='" + request + "']").each(function(input) {
            v = eval("responses['" + request + "']" + $(this).attr("data-source-accessor"));
            $(this).val(v);
        });
        updateShareds();
    }

    // Enable / disable params
    $(".param input").prop("disabled", false); // Firefox autocomplete workaround
    $(".send-toggle").click(function(event) {
        event.preventDefault();

        var setState = function(elements, state) {
            elements.each(function(i, el) {
                $(el).attr("data-send", state ? "true" : "false");
                $(el).find("input").first().prop("disabled", !state);
                $(el).find(".send-toggle").first().text(state ? "don't send" : "send");
                $(el).find(".name").first().toggleClass("strikethrough", !state);
            });
        }

        var param = $(this).closest(".param");
        var send = param.attr("data-send") == "true" ? false : true;
        setState(param.add(param.find(".param")), send); // enable or disable children
        if (send)
            setState(param.parents(".param"), true); // enable parents
    });

    $("form").submit(function(event) {
        event.preventDefault();

        var form = $(this);
        var req = form.serializeObject().request;
        form.closest(".request").find(".status").html("Requesting...");

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
                var key = req.method.toUpperCase() + ":" + req.path.replace(api_explorer_base_url, "");
                window.responses[key] = data;
                setValuesFromRequest(key);
            } else {
                code = data.status;
                try {
                    data = $.parseJSON(data.responseText);
                } catch(SyntaxError) {}
            }
            if (code == 0) {
                form.closest(".request").find(".status").text("Can't reach server");
                form.closest(".request").find(".response").hide();
            } else {
                form.closest(".request").find(".status").text(code);
                form.closest(".request").find(".response").text(JSON.stringify(data, null, 4)).show();
            }
        });
    });


    $.fn.serializeObject = function() {
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
            if(!patterns.validate.test(this.name)) {
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
});
