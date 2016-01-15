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
        descriptionComponentError = undefined
        descriptionComponents = eventDesc.split " "
        validDescriptionComponents = []
        for descriptionComponentItem in descriptionComponents
            do (descriptionComponentItem) =>
                if validator.isNull(descriptionComponentItem) or not validator.isAlpha(descriptionComponentItem)
                    if not descriptionComponentError?
                        descriptionComponentError = new Error "Error in Event Description"
                else
                    validDescriptionComponents.push validator.trim(descriptionComponentItem)
        if descriptionComponentError?
            callback descriptionComponentError, null
        else if validDescriptionComponents.length > 0
            callback null, validDescriptionComponents.join(' ')
        else
            emptyDescriptionError = new Error "Empty Event Description"
            callback emptyDescriptionError, null

    _checkAndSanitizeEventStartDate = (eventStartDate, callback) ->
        if validator.isNull(eventStartDate) or not validator.isDate(eventStartDate)
            invalidEventStartDateError = new Error "Invalid event start date"
            callback invalidEventStartDateError, null
        else
            callback null, validator.trim(eventStartDate)

    _checkAndSanitizeEventEndDate = (eventEndDate, callback) ->
        if validator.isNull(eventEndDate) or not validator.isDate(eventEndDate)
            invalidEventEndDateError = new Error "Invalid event end date"
            callback invalidEventEndDateError, null
        else
            callback null, validator.trim(eventEndDate)

    _checkAndSanitizeLocation = (eventLocation, callback) ->
        if validator.isNull(eventLocation) or not validator.isAlphanumeric(eventLocation)
            invalidLocationCodeError = new Error "Invalid Event Location"
            callbac invalidLocationCodeError, null
        else
            callbac null, validator.trim(eventLocation)

    _checkAndSanitizeFacultyID = (facultyId, callback) ->
        if validator.isNull(facultyId) or not validator.isAlpha(facultyId)
            invalidFacultyIDError = new Error "Invalid Faculty Identifier"
            callback invalidFacultyIDError, null
        else
            callback null, validator.trim(facultyId)

    _checkAndSanitizeEventOrganizer = (eventOrganizer, callback) ->
        organizerOptions =
            firstName: (firstNamePartialCallback) =>
                _checkAndSanitizeFirstName.call @, eventOrganizer.firstName, (firstNameError, validFirstName) =>
                    firstNamePartialCallback firstNameError, validFirstName
            lastName: (lastNamePartialCallback) =>
                _checkAndSanitizeLastName.call @, eventOrganizer.lastName, (lastNameError, validLastName) =>
                    lastNamePartialCallback lastNameError, validLastName
            title: (titlePartialCallback) =>
                _checkAndSanitizeTitle.call @, eventOrganizer.title, (titleError, validTitle) =>
                    titlePartialCallback titleError, validTitle
            emailAddress: (emailAddressPartialCallback) =>
                _checkAndSanitizeEmailAddress.call @, eventOrganizer.emailAddress, (emailAddressError, validEmailAddress) =>
                    emailAddressPartialCallback emailAddressError, validEmailAddress
        async.parallel organizerOptions, (organizerError, validOrganizer) =>
            callback organizerError, validOrganizer

    _checkAndSanitizeFirstOrLastName = (name, nameErrorStr, callback) ->
        if validator.isNull(name) or not validator.isAlpha(name)
            invalidNameError = new Error nameErrorStr
            callback invalidNameError, null
        else
            validName = validator.trim(name)
            capitalizedValidName = validName[0].toUpperCase() + validName[1..-1].toLowerCase()
            callback null, capitalizedValidName

    _checkAndSanitizeFirstName = (firstName, callback) ->
        _checkAndSanitizeFirstOrLastName.call @, firstName, "Invalid First Name", (firstNameError, validFirstName) =>
            callback firstNameError, validFirstName

    _checkAndSanitizeLastName = (lastName, callback) ->
        _checkAndSanitizeFirstOrLastName.call @, lastName, "Invalid Last Name", (lastNameError, validLastName) =>
            callback lastNameError, validLastName

    _checkAndSanitizeTitle = (titleValue, callback) ->
        if validator.isNull(titleValue) or not (validator.isAlpha(titleValue)  and validator.isIn(titleValue, ["Mr", "Mrs", "Ms", "Dr", "Prof"]))
            invalidTitleError = new Error "Invalid Organizer Title"
            callback invalidTitleError, null
        else
            callback null, validator.trim(titleValue)

    _checkAndSanitizeEmailAddress = (emailAddress, callback) ->
        if validator.isNull(emailAddress) or not validator.isEmail(emailAddress)
            invalidEmailAddressError = new Error "Invalid Organizer Email Address"
            callback invalidEmailAddressError, null
        else
            callback null, validator.trim(emailAddress)

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
