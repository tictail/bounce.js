$ = require "jquery"

ModalView = require "scripts/views/modal"
URLHandler = require "scripts/urlhandler"

template = require "templates/export"

class ExportView extends ModalView
  el: ".export"
  template: template
  bounceObject: null
  url: null

  events:
    "ifChanged .prefix-input": "updateCode"

  initialize: ->
    super

    @$prefix = @$(".prefix-input").iCheck
      insert: "<i class=\"fa fa-check\"></i>"

    @$code = @$ ".code"
    @$code.on "click", -> @select()

  setBounceObject: (bounce) ->
    @bounceObject = bounce
    @url = null
    @updateCode()

  getURL: ->
    deferred = $.Deferred()

    if @url
      deferred.resolve(url)
    else
      encoded = URLHandler.encodeURL @bounceObject.serialize(),
        loop: $(".loop-input").toggleButton "isOn"

      URLHandler.shorten encoded, timeout: 5000
        .done (response) -> @url = response.id
        .fail -> @url = "#{window.location.origin}##{encodeURIComponent(encoded)}"
        .always -> deferred.resolve @url

    deferred

  updateCode: ->
    @$el.removeClass "done"
    @getURL().done @_updateCode

  _updateCode: (url) =>
    @$el.addClass "done"

    prefix = @$prefix.prop "checked"
    infinite = $(".loop-input").toggleButton "isOn"

    options = name: "animation", optimized: true
    options.forcePrefix = true if prefix
    keyframes = @bounceObject.getKeyframeCSS options

    prefixes = [""]
    prefixes.unshift "-webkit-" if prefix

    animations = []
    for prefix in prefixes
      animations.push \
        "#{prefix}animation: animation #{@bounceObject.duration}ms
        linear#{if infinite then " infinite" else ""} both;"

    code = """


.animation-target {
  #{animations.join "\n  "}
}

/* Generated with Bounce.js. Edit at #{url} */

#{keyframes}


"""

    @$code.text code


module.exports = ExportView
