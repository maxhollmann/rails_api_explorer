$ ->
  $(".hidden").hide().removeClass("hidden")

  $(".shared-input.header").change ->
    updateShareds()

  updateShareds = ->
    $(".shared-input.header").each ->
      name = $(this).attr("data-name")
      $(".shared.header[data-name=" + name + "]").val($(this).val())

  setValuesFromRequest = (request) ->
    $("[data-source-request='" + request + "']").each (input) ->
      v = eval("responses['" + request + "']" + $(this).attr("data-source-accessor"))
      $(this).val(v)
    updateShareds()

  # Enable / disable params
  $(".param input").prop("disabled", false) # Firefox autocomplete workaround

  $(".send-toggle").click (event) ->
    event.preventDefault()

    setState = (elements, state) ->
      elements.each (i, el) ->
        $(el).attr("data-send", if state then "true" else "false")
        $(el).find("input").first().prop("disabled", !state)
        $(el).find(".send-toggle").first().text(if state then "don't send" else "send")
        $(el).find(".name").first().toggleClass("strikethrough", !state)

    param = $(this).closest(".param")
    send = (param.attr("data-send") != "true") # invert current state
    setState(param.add(param.find(".param")), send) # enable or disable children
    if send
      setState(param.parents(".param"), true) # enable parents

  $("form").submit (event) ->
    event.preventDefault()

    form = $(this)
    req = form.serializeObject().request
    form.closest(".request").find(".status").html("Requesting...")

    path = req.path
    if req.url_params
      $.each req.url_params, (p, v) ->
        path = path.replace(":" + p, v)

    $.ajax(
      url: path,
      type: req.method,
      headers: req.headers,
      data: req.params,
      dataType: 'json'
    ).always (data, status, error) ->
      if status == 'success'
        code = 200
        key = req.method.toUpperCase() + ":" + req.path.replace(api_explorer_base_url, "")
        window.responses[key] = data
        setValuesFromRequest(key)
      else
        code = data.status
        try
          data = $.parseJSON(data.responseText)
        catch SyntaxError
          # nothing

      if code == 0
        form.closest(".request").find(".status").text("Can't reach server")
        form.closest(".request").find(".response").hide()
      else
        form.closest(".request").find(".status").text(code)
        form.closest(".request").find(".response").text(JSON.stringify(data, null, 4)).show()
