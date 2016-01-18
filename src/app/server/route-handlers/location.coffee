'use strict'

exports.LocationRequestHandler = class LocationRequestHandler
    _lrhInstance = undefined

    @getRequestHandler: ->
        _lrhInstance ?= new _LocalLocationRequestHandler

    class _LocalLocationRequestHandler

        _getAllLocations = (queueManager, poolManager, request, response) ->

        constructor: ->

        getAllLocations: (queueManager, poolManager, request, response) =>
            _getAllLocations.call @, queueManager, poolManager, request, response
