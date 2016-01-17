'use strict'

AuthorizationManager       = require('../lib/authorization-manager').AuthorizationManager
CheckAndSanitizationHelper = require('../util/sanitization-helper').CheckAndSanitizationHelper
ConfigurationManager       = require('../lib/config-manager').ConfigurationManager
DataManager                = require('../lib/data-manager').DataManager
validator                  = require('validator')
async                      = require 'async'

exports.FAQModel = class FAQModel

    _checkAndSanitizeFAQID = (faqID, callback) ->
        @sanitizationHelper.checkAndSanitizeID faqID, "Error! Null FAQ ID", "Invalid FAQ ID", true, validator, (faqIDError, validFAQID) =>
            callback faqIDError, validFAQID

    _checkAndSanitizeQuestion = (questionDesc, callback) ->
        @sanitizationHelper.checkAndSanitizeWords questionDesc, "Error in FAQ question", "Empty FAQ question", validator, (questionDescriptionError, validQuestionDescription) =>
            callback questionDescriptionError, validQuestionDescription

    _checkAndSanitizeAnswer = (answerDesc, callback) ->
        @sanitizationHelper.checkAndSanitizeWords answerDesc, "Error in FAQ anser", "Empty FAQ answer", validator, (answerDescriptionError, validAnswerDescription) =>
            callback answerDescriptionError, validAnswerDescription

    _checkAndSanitizeForInsertion = (faqObj, callback) ->
        checkOptions =
            question: (questionPartialCallback) =>
                _checkAndSanitizeQuestion.call @, faqObj.question, (questionError, validQuestion) =>
                    questionPartialCallback questionError, validQuestion

            answer: (answerPartialCallback) =>
                _checkAndSanitizeAnswer.call @, faqObj.answer, (answerError, validAnswer) =>
                    answerPartialCallback answerError, validAnswer
        async.parallel checkOptions, (checkInsertError, validFAQ) =>
            callback checkInsertError, validFAQ

    _checkAuthorization = (username, mthName, technicalUserProxy, callback) ->
        technicalUserProxy.findTechnicalUserProfile username, (technicalUserProfileError, technicalUserProfile) =>
            if technicalUserProfileError?
                callback technicalUserProfileError, null
            else
                AuthorizationManager.getAuthorizationManagerInstance().checkAuthorization technicalUserProfile, mthName, (authorizationError, authorizationResult) =>
                    callback authorizationError, authorizationResult

    _insertFAQ = (faqID, faqObj, callback) ->
        _checkAndSanitizeFAQID.call @, faqID, (faqIDError, validFAQID) =>
            if faqIDError?
                callback faqIDError, null
            else
                _checkAndSanitizeForInsertion.call @, faqObj, (checkError, validFAQObject) =>
                    if checkError?
                        callback checkError, null
                    else
                        ConfigurationManager.getConfigurationManager().getDBURL @appEnv, (urlError, dbURL) =>
                            if urlError?
                                callback urlError, null
                            else
                                DataManager.getDBManagerInstance(dbURL).insertFAQ validFAQID, validFAQObject, (saveError, saveResult) =>
                                    callback saveError, saveResult

    _findOne = (faqID, callback) ->
        _checkAndSanitizeFAQID.call @, faqID, (faqIDError, validFAQID) =>
            if faqIDError?
                callback faqIDError, null
            else
                ConfigurationManager.getConfigurationManager().getDBURL @appEnv, (urlError, dbURL) =>
                    if urlError?
                        callback urlError, null
                    else
                        DataManager.getDBManagerInstance(dbURL).findFAQ validFAQID, (findError, findResult) =>
                            callback findError, findResult

    _findAll = (callback) ->
        ConfigurationManager.getConfigurationManager().getDBURL @appEnv, (urlError, dbURL) =>
            if urlError?
                callback urlError, null
            else
                DataManager.getDBManagerInstance(dbURL).findAllFAQs (findAllError, allFAQs) =>
                    callback findAllError, allFAQs

    constructor: (@appEnv) ->
        @sanitizationHelper = new CheckAndSanitizationHelper()

    checkAuthorization: (username, mthName, technicalUserProxy, callback) =>
        _checkAuthorization.call @, username, mthName, technicalUserProxy, (authorizationError, authorizationResult) =>
            callback authorizationError, authorizationResult

    insertFAQ: (faqID, faqObj, callback) =>
        _insertFAQ.call @, faqID, faqObj, (insertError, insertResult) =>
            callback insertError, insertResult

    findOne: (faqID, callback) =>
        _findOne.call @, faqID, (findOneError, faqDetail) =>
            callback findOneError, faqDetail

    findAll: (callback) =>
        _findAll.call @, (findAllError, findAllResult) =>
            callback findAllError, findAllResult
