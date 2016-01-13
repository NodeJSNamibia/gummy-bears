'use strict'

ConfigurationManager = require('../lib/config-manager').ConfigurationManager
DataManager          = require('../lib/data-manager').DataManager
PasswordHandler      = require('../util/password-handler').PasswordHandler
validator            = require('validator')
async                = require 'async'

exports.TechnicalUserModel = class TechnicalUserModel

    _authenticate = (authenticationData, callback) ->
        _checkAndSanitizeUsername.call @, authenticationData.username, (usernameError, validUsername) =>
            if usernameError?
                callback usernameError, null
            else
                ConfigurationManager.getConfigurationManager().getDBURL @appEnv, (urlError, dbURL) =>
                    if urlError?
                        callback urlError, null
                    else
                        DataManager.getDBManagerInstance(dbURL).findTechnicalUser validUsername, (findTechnicalUserError, technicalUserDoc) =>
                            if findTechnicalUserError?
                                callback findTechnicalUserError, null
                            else
                                new PasswordHandler().verifyPassword authenticationData.password, technicalUserDoc.password, (verifyError, verificationResult) =>
                                    if verifyError?
                                        callback verifyError, null
                                    else if not verificationResult
                                        authenticationError = new Error "Authentication Failed for Technical User #{validUsername}"
                                        callback authenticationError, null
                                    else
                                        technicalUserAuthRes =
                                            username: validUsername
                                            firstName: technicalUserDoc.firstName
                                            lastName: technicalUserDoc.lastName
                                        callback null, technicalUserAuthRes

    _checkAndSanitizeUsername = (username, callback) ->
        if validator.isNull(username) or not validator.isAlphanumeric(username)
            invalidUsernameError = new Error "Invalid Username"
            callback invalidUsernameError, null
        else
            callback null, validator.trim(username)

    _findOne = (username, callback) ->
        _checkAndSanitizeUsername.call @, authenticationData.username, (usernameError, validUsername) =>
            if usernameError?
                callback usernameError, null
            else
                ConfigurationManager.getConfigurationManager().getDBURL @appEnv, (urlError, dbURL) =>
                    if urlError?
                        callback urlError, null
                    else
                        DataManager.getDBManagerInstance(dbURL).findTechnicalUser validUsername, (findTechnicalUserError, technicalUserDoc) =>
                            if findTechnicalUserError?
                                callback findTechnicalUserError, null
                            else
                                technicalUserResult = {}
                                technicalUserResult[entryKey] = entryValue for entryKey, entryValue of technicalUserDoc when entryKey isnt 'password'
                                callback null, technicalUserResult

    constructor: (@appEnv) ->

    authenticate: (authenticationData, callback) =>
        _authenticate.call @, authenticationData, (authenticationError, authenticationResult) =>
            callback authenticationError, authenticationResult

    findOne: (username, callback) =>
        _findOne.call @, username, (findError, technicalUserDetails) =>
            callback findError, technicalUserDetails
