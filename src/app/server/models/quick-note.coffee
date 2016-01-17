'use strict'

AuthorizationManager       = require('../lib/authorization-manager').AuthorizationManager
CheckAndSanitizationHelper = require('../util/sanitization-helper').CheckAndSanitizationHelper

exports.QuickNoteModel = class QuickNoteModel

    _checkAuthorization = (username, mthName, technicalUserProxy, callback) ->
        technicalUserProxy.findTechnicalUserProfile username, (technicalUserProfileError, technicalUserProfile) =>
            if technicalUserProfileError?
                callback technicalUserProfileError, null
            else
                AuthorizationManager.getAuthorizationManagerInstance().checkAuthorization technicalUserProfile, mthName, (authorizationError, authorizationResult) =>
                    callback authorizationError, authorizationResult

    _notify = (notificationID, notificationData, callback) ->
        callback null, null

    constructor: (@appEnv) ->
        @sanitizationHelper = new CheckAndSanitizationHelper()

    checkAuthorization: (username, mthName, technicalUserProxy, callback) =>
        _checkAuthorization.call @, username, mthName, technicalUserProxy, (authorizationError, authorizationResult) =>
            callback authorizationError, authorizationResult

    notify: (notificationID, notificationData, callback) =>
        _notify.call @, notificationID, notificationData, (notificationError, notificationResult) =>
            callback notificationError, notificationResult
