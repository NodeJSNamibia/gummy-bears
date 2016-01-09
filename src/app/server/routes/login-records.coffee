'use strict'

# this file contains all routes related to login records

LoginRecordRequestHandler = require('../route-handlers/login-record').LoginRecordRequestHandler

module.exports = (app, poolManager, queueManager) ->
    loginRecordRequestHandler = LoginRecordRequestHandler.getRequestHandler()

    # save a successful student authentication
    app.route('/api/login-records/:id').post (request, response) ->
        loginRecordRequestHandler.save queueManager, poolManager, request, response
