'use strict'

exports.LocationRequestHandler = class LocationRequestHandler
    _lrhInstance = undefined

    @getRequestHandler: ->
        _lrhInstance ?= new _LocalLocationRequestHandler

    class _LocalLocationRequestHandler

        _getAllLocations = (queueManager, poolManager, request, response) ->
            poolManager.acquire 'locations', (controllerInstanceError, controllerInstance) =>
                if controllerInstanceError?
                    response.json 500, {error: controllerInstanceError.message}
                else if not controllerInstance?
                    getAllLocationsRequestObject =
                        methodName: 'getAllLocations'
                        arguments: [queueManager, poolManager, request, response]
                    queueManager.enqueueRequest 'locations', getAllLocationsRequestObject
                else
                    controllerInstance.getAllLocations poolManager, queueManager, (allLocationError, allLocations) =>
                        if allLocationError?
                            response.json 500, {error: allLocationError.message}
                        else
                            response.json 200, allLocations

        _getLocation = (queueManager, poolManager, request, response) ->
            poolManager.acquire 'locations', (controllerInstanceError, controllerInstance) =>
                if controllerInstanceError?
                    response.json 500, {error: controllerInstanceError.message}
                else if not controllerInstance?
                    getLocationRequestObject =
                        methodName: 'getLocation'
                        arguments: [queueManager, poolManager, request, response]
                    queueManager.enqueueRequest 'locations', getLocationRequestObject
                else
                    controllerInstance.getLocation request.params.id, poolManager, queueManager, (getLocationError, locationDetails) =>
                        if getLocationError?
                            response.json 500, {error: getLocationError.message}
                        else
                            response.json 200, locationDetails

        constructor: ->

        getAllLocations: (queueManager, poolManager, request, response) =>
            _getAllLocations.call @, queueManager, poolManager, request, response

        getLocation: (queueManager, poolManager, request, response) =>
            _getLocation.call @, queueManager, poolManager, request, response
