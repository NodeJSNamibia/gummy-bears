'use strict'

exports.TechnicalUserRequestHandler = class TechnicalUserRequestHandler
    _t-urhInstance = undefined

    @getRequestHandler: ->
        _t-urhInstance ?= new _LocalTechnicalUserRequestHandler

    class _LocalTechnicalUserRequestHandler

     _authenticate = (queueManager, poolManager, request, response) ->
            poolManager.acquire 'technical-user', (controllerInstanceError, controllerInstance) =>
                if controllerInstanceError?
                    response.json 500, {error: controllerInstanceError.message}
                else if not controllerInstance?
                    authenticationRequestObject =
                        methodName: 'authenticate'
                        arguments: [queueManager, poolManager, request, response]
                    queueManager.enqueueRequest 'tecchnical-user', authenticationRequestObject
                else
                    controllerInstance.authenticate request.body, poolManager, queueManager, (authenticationError, authenticationResult) =>
                        if authenticationError?
                            response.json 500, {error: authenticationError.message}
                        else
                            request.session.technical-user = authenticationResult
                            response.json 200, authenticationResult

     _getTechnicalUser = (queueManager, poolManager, request, response) ->
            poolManager.acquire 'tehnical-user', (controllerInstanceError, controllerInstance) =>
                if controllerInstanceError?
                    response.json 500, {error: controllerInstanceError.message}
                else if not controllerInstance?
                    getTechnicalUserRequestObject =
                        methodName: 'getTechnicalUser'
                        arguments: [queueManager, poolManager, request, response]
                    queueManager.enqueueRequest 'technical-user', getTechnicalUserRequestObject
                else
                    controllerInstance.getTechnicalUser request.params.usename, poolManager, queueManager, (getTechnicalUserRequestError, technicalUserDetails) =>
                        if getTechnicalUserRequest?
                            response.json 500, {error: getTechnicalUserRequestError.message}
                        else
                            response.json 200, technicalUserDetails

                            constructor: ->
        authenticate: (queueManager, poolManager, request, response) =>
        _authenticate.call @, queueManager, poolManager, request, response

        getTechnicalUser: (queueManager, poolManager,  request, response) =>
            _getTechnicalUser.call @, queueManager, poolManager, request, response
