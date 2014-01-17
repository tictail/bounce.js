Backbone = require "backbone"

class BaseView extends Backbone.View
  template: null

  initialize: ->
    @render()

  render: ->
    @$el.html(@template()) if @template

module.exports = BaseView