'use strict'

# this class manages a queue where requests are stored in case an
# instance of the expected controller is not available

exports.QueueManager = class QueueManager

    _qmInstance = undefined

    @getQueueManagerInstance: ->
        _qmInstance ?= new _LocalQueueManager()

    class _LocalQueueManager

        _enqueueRequest = (controllerFamilyName, requestObject) ->
            workerFamily = @workers[controllerFamilyName]
            if workerFamily?
                workerFamily.push requestObject
            else
                newWorkerFamily = [requestObject]
                @workers[controllerFamilyName] = newWorkerFamily

        _notify = (controllerFamilyName) ->
            workerFamily = @workers[controllerFamilyName]
            if workerFamily? and workerFamily.length > 0
                # execute the metod

        constructor: ->
            @workers = {}

        enqueueRequest: (controllerFamilyName, requestObject) =>
            _enqueueRequest.call @, controllerFamilyName, requestObject

        notify: (controllerFamilyName) =>
            _notify.call @, controllerFamilyName
