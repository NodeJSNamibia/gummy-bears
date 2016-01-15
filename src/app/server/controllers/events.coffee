'use strict'

# This class represents an events controller.
# It handles all requests related to events

async              = require 'async'
EventInfoLoader    = require('../util/event-info-loader').EventInfoLoader
AbstractController = require('./abstract-controller').AbstractController
EventModel         = require('../models/event').EventModel
uuid               = require 'uuid4'

exports.EventsController = class EventsController extends AbstractController

    _getAllEvents = (poolManager, queueManager, callback) ->
        @event.findAll (findError, allEvents) =>
            @release 'events', poolManager, queueManager, (releaseError, releaseResult) =>
                if releaseError?
                    callback releaseError, null
                else
                    callback findError, allEvents

    _getTimeFilteredEvents = (studentNumber, poolManager, queueManager, callback) ->
        @event.findAllTimeFiltered studentNumber, (findError, timeFilteredEvents) =>
            @release 'events', poolManager, queueManager, (releaseError, releaseResult) =>
                if releaseError?
                    callback releaseError, null
                else
                    callback findError, timeFilteredEvents

    _insertSingleEvent = (eventID, eventObj, callback) ->
        eventInfo =
            description: eventObj["Event Description"]
            start: eventObj["Start Time"]
            end: eventObj["End Time"]
            location: eventObj["Event Location"]
            faculty: eventObj["Event Faculty"]
            organizer:
                firstName: eventObj["Organizer First Name"]
                lastName: eventObj["Organizer Last Name"]
                title: eventObj["Organizer Title"]
                emailAddress: eventObj["Organizer Email Address"]
        @event.insertEvent eventID, eventInfo, (saveError, saveResult) =>
            callback saveError, saveResult

    _insertAllEvents = (username, poolManager, queueManager, callback) ->
        @event.checkAuthorization username, 'insertAllEvents', (authorizationError, authorizationResult) =>
            if authorizationError?
                callback authorizationError, null
            else if not authorizationResult
                unauthorizedInsertionError = new Error "Authorization Error! User #{username} is not authorized to load all events"
                callback unauthorizedInsertionError, null
            else
                EventInfoLoader.getInfoLoader().loadEvents (loadError, rawEvents) =>
                    if loadError?
                        @release 'events', poolManager, queueManager, (releaseError, releaseResult) =>
                            if releaseError?
                                callback releaseError, null
                            else
                                callback loadError, null
                    else
                        eventOptions = {}
                        for curEvent in rawEvents
                            do (curEvent) =>
                                curEventID = uuid()
                                eventOptions[curEventID] = (partialCallback) =>
                                    _insertSingleEvent.call @, curEventID, curEvent, (insertError, singleEvent) =>
                                        partialCallback insertError, singleEvent
                        async.series eventOptions, (insertAllError, insertAllResult) =>
                            if insertAllError?
                                @release 'events', poolManager, queueManager, (releaseError, releaseResult) =>
                                    if releaseError?
                                        callback releaseError, null
                                    else
                                        callback insertAllError, null
                            else
                                @release 'events', poolManager, queueManager, (releaseError, releaseResult) =>
                                    if releaseError?
                                        callback releaseError, null
                                    else
                                        callback null, insertAllResult

    constructor: (envVal) ->
        @event = new EventModel envVal

    insertAllEvents: (username, poolManager, queueManager, callback) =>
        _insertAllEvents.call @, username, poolManager, queueManager, (insertAllError, insertAllResult) =>
            callback insertAllError, insertAllResult

    getAllEvents: (poolManager, queueManager, callback) =>
        _getAllEvents.call @, poolManager, queueManager, (allEventError, allEvents) =>
            callback allEventError, allEvents

    getTimeFilteredEvents: (studentNumber, poolManager, queueManager, callback) =>
        _getTimeFilteredEvents.call @, studentNumber, poolManager, queueManager, (timeFilteredEventsError, timeFilteredEvents) =>
            callback timeFilteredEventsError, timeFilteredEvents
