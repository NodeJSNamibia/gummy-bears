'use strict'

TechnicalUserModel = require('../models/technical-user').TechnicalUserModel

exports.TechnicalUserProxy = class TechnicalUserProxy

    _findTechnicalUserProfile = (username, callback) ->
        @technicalUser.findTechnicalUserProfile username, (technicalUserProfileError, technicalUserProfile) =>
            callback technicalUserProfileError, technicalUserProfile

    constructor: (appEnv) ->
        @technicalUser = new TechnicalUserModel appEnv

    findTechnicalUserProfile: (username, callback) =>
        _findTechnicalUserProfile.call @, username, (technicalUserProfileError, technicalUserProfile) =>
            callback technicalUserProfileError, technicalUserProfile
