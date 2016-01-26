'use strict'

AuthorizationManager       = require('../lib/authorization-manager').AuthorizationManager
CheckAndSanitizationHelper = require('../util/sanitization-helper').CheckAndSanitizationHelper
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
                AuthorizationManager.getInstance().checkAuthorization technicalUserProfile, mthName, (authorizationError, authorizationResult) =>
                    callback authorizationError, authorizationResult

    _checkAndSanitizeNotificationID = (notificationID, callback) ->
        @sanitizationHelper.checkAndSanitizeID notificationID, "Error! Null Notification ID", "Invalid Notification ID", true, validator, (notificationIDError, validNotificationID) =>
            callback notificationIDError, validNotificationID

    _checkAndSanitizeNotificationContent = (notificationContent, callback) ->
        @sanitizationHelper.checkAndSanitizeWords notificationContent, "Error in notification content", "Empty notification content", validator, (notificationContentError, validNotificationContent) =>
            callback notificationContentError, validNotificationContent

    _checkAndSanitizeNotificationTarget = (notificationTarget, callback) ->
        @sanitizationHelper.checkAndSanitizeCode notificationTarget, "Invalid Notification Target", validator, (notificationTargetError, validNotificationTarget) =>
            callback notificationTargetError, validNotificationTarget

    _checkAndSanitizeForInsertion = (notificationData, callback) ->
        checkOptions =
            content: (contentPartialCallback) =>
                _checkAndSanitizeNotificationContent.call @, notificationData.content, (contentError, validNotificationContent) =>
                    contentPartialCallback contentError, validNotificationContent
            target: (targetPartialCallback) =>
                _checkAndSanitizeNotificationTarget.call @, notificationData.target, (targetError, validNotificationTarget) =>
                    targetPartialCallback targetError, validNotificationTarget
        async.parallel checkOptions, (checkInsertError, validNotification) =>
            callback checkInsertError, validNotification

    _notify = (notificationID, notificationData, callback) ->
        _checkAndSanitizeNotificationID.call @, notificationID, (notificationIDError, validNotificationID) =>
            if notificationIDError?
                callback notificationIDError, null
            else
                _checkAndSanitizeForInsertion.call @, notificationData, (checkError, validNotificationData) =>
                    if checkError?
                        callback checkError, null
                    else
                        DataManager.getInstance @appEnv, (dbInstanceError, dbInstance) =>
                            if dbInstanceError?
                                callback dbInstanceError, null
                            else
                                dbInstance.insertNotification validNotificationID, validNotificationData, (saveError, saveResult) =>
                                    if saveError?
                                        callback saveError, null
                                    else
                                        SocketContainer.getSocketContainer().sendNotification validNotificationData.target, validNotificationData.content, @appEnv, (sendNotificationError, sendNotificationResult) =>
                                            callback sendNotificationError, sendNotificationResult

    constructor: (@appEnv) ->
        @sanitizationHelper = new CheckAndSanitizationHelper()

    checkAuthorization: (username, mthName, technicalUserProxy, callback) =>
        _checkAuthorization.call @, username, mthName, technicalUserProxy, (authorizationError, authorizationResult) =>
            callback authorizationError, authorizationResult

    notify: (notificationID, notificationData, callback) =>
        _notify.call @, notificationID, notificationData, (notificationError, notificationResult) =>
            callback notificationError, notificationResult
