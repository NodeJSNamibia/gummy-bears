'use strict'

# This class generates new controller instances

StudentsController       = require('../controllers/students').StudentsController
LoginRecordsController   = require('../controllers/login-records').LoginRecordsController
FacultiesController      = require('../controllers/faculties').FacultiesController
TechnicalUsersController = require('../controllers/technical-users').TechnicalUsersController
EventsController         = require('../controllers/events').EventsController
FAQsController           = require('../controllers/faqs').FAQsController
QuickNotesController     = require('../controllers/quick-notes').QuickNotesController
LocationsController      = require('../controllers/locations').LocationsController

exports.ControllerFactory = class ControllerFactory
    _cfInstance = undefined

    @getFactoryInstance = ->
        _cfInstance ?= new _LocalControllerFactory

    class _LocalControllerFactory
        _createControllerInstance = (controllerFamilyName, appEnv, callback) ->
            switch controllerFamilyName
                when "students" then _createStudentsController.call @, appEnv, callback
                when "loginRecords" then _createLoginRecordsController.call @, appEnv, callback
                when "technicalUsers" then _createTechnicalUsersController.call @, appEnv, callback
                when "faculties" then _createFacultiesController.call @, appEnv, callback
                when "events" then _createEventsController.call @, appEnv, callback
                when "faqs" then _createFAQsController.call @, appEnv, callback
                when "quickNotes" then _createQuickNotesController.call @, appEnv, callback
                when 'locations' then _createLocationsController.call @, appEnv, callback

        _createStudentsController = (appEnv, callback) ->
            studentsController = new StudentsController appEnv
            callback null, studentsController

        _createLoginRecordsController = (appEnv, callback) ->
            loginRecordsController = new LoginRecordsController appEnv
            callback null, loginRecordsController

        _createTechnicalUsersController = (appEnv, callback) ->
            technicalUsersController = new TechnicalUsersController appEnv
            callback null, technicalUsersController

        _createFacultiesController = (appEnv, callback) ->
            facultiesController = new FacultiesController appEnv
            callback null, facultiesController

        _createEventsController = (appEnv, callback) ->
            eventsController = new EventsController appEnv
            callback null, eventsController

        _createFAQsController = (appEnv, callback) ->
            faqsController = new FAQsController appEnv
            callback null, faqsController

        _createQuickNotesController = (appEnv, callback) ->
            quickNotesController = new QuickNotesController appEnv
            callback null, quickNotesController

        _createLocationsController = (appEnv, callback) ->
            locationsController = new LocationsController appEnv
            callback null, locationsController

        constructor: ->

        createControllerInstance: (controllerFamilyName, appEnv, callback) =>
            _createControllerInstance.call @, controllerFamilyName, appEnv, (controllerInstanceError, controllerInstance) =>
                callback controllerInstanceError, controllerInstance
