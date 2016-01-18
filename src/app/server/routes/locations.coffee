'use strict'

LocationRequestHandler = require('../route-handlers/location').LocationRequestHandler

module.exports = (app, poolManager, queueManager) ->
    locationRequestHandler = LocationRequestHandler.getRequestHandler()

    app.route('/api/locations').get (request, response) ->
        locationRequestHandler.getAllLocations queueManager, poolManager, request, response

    app.route('/api/locations/:id').get (request, response) ->
        locationRequestHandler.getLocation queueManager, poolManager, request, response
