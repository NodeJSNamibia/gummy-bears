'use strict'

# this class manages a queue where requests are stored in case an
# instance of the expected controller is not available

StudentRequestHandler     = require('../route-handlers/student').StudentRequestHandler
LoginRecordRequestHandler = require('../route-handlers/login-record').LoginRecordRequestHandler

exports.QueueManager = class QueueManager

    _qmInstance = undefined

    @getInstance: (evtEmitter) ->
        _qmInstance ?= new _LocalQueueManager evtEmitter

    class _LocalQueueManager

        _enqueueRequest = (controllerFamilyName, requestObject) ->
            workerFamily = @workers[controllerFamilyName]
            if workerFamily?
                workerFamily.push requestObject
            else
                newWorkerFamily = [requestObject]
                @workers[controllerFamilyName] = newWorkerFamily

        _executeStudentRequest = (currentStudentRequestObject) ->
            studentRequestHandler = StudentRequestHandler.getRequestHandler()
            studentRequestHandler[currentStudentRequestObject.methodName].apply studentRequestHandler, currentStudentRequestObject.arguments

        _executeLoginRecordRequest = (currentLRRequestObject) ->
            loginRecordRequestHandler  = LoginRecordRequestHandler.getRequestHandler()
            loginRecordRequestHandler[currentLRRequestObject.methodName].apply loginRecordRequestHandler, currentLRRequestObject.arguments

        _handleNotification = (controllerFamilyName) ->
            workerFamily = @workers[controllerFamilyName]
            if workerFamily? and workerFamily.length > 0
                currentRequestObject = workerFamily.splice 0, 1
                switch controllerFamilyName
                  when "students" then _executeStudentRequest.call @, currentRequestObject
                  when "login-records" then _executeLoginRecordRequest.call @, currentRequestObject

        constructor: (@evtEmitter) ->
            @workers = {}
            @evtEmitter.on 'notify_available', @handleNotification

        enqueueRequest: (controllerFamilyName, requestObject) =>
            _enqueueRequest.call @, controllerFamilyName, requestObject

        handleNotification: (controllerFamilyName) =>
            _handleNotification.call @, controllerFamilyName
