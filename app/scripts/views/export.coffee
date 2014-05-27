$ = require "jquery"
_ = require "underscore"

BaseView = require "scripts/views/base"

template = require "templates/export"

class ExportView extends BaseView
  el: ".export"
  template: template
  bounceObject: null

  events:
    "ifChanged .prefix-input": "updateCode"

  initialize: ->
    super

    @$prefix = @$(".prefix-input").iCheck
      insert: "<i class=\"fa fa-check\"></i>"

    @$code = $ ".code"
    @$code.on "click", -> @select()

    @$el.on "click", (e) -> e.stopPropagation()

  show: ->
    @$el.addClass "in"
    $("body").addClass "dimmed"
    _.defer => $(document).one "click.export", @hide

  hide: =>
    $(document).off ".export"
    $("body").removeClass "dimmed"
    @$el.removeClass "in"

  setBounceObject: (bounce) ->
    @bounceObject = bounce
    @updateCode()

  updateCode: ->
    prefix = @$prefix.prop "checked"

    options = name: "animation"
    options.forcePrefix = true if prefix
    keyframes = @bounceObject.getKeyframeCSS options

    prefixes = [""]
    prefixes.unshift "-webkit-" if prefix

    infinite = $(".loop-input").prop "checked"

    animations = []
    for prefix in prefixes
      animations.push \
        "#{prefix}animation: animation #{@bounceObject.duration}ms
        linear#{if infinite then " infinite" else ""} both;"

    code = """
.animation-target {
  #{animations.join "\n  "}
}

/* Generated with Bounce.js. Edit at #{window.location} */

#{keyframes}
"""

    @$code.text code


module.exports = ExportView
