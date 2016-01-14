'use strict'

# this file contains all routes related to technical users

TechnicalUserRequestHandler = require('../route-handlers/technical-user').TechnicalUserRequestHandler

module.exports = (app, poolManager, queueManager) ->
    technicalUserRequestHandler = TechnicalUserRequestHandler.getRequestHandler()

    # Technical user authentication
    app.route('/api/technical-users/authenticate').post (request, response) ->
        technicalUserRequestHandler.authenticate queueManager, poolManager, request, response

    # get a specific technical user with her username and name
    app.route('/api/technical-users/:id').get (request, response) ->
        technicalUserRequestHandler.getTehnicalUser queueManager, poolManager, request, response

    # log technical user out
    app.route('/api/technical-users/logout').get (request, response) ->
        technicalUserRequestHandler.logOut request, response
