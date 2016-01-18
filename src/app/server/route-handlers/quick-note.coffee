'use strict'

exports.QuickNoteRequestHandler = class QuickNoteRequestHandler
    _qnrhInstance = undefined

    @getRequestHandler: () ->
        _qnrhInstance ?= new _LocalQuickNoteRequestHandler

    class _LocalQuickNoteRequestHandler

        _notify = (queueManager, poolManager, request, response) ->
            poolManager.acquire 'quickNotes', (controllerInstanceError, controllerInstance) =>
                if controllerInstanceError?
                    response.json 500, {error: controllerInstanceError.message}
                else if not controllerInstance?
                    notifyRequestObject =
                        methodName: 'notify'
                        arguments: [queueManager, poolManager, request, response]
                    queueManager.enqueueRequest 'quickNotes', notifyRequestObject
                else
                    controllerInstance.notify request.session?.user?.username, request.body, poolManager, queueManager, (notificationError, notificationResult) =>
                        if notificationError?
                            response.json 500, {error: notificationError.message}
                        else
                            response.json 201, notificationResult

        constructor: ->

        notify: (queueManager, poolManager, request, response) =>
            _notify.call @, queueManager, poolManager, request, response
