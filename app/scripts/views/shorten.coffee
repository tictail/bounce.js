ModalView = require "scripts/views/modal"

template = require "templates/shorten"

class ShortenView extends ModalView
  el: ".shorten"
  template: template

  initialize: ->
    super

    @$url = @$ ".url"
    @$url.on "click", -> @select()

  setShortenRequest: (req) ->
    @shortenRequest = req
    @$el.removeClass "done"
    @shortenRequest.done @onDone

  onDone: (response) =>
    @$el.addClass "done"
    @$url.val response.id

module.exports = ShortenView