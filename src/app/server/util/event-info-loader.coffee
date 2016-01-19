'use strict'

xlsxj = require 'xlsx-to-json'

exports.EventInfoLoader = class EventInfoLoader

    _loaderInstance = undefined

    @getInfoLoader = ->
        _loaderInstance ?= new _LocalEventInfoLoader

    class _LocalEventInfoLoader
        constructor: ->

        loadEvents: (callback) =>
            convConfig =
                input: __dirname + '/../../../opt/events.xlsx'
                output: null
                sheet: "Sheet 1"
            xlsxj convConfig, callback
