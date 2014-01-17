_ = require "underscore"
Backbone = require "backbone"

class Events
  constructor: ->
    _.extend this, Backbone.Events

module.exports = new Events