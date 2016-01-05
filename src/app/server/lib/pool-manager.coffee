'use strict'

# This class defines a pool manager for controllers

ControllerFactory = require('../util/controller-factory').ControllerFactory

exports.PoolManager = class PoolManager

    _pmInstance = undefined

    @getPoolManagerInstance = ->
        _pmInstance ?= new _LocalPoolManager

    class _LocalPoolManager
        MAX_SIZE = 100

        _acquire = (controllerFamilyName, callback) ->
            controllerContainer = @pool[controllerFamilyName]
            if not controllerContainer?
                unknownControllerFamilyError = new Error "Unknown controller for #{controllerFamilyName}"
                callback unknownControllerFamilyError, null
            else
                availableControllers = controllerContainer.available
                if availableControllers.length > 0
                    currentController = availableControllers.splice 0, 1
                    callback null, currentController
                else if controllerContainer.count < @MAX_SIZE
                    ControllerFactory.getFactoryInstance().createControllerInstance controllerFamilyName, @appEnv, (controllerInstanceError, controllerInstance) =>
                        if controllerInstanceError?
                            callback controllerInstanceError, null
                        else
                            controllerContainer.count++
                            callback null, controllerInstance
                else
                    callback null, null

        _release = (controllerFamilyName, controllerRef, callback) ->
            controllerContainer = @pool[controllerFamilyName]
            if not controllerContainer?
                unknownControllerFamilyError = new Error "Unknown controller for #{controllerFamilyName}"
                callback unknownControllerFamilyError, null
            else
                availableControllers = controllerContainer.available
                availableControllers.push controllerRef
                callback null, null

        constructor: ->
            @loadControllerContainers()

        loadControllerContainers: =>
            @pool = {
                "students": {
                    "available": [],
                    "count": 0
                },
                "login-records": {
                    "available": [],
                    "count": 0
                }
            }

        setExecutionEnvironment: (envVal) =>
            @appEnv = envVal

        acquire: (controllerFamilyName, callback) =>
            _acquire.call @, controllerFamilyName, (controllerInstanceError, controllerInstance) =>
                callback controllerInstanceError, controllerInstance

        release: (controllerFamilyName, controllerRef, callback) =>
            _release.call @, controllerFamilyName, controllerRef, (releaseError, releaseResult) =>
                callback releaseError, releaseResult
