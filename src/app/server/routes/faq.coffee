'use strict'

# this file contains all the routes related to frequently asked questions(FAQ)

FAQRequestHandler = require('../route-handlers/faq').FAQRequestHandler

module.exports = (app, poolManager, queueManager) ->
    FAQRequestHandler = FAQRequestHandler.getRequestHandler()

    # load all FAQ
    app.route('/api/faq').post (request, response) ->
        FAQRequestHandler.insertAllFAQ queueManager, poolManager, request, response
    # load a specific FAQ
    app.route('/api/faq').post (request, response) ->
        FAQRequestHandler.insertAFAQ queueManager, poolManager, request, response
    # get the list of FAQ
    app.route('/api/faq').get (request, response) ->
        FAQRequestHandler.getAllFAQ queueManager, poolManager, request, response

    # get a specific FAQ with its id
    app.route('/api/faq/:id').get (request, response) ->
        FAQRequestHandler.getFAQ queueManager, poolManager, request, response
  
