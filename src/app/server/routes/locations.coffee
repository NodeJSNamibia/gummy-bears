'use strict'

LocationRequestHandler = require('../route-handlers/location').LocationRequestHandler

module.exports = (app, poolManager, queueManager) ->
    locationRequestHandler = LocationRequestHandler.getRequestHandler()

    
