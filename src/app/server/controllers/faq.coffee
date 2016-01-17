'use strict'

# This class represents a FAQs controller. It handles all requests related to FAQs
async              = require 'async'
FAQModel       = require('../models/faq').FAQModel
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
    constructor: (envVal) ->
        @faq = new FAQModel envVal

    insertSingleFAQIter: (poolManager, queueManager, callback) =>
        _insertSingleFAQIter.call @, poolManager, queueManager, (insertSingleError, insertSingleResult) =>
            callback insertSingleError, insertSingleResult 

    getFAQ: (id, poolManager, queueManager, callback) =>
        _getFAQ.call @, id, poolManager, queueManager, (getFAQError, FAQDetails) =>
            callback getFAQError, FAQDetails

    getAllFAQs: (poolManager, queueManager, callback) =>
        _getAllFAQs.call @, poolManager, queueManager, (getAllFAQsError, allFAQs) =>
            callback getAllFAQsError, allFAQs
        