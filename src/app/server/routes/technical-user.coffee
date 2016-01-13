'use strict'

# this file contains all routes related to technical users

TechnicalUserRequestHandler = require('../route-handlers/technical-users').TechnicalUserRequestHandler

module.exports = (app, poolManager, queueManager) ->
    TechnicalUserRequestHandler = TechnicalUserRequestHandler.getRequestHandler()

   # Technical user authentication
    app.route('/api/technical-users/authenticate').post (request, response) ->
        TechnicalUserRequestHandler.authenticate queueManager, poolManager, request, response

     # get a specific technical user with her username and name
    app.route('/api/technical-user/:username').get (request, response) ->
        TechnicalUserRequestHandler.gettehnical-user queueManager, poolManager, request, response