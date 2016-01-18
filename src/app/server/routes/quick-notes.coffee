'use strict'

QuickNoteRequestHandler = require('../route-handlers/quick-note').QuickNoteRequestHandler

module.exports = (app, poolManager, queueManager) ->
    quickNoteRequestHandler = QuickNoteRequestHandler.getRequestHandler()

    app.route('/api/quick-notes').post (request, response) ->
        quickNoteRequestHandler.notify queueManager, poolManager, request, response
