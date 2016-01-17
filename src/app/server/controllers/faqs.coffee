'use strict'

# This class represents a FAQs controller.
# It handles all requests related to FAQs

async              = require 'async'
FAQModel           = require('../models/faq').FAQModel
TechnicalUserProxy = require('../proxies/technical-user').TechnicalUserProxy
AbstractController = require('./abstract-controller').AbstractController

exports.FAQsController = class FAQsController extends AbstractController
    _insertSingleFAQIter = (singleFAQData, callback) ->
        # create the proper object representing the FAQ
        FAQInfo =
            id: singleFAQData["id"]
            Question: singleFAQData["Question"]
            Answer: singleFAQData["Answer"]

        @faq.insertFAQ FAQInfo, (saveError, saveResult) =>
            callback saveError, saveResult

    _getFAQ = (id, poolManager, queueManager, callback) ->
        @faq.findOne id, (findError, FAQDetails) =>
            @release 'faqs', poolManager, queueManager, (releaseError, releaseResult) =>
                if releaseError?
                    callback releaseError, null
                else
                    callback findError, FAQDetails

    _getAllFAQs = (poolManager, queueManager, callback) ->
        @faq.findAll (findError, allFAs) =>
            @release 'faqs', poolManager, queueManager, (releaseError, releaseResult) =>
                if releaseError?
                    callback releaseError, null
                else
                    callback findError, allFAQs

    _insertAllFAQs = (username, poolManager, queueManager, callback) ->
        @faq.checkAuthorization username, 'insertAllFAQs', @technicalUserProxy, (authorizationError, authorizationResult) =>
            if authorizationError?
                callback authorizationError, null
            else if not authorizationResult
                unauthorizedInsertionError = new Error "Authorization Error! User #{username} is not authorized to load all frequently asked questions"
                callback unauthorizedInsertionError, null
            else
                



        @event.checkAuthorization username, 'insertAllEvents', @technicalUserProxy, (authorizationError, authorizationResult) =>
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
        @faq = new FAQModel envVal
        @technicalUserProxy = new TechnicalUserProxy envVal

    insertSingleFAQIter: (poolManager, queueManager, callback) =>
        _insertSingleFAQIter.call @, poolManager, queueManager, (insertSingleError, insertSingleResult) =>
            callback insertSingleError, insertSingleResult

    getFAQ: (id, poolManager, queueManager, callback) =>
        _getFAQ.call @, id, poolManager, queueManager, (getFAQError, FAQDetails) =>
            callback getFAQError, FAQDetails

    getAllFAQs: (poolManager, queueManager, callback) =>
        _getAllFAQs.call @, poolManager, queueManager, (getAllFAQsError, allFAQs) =>
            callback getAllFAQsError, allFAQs

    insertAllFAQs: (username, poolManager, queueManager, callback) =>
        _insertAllFAQs.call @, username, poolManager, queueManager, (insertAllError, insertAllResult) =>
            callback insertAllError, insertAllResult
