'use strict'

# This class represents an events controller.
# It handles all requests related to events

AbstractController = require('./abstract-controller').AbstractController
EventModel         = require('../models/event').EventModel

exports.EventsController = class EventsController extends AbstractController

    _insertAllEvents = (username, poolManager, queueManager, callback) ->

    constructor: (envVal) ->
        @event = new EventModel envVal

    insertAllEvents: (username, poolManager, queueManager, callback) =>
        _insertAllEvents.call @, username, poolManager, queueManager, (insertAllError, insertAllResult) =>
            callback insertAllError, insertAllResult
