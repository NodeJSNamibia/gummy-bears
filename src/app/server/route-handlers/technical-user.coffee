'use strict'

exports.TechnicalUserRequestHandler = class TechnicalUserRequestHandler
    _turhInstance = undefined

    @getRequestHandler: ->
        _turhInstance ?= new _LocalTechnicalUserRequestHandler

    class _LocalTechnicalUserRequestHandler

        _authenticate = (queueManager, poolManager, request, response) ->
            poolManager.acquire 'technical-users', (controllerInstanceError, controllerInstance) =>
                if controllerInstanceError?
                    response.json 500, {error: controllerInstanceError.message}
                else if not controllerInstance?
                    authenticationRequestObject =
                        methodName: 'authenticate'
                        arguments: [queueManager, poolManager, request, response]
                    queueManager.enqueueRequest 'tecchnicalUsers', authenticationRequestObject
                else
                    controllerInstance.authenticate request.body, poolManager, queueManager, (authenticationError, authenticationResult) =>
                        if authenticationError?
                            response.json 500, {error: authenticationError.message}
                        else
                            request.session.technicalUser = authenticationResult
                            response.json 200, authenticationResult

        _getTechnicalUser = (queueManager, poolManager, request, response) ->
            poolManager.acquire 'tehnical-users', (controllerInstanceError, controllerInstance) =>
                if controllerInstanceError?
                    response.json 500, {error: controllerInstanceError.message}
                else if not controllerInstance?
                    getTechnicalUserRequestObject =
                        methodName: 'getTechnicalUser'
                        arguments: [queueManager, poolManager, request, response]
                    queueManager.enqueueRequest 'technicalUsers', getTechnicalUserRequestObject
                else
                    controllerInstance.getTechnicalUser request.params.id, poolManager, queueManager, (getTechnicalUserRequestError, technicalUserDetails) =>
                        if getTechnicalUserRequest?
                            response.json 500, {error: getTechnicalUserRequestError.message}
                        else
                            response.json 200, technicalUserDetails

        _logOut = (request, response) ->
            while request.session.hasOwnProperty 'user'
                delete request.session.user
            response.redirect '/'

        constructor: ->

        authenticate: (queueManager, poolManager, request, response) =>
            _authenticate.call @, queueManager, poolManager, request, response

        getTechnicalUser: (queueManager, poolManager,  request, response) =>
            _getTechnicalUser.call @, queueManager, poolManager, request, response

        logOut: (request, response) =>
            _logOut.call @, request, response
