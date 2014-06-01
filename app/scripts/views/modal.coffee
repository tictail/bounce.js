$ = require "jquery"
_ = require "underscore"

BaseView = require "scripts/views/base"

class ModalView extends BaseView
  initialize: ->
    super

    @$el.addClass "modal"
    @$el.on "click", (e) -> e.stopPropagation()

  show: =>
    @$el.addClass "in"
    $("body").addClass "dimmed"
    _.defer => $(document).one "click.modal", @hide
    this

  hide: =>
    $(document).off ".modal"
    $("body").removeClass "dimmed"
    @$el.removeClass "in"
    this

module.exports = ModalView