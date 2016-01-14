'use strict'

exports.EventRequestHandler = class EventRequestHandler
    _erhInstance = undefined

    @getRequestHandler: ->
        _erhInstance ?= new _LocalEventRequestHandler

    class _LocalEventRequestHandler

        _insertAllEvents = (queueManager, poolManager, request, response) ->
            poolManager.acquire 'events', (controllerInstanceError, controllerInstance) =>
                if controllerInstanceError?
                    response.json 500, {error: controllerInstanceError.message}
                else if not controllerInstance?
                    insertAllEventsRequestObject =
                        methodName: 'insertAllEvents'
                        arguments: [queueManager, poolManager, request, response]
                    queueManager.enqueueRequest 'events', insertAllEventsRequestObject
                else
                    controllerInstance.insertAllEvents request.session?.user?.username, poolManager, queueManager, (eventCreationError, eventCreationResult) =>
                        if eventCreationError?
                            response.json 500, {error: eventCreationError.message}
                        else
                            response.json 201, eventCreationResult

        constructor: ->

        insertAllEvents: (queueManager, poolManager, request, response) =>
            _insertAllEvents.call @, queueManager, poolManager, request, response
