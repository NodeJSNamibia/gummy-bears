'use strict'

exports.LocationRequestHandler = class LocationRequestHandler
    _lrhInstance = undefined

    @getRequestHandler: ->
        _lrhInstance ?= new _LocalLocationRequestHandler

    class _LocalLocationRequestHandler

        constructor: ->
