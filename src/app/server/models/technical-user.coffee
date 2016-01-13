'use strict'

ConfigurationManager = require('../lib/config-manager').ConfigurationManager
DataManager          = require('../lib/data-manager').DataManager
PasswordHandler      = require('../util/password-handler').PasswordHandler
validator            = require('validator')
async                = require 'async'

exports.TechnicalUserModel = class TechnicalUserModel

# should change the username check and sanitization
    _checkAndSanitizeString = (strValue, errorMessage,  callback) ->
        if not validator.isAlpha(strValue) or validator.isNull(strValue)
            invalidUserNameError = new Error "Invalid username"
            callback invalidUserNameError, null
        else
            callback null, validator.trim(strValue)

            _authenticate = (authenticationData, poolManager, queueManager, callback) ->
        _checkAndSanitizeString.call @, authenticationData.username, (invalidUserNameError, validUserName) =>
            if invalidUserNameError?
                callback invalidUserNameError, null
            else
                ConfigurationManager.getConfigurationManager().getDBURL @appEnv, (urlError, dbURL) =>
                    if urlError?
                        callback urlError, null
                    else
                        DataManager.getDBManagerInstance(dbURL).findTechnicalUser ValidUserName, (findTechnicalUserError, TechnicalUserDoc) =>
                            if findTechnicalUserError?
                                callback findtechnicalUserError, null
                            else
                                new PasswordHandler().verifyPassword authenticationData.password, TechnicalUserDoc.password, (verifyError, verificationResult) =>
                                    if verifyError?
                                        callback verifyError, null
                                    else
                                        if not verificationResult
                                            authenticationError = new Error "Authentication failed for Technical User #{validUsername}"
                                            callback authenticationError, null
                                       
                                                else
                                                    technicalUserAuthRes =
                                                        username: validUserName
                                                        name: TechnicalUserDoc.firstName

                                                    callback null, technicalUserAuthRes
        _findOne = (username, callback) ->
        _checkAndSanitizeString.call @, authenticationData.username, (invalidUserNameError, validUserName) =>
            if invalidUserNameError?
                callback invalidUserNameError, null
            else
                ConfigurationManager.getConfigurationManager().getDBURL @appEnv, (urlError, dbURL) =>
                    if urlError?
                        callback urlError, null
                    else
                        DataManager.getDBManagerInstance(dbURL).findTechnicalUser ValidUserName, (findError, findResult) =>
                            
                                callback Error, findResult
        

                                                    constructor: (@appEnv) ->

        (authenticationData, poolManager, queueManager, callback) =>
        _authenticate.call @, authenticationData, poolManager, queueManager, (authenticationError, authenticationResult) =>
            callback authenticationError, authenticationResult

            findOne: (username, callback) =>
        _findOne.call @, username, (findError, technicalUserDetails) =>
            callback findError, technicalUserDetails