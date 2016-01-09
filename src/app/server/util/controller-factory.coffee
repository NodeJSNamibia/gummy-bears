'use strict'

# This class generates new controller instances

StudentsController     = require('../controllers/students').StudentsController
LoginRecordsController = require('../controllers/login-records').LoginRecordsController

exports.ControllerFactory = class ControllerFactory
    _cfInstance = undefined

    @getFactoryInstance = ->
        _cfInstance ?= new _LocalControllerFactory

    class _LocalControllerFactory
        _createControllerInstance = (controllerFamilyName, appEnv, callback) ->
            switch controllerFamilyName
                when "students" then _createStudentsController.call @, appEnv, callback
                when "login-records" then _createLoginRecordsController.call @, appEnv, callback

        _createStudentsController = (appEnv, callback) ->
            studentsController = new StudentsController appEnv
            callback null, studentsController

        _createLoginRecordsController = (appEnv, callback) ->
            loginRecordsController = new LoginRecordsController appEnv
            callback null, loginRecordsController

        constructor: ->

        createControllerInstance: (controllerFamilyName, appEnv, callback) =>
            _createControllerInstance.call @, controllerFamilyName, appEnv, (controllerInstanceError, controllerInstance) =>
                callback controllerInstanceError, controllerInstance
