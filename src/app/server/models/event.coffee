'use strict'

AuthorizationManager       = require('../lib/authorization-manager').AuthorizationManager
DataManager                = require('../lib/data-manager').DataManager
CheckAndSanitizationHelper = require('../util/sanitization-helper').CheckAndSanitizationHelper
validator                  = require('validator')
async                      = require 'async'
moment                     = require 'moment'

exports.EventModel = class EventModel

    _checkAuthorization = (username, mthName, technicalUserProxy, callback) ->
        technicalUserProxy.findTechnicalUserProfile username, (technicalUserProfileError, technicalUserProfile) =>
            if technicalUserProfileError?
                callback technicalUserProfileError, null
            else
                AuthorizationManager.getAuthorizationManagerInstance().checkAuthorization technicalUserProfile, mthName, (authorizationError, authorizationResult) =>
                    callback authorizationError, authorizationResult

    _checkAndSanitizeEventID = (eventID, callback) ->
        @sanitizationHelper.checkAndSanitizeID eventID, "Error! Null Event ID", "Invalid Event ID", true, validator, (eventIDError, validEventID) =>
            callback eventIDError, validEventID

    _checkAndSanitizeEventDescription = (eventDesc, callback) ->
        @sanitizationHelper.checkAndSanitizeWords eventDesc, "Error in Event Description", "Empty Event Description", validator, (eventDescriptionError, validEventDescription) =>
            callback eventDescriptionError, validEventDescription

    _checkAndSanitizeEventStartDate = (eventStartDate, callback) ->
        @sanitizationHelper.checkAndSanitizeDate eventStartDate, "Invalid event start date", validator, (eventStartDateError, validEventStartDate) =>
            callback eventStartDateError, validEventStartDate

    _checkAndSanitizeEventEndDate = (eventEndDate, callback) ->
        @sanitizationHelper.checkAndSanitizeDate eventEndDate, "Invalid event end date", validator, (eventEndDateError, validEventEndDate) =>
            callback eventEndDateError, validEventEndDate

    _checkAndSanitizeLocation = (eventLocation, callback) ->
        @sanitizationHelper.checkAndSanitizeCode eventLocation, "Invalid Event Location", validator, (locationError, validLocation) =>
            callback locationError, validLocation

    _checkAndSanitizeFacultyID = (facultyID, callback) ->
        @sanitizationHelper.checkAndSanitizeID facultyID, "Error! Null faculty ID", "Invalid Faculty ID", false, validator, (facultyIDError, validFacultyID) =>
            callback facultyIDError, validFacultyID

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

    _checkAndSanitizeFirstName = (firstName, callback) ->
        @sanitizationHelper.checkAndSanitizePersonName firstName, "Invalid First Name", validator, (firstNameError, validFirstName) =>
            callback firstNameError, validFirstName

    _checkAndSanitizeLastName = (lastName, callback) ->
        @sanitizationHelper.checkAndSanitizePersonName firstName, "Invalid Last Name", validator, (lastNameError, validLastName) =>
            callback lastNameError, validLastName

    _checkAndSanitizeTitle = (titleValue, callback) ->
        @sanitizationHelper.checkAndSanitizeTitle titleValue, "Invalid Event Organizer Title", ["Mr", "Mrs", "Ms", "Dr", "Prof"], validator, (titleValueError, validTitleValue) =>
            callback titleValueError, validTitleValue

    _checkAndSanitizeEmailAddress = (emailAddress, callback) ->
        @sanitizationHelper.checkAndSanitizeEmailAddress emailAddress, "Invalid Organizer Email Address", validator, (emailAddressError, validEmailAddress) =>
            callback emailAddressError, validEmailAddress

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
                        DataManager.getInstance @appEnv, (dbInstanceError, dbInstance) =>
                            if dbInstanceError?
                                callback dbInstanceError, null
                            else
                                dbInstance.insertEvent validEventID, validEventObj, (saveError, saveResult) =>
                                    callback saveError, saveResult


    _findAllTimeFiltered = (studentNumber, studentProxy, facultyProxy, callback) =>
        if not studentNumber?
            _findAllTimeFilteredForAllFaculties.call @, (findAllError, eventsForAllFaculties) =>
                callback findAllError, eventsForAllFaculties
        else
            studentProxy.findProgramme studentNumber, (programmeError, enrolledInProgramme) =>
                if programmeError?
                    callback programmeError, null
                else
                    facultyProxy.getID enrolledInProgramme, (facultyIDError, facultyID) =>
                        if facultyIDError?
                            callback facultyIDError, null
                        else
                            _findAllTimeFilteredForSingleFaculty.call @, facultyID, (eventsError, facultyTimeFilteredEvents) =>
                                callback eventsError, facultyTimeFilteredEvents

    _findAllTimeFilteredForAllFaculties = (callback) ->
        DataManager.getInstance @appEnv, (dbInstanceError, dbInstance) =>
            if dbInstanceError?
                callback dbInstanceError, null
            else
                dbInstance.findAllEvents (allEventsError, allEvents) =>
                    if allEventsError?
                        callback allEventsError, null
                    else
                        _filterByTime.call @, allEvents, (filterError, timeFilteredEvents) =>
                            callback filterError, timeFilteredEvents

    _findAllTimeFilteredForSingleFaculty = (facultyID, callback) ->
        DataManager.getInstance @appEnv, (dbInstanceError, dbInstance) =>
            if dbInstanceError?
                callback dbInstanceError, null
            else
                dbInstance.findAllEvents (allEventsError, allEvents) =>
                    if allEventsError?
                        callback allEventsError, null
                    else
                        facultyEvents = (singleFacEvent for singleFacEvent in allEvents when singleFacEvent.faculty is facultyID)
                        _filterByTime.call @, facultyEvents, (filterError, timeFilteredEvents) =>
                            callback filterError, timeFilteredEvents

    _filterByTime = (eventCol, callback) ->
        eventsToCome = []
        now = moment()
        for curEVent in eventCol
            do (curEVent) =>
                curStartTime = moment(curEVent.start)
                if not curStartTime.isBefore now
                    eventsToCome.push curEVent
        callback null, eventsToCome

    _findAll = (callback) ->
        DataManager.getInstance @appEnv, (dbInstanceError, dbInstance) =>
            if dbInstanceError?
                callback dbInstanceError, null
            else
                dbInstance.findAllEvents (allEventsError, allEvents) =>
                    callback allEventsError, allEvents

    constructor: (@appEnv) ->
        @sanitizationHelper = new CheckAndSanitizationHelper()

    checkAuthorization: (username, mthName, technicalUserProxy, callback) =>
        _checkAuthorization.call @, username, mthName, technicalUserProxy, (authorizationError, authorizationResult) =>
            callback authorizationError, authorizationResult

    insertEvent: (eventID, eventObj, callback) =>
        _insertEvent.call @, eventID, eventObj, (insertError, insertResult) =>
            callback insertError, insertResult

    findAll: (callback) =>
        _findAll.call @, (findError, allEvents) =>
            callback findError, allEvents

    findAllTimeFiltered: (studentNumber, studentProxy, facultyProxy, callback) =>
        _findAllTimeFiltered.call @, studentNumber, studentProxy, facultyProxy, (findAllError, timeFilteredEvents) =>
            callback findAllError, timeFilteredEvents
