'use strict'

# This file contains all routes related to the event resource

EventRequestHandler = require('../route-handlers/event').EventRequestHandler

module.exports = (app, poolManager, queueManager) ->
    eventRequestHandler = EventRequestHandler.getRequestHandler()

    # load all events
    app.route('/api/events').post (request, response) ->
        eventRequestHandler.insertAllEvents queueManager, poolManager, request, response
