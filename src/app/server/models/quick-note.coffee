'use strict'

AuthorizationManager       = require('../lib/authorization-manager').AuthorizationManager
CheckAndSanitizationHelper = require('../util/sanitization-helper').CheckAndSanitizationHelper
ConfigurationManager       = require('../lib/config-manager').ConfigurationManager
DataManager                = require('../lib/data-manager').DataManager
SocketContainer            = require('../util/socket-container').SocketContainer
validator                  = require('validator')
async                      = require 'async'

exports.QuickNoteModel = class QuickNoteModel

    _checkAuthorization = (username, mthName, technicalUserProxy, callback) ->
        technicalUserProxy.findTechnicalUserProfile username, (technicalUserProfileError, technicalUserProfile) =>
            if technicalUserProfileError?
                callback technicalUserProfileError, null
            else
                AuthorizationManager.getAuthorizationManagerInstance().checkAuthorization technicalUserProfile, mthName, (authorizationError, authorizationResult) =>
                    callback authorizationError, authorizationResult

    _checkAndSanitizeNotificationID = (notificationID, callback) ->
        @sanitizationHelper.checkAndSanitizeID notificationID, "Error! Null Notification ID", "Invalid Notification ID", true, validator, (notificationIDError, validNotificationID) =>
            callback notificationIDError, validNotificationID

    _checkAndSanitizeForInsertion = (notificationData, callback) ->
        callback null, null

    _notify = (notificationID, notificationData, callback) ->
        _checkAndSanitizeNotificationID.call @, notificationID, (notificationIDError, validNotificationID) =>
            if notificationIDError?
                callback notificationIDError, null
            else
                _checkAndSanitizeForInsertion.call @, notificationData, (checkError, validNotificationData) =>
                    if checkError?
                        callback checkError, null
                    else
                        ConfigurationManager.getConfigurationManager().getDBURL @appEnv, (urlError, dbURL) =>
                            if urlError?
                                callback urlError, null
                            else
                                # use the socket container to propagate the notification
                                DataManager.getDBManagerInstance(dbURL).insertNotification validNotificationID, validNotificationData, (saveError, saveResult) =>
                                    callback saveError, saveResult

    constructor: (@appEnv) ->
        @sanitizationHelper = new CheckAndSanitizationHelper()

    checkAuthorization: (username, mthName, technicalUserProxy, callback) =>
        _checkAuthorization.call @, username, mthName, technicalUserProxy, (authorizationError, authorizationResult) =>
            callback authorizationError, authorizationResult

    notify: (notificationID, notificationData, callback) =>
        _notify.call @, notificationID, notificationData, (notificationError, notificationResult) =>
            callback notificationError, notificationResult
