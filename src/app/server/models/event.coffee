'use strict'

AuthorizationManager = require('../lib/authorization-manager').AuthorizationManager
ConfigurationManager = require('../lib/config-manager').ConfigurationManager
DataManager          = require('../lib/data-manager').DataManager
validator            = require('validator')
async                = require 'async'

exports.EventModel = class EventModel

    _checkAuthorization = (username, mthName, callback) ->
        _checkAndSanitizeUsername.call @, username, (checkError, validUsername) =>
            if checkError?
                callback checkError, null
            else
                DataManager.getDBManagerInstance(dbURL).findTechnicalUser validUsername, (findTechnicalUserError, technicalUserDoc) =>
                    if findTechnicalUserError?
                        callback findTechnicalUserError, null
                    else
                        AuthorizationManager.getAuthorizationManagerInstance().checkAuthorization technicalUserDoc.profile, mthName, (authorizationError, authorizationResult) =>
                            callback authorizationError, authorizationResult

    _checkAndSanitizeUsername = (username, callback) ->
        if validator.isNull(username) or not validator.isAlphanumeric(username)
            invalidUsernameError = new Error "Invalid Username"
            callback invalidUsernameError, null
        else
            callback null, validator.trim(username)

    _checkAndSanitizeEventID = (eventID, callback) ->
        if validator.isNull(eventID) or not validator.isAlphanumeric(eventID)
            invalidEventIDError = new Error "Invalid Event ID"
            callback invalidEventIDError, null
        else
            callback null, validator.trim(eventID)

    _checkAndSanitizeEventDescription = (eventDesc, callback) ->
        callback null, null

    _checkAndSanitizeEventStartDate = (eventStartDate, callback) ->
        callback null, null

    _checkAndSanitizeEventEndDate = (eventEndDate, callback) ->
        callback null, null

    _checkAndSanitizeLocation = (eventLocation, callback) ->
        callback null, null

    _checkAndSanitizeFacultyID = (facultyId, callback) ->
        if validator.isNull(facultyId) or not validator.isAlpha(facultyId)
            invalidFacultyIDError = new Error "Invalid Faculty Identifier"
            callback invalidFacultyIDError, null
        else
            callback null, validator.trim(facultyId)

    _checkAndSanitizeEventOrganizer = (eventOrganizer, callback) ->
        callback null, null

    _checkAndSanitizeForInsertion = (eventObj, callback) ->
        checkOptions =
            description: (descriptionPartialCallback) =>
                _checkAndSanitizeEventDescription.call @, eventObj.description, (descriptionError, validDescription) =>
                    descriptionPartialCallback descriptionError, validDescription
            start: (startDatePartialCallback) =>
                _checkAndSanitizeEventStartDate.call @, eventObj.start, (startDateError, validStartDate) =>
                    startDatePartialCallback startDateError. validStartDate
            end: (endDataPartialCallback) =>
                _checkAndSanitizeEventEndDate.call @, eventObj.end, (endDateError, validEndDate) =>
                    endDataPartialCallback endDateError, validEndDate
            location: (locationPartialCallback) =>
                _checkAndSanitizeLocation.call @, eventObj.location, (locationError, validLocation) =>
                    locationPartialCallback locationError, validLocation
            faculty: (facultyPartialCallback) =>
                _checkAndSanitizeFacultyID.call @, eventObj.faculty, (facultyError, validFacultyID) =>
                    facultyPartialCallback facultyError, validFacultyID
            organizer: (organizerPartialCallback) =>
                _checkAndSanitizeEventOrganizer.call @, eventObj.organizer, (organizerError, validOrganizer) =>
                    organizerPartialCallback organizerError, validOrganizer
        async.parallel checkOptions, (checkError, validEventObj) =>
            callback checkError, validEventObj

    _insertEvent = (eventID, eventObj, callback) ->
        _checkAndSanitizeEventID.call @, eventID, (eventIDError, validEventID) =>
            if eventIDError?
                callback eventIDError, null
            else
                _checkAndSanitizeForInsertion.call @, eventObj, (checkError, validEventObj) =>
                    if checkError?
                        callback checkError, null
                    else
                        ConfigurationManager.getConfigurationManager().getDBURL @appEnv, (urlError, dbURL) =>
                            if urlError?
                                callback urlError, null
                            else
                                DataManager.getDBManagerInstance(dbURL).insertEvent validEventID, validEventObj, (saveError, saveResult) =>
                                    callback saveError, saveResult

    constructor: (@appEnv) ->

    checkAuthorization: (username, mthName, callback) =>
        _checkAuthorization.call @, username, mthName, (authorizationError, authorizationResult) =>
            callback authorizationError, authorizationResult

    insertEvent: (eventID, eventObj, callback) =>
        _insertEvent.call @, eventID, eventObj, (insertError, insertResult) =>
            callback insertError, insertResult
