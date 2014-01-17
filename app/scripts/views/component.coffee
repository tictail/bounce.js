BaseView = require "scripts/views/base"
template = require "templates/component"

class Component extends BaseView
  template: template
  initialize: ->
    super

    @$type = @$ "#type"
    @$bounces = @$ "#bounces"
    @$shake = @$ "#shake"
    @$inputs = @$ "#inputs"

    @renderInputs()
    @$type.on "change", @renderInputs

  getEasingValues: ({keyframes, bounces, shake}) ->
    a = 0.05
    limit = Math.floor(Math.log(0.0005) / -a)
    w = bounces * Math.PI / limit

    circFunc = if shake then "sin" else "cos"

    values = []
    for i in [0...keyframes]
      t = i * limit / keyframes
      values.push 1 - Math.pow(Math.E, -a*t) * Math[circFunc](w*t)

    values


  renderInputs: =>
    selected = @$type.val()

    inputViewClass = require "scripts/views/inputs/#{selected}"
    @inputView = new inputViewClass

    @$inputs.html @inputView.$el

  calculateValues: (keyframes) ->
    bounces =
    easingValues = @getEasingValues
      keyframes: keyframes
      bounces: parseInt @$bounces.val(), 10
      shake: @$shake.prop("checked")

    values = @inputView.calculateValues easingValues

module.exports = Component