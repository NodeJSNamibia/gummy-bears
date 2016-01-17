'use strict'

QuickNoteModel     = require('../models/quick-note').QuickNoteModel
AbstractController = require('./abstract-controller').AbstractController
TechnicalUserProxy = require('../proxies/technical-user').TechnicalUserProxy
uuid               = require 'uuid4'

exports.QuickNotesController = class QuickNotesController extends AbstractController

    _notify = (username, notificationData, poolManager, queueManager, callback) ->
        @quickNote.checkAuthorization username, 'notify', @technicalUserProxy, (authorizationError, authorizationResult) =>
            if authorizationError?
                callback authorizationError, null
            else if not authorizationResult
                unauthorizedInsertionError = new Error "Authorization Error! User #{username} is not authorized to submit quick notification"
                callback unauthorizedInsertionError, null
            else
                @quickNote.notify uuid(), notificationData, (saveError, saveResult) =>
                    if saveError?
                        @release 'quickNotes', poolManager, queueManager, (releaseError, releaseResult) =>
                            if releaseError?
                                callback releaseError, null
                            else
                                callback saveError, null
                    else
                        @release 'quickNotes', poolManager, queueManager, (releaseError, releaseResult) =>
                            if releaseError?
                                callback releaseError, null
                            else
                                callback null, saveResult

    constructor: (envVal) ->
        @quickNote = new QuickNoteModel envVal
        @technicalUser = new TechnicalUserModel envVal

    notify: (username, notificationData, poolManager, queueManager, callback) =>
        _notify.call @, username, notificationData, poolManager, queueManager, (notificationError, notificationResult) =>
            callback notificationError, notificationResult
