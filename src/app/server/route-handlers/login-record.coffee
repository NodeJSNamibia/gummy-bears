'use strict'

exports.LoginRecordRequestHandler = class LoginRecordRequestHandler
    _lrrhInstance = undefined

    @getRequestHandler: ->
        _lrrhInstance ?= new _LocalLoginRecordRequestHandler

    class _LocalLoginRecordRequestHandler

        _save = (queueManager, poolManager, request, response) ->
            poolManager.acquire 'login-records', (controllerInstanceError, controllerInstance) =>
                if controllerInstanceError?
                    callback controllerInstanceError, null
                else if not controllerInstance?
                    saveLRRequestObject =
                        methodName: 'save'
                        arguments: [queueManager, poolManager, request, response]
                    queueManager.enqueueRequest 'students', updateCoursesRequestObject
                else
                    controllerInstance.save request.params.id, poolManager, (saveLoginRecordError, saveLoginRecordResult) =>
                        callback saveLoginRecordError, saveLoginRecordResult

        constructor: ->

        save: (queueManager, poolManager, request, response) =>
            _save.call @, queueManager, poolManager, request, response
