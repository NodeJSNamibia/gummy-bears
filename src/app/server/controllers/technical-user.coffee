# This class represents a technical users controller. It handles all requests related to technical user
async              = require 'async'
TechnicalUserModel = require('../models/technical-user').TechnicalUserModel
TechnicalUserInfoLoader  = require('../util/technical-user-info-loader').TechnicalUserInfoLoader
AbstractController = require('./abstract-controller').AbstractController

exports.TechnicalUserController = class TechnicalUserController extends AbstractController

    _authenticate = (authenticationData, poolManager, queueManager, callback) ->
        @technical-user.authenticate authenticationData, poolManager, queueManager, (authenticationError, authenticationResult) =>
            @release 'technical-user', poolManager, queueManager, (releaseError, releaseResult) =>
                if releaseError?
                    callback releaseError, null
                else
                    callback authenticationError, authenticationResult

    _getTechnicalUser = (username, poolManager, queueManager, callback) ->
        @student.findOne username, (findError, technicalUserDetails) =>
            @release 'technical-user', poolManager, queueManager, (releaseError, releaseResult) =>
                if releaseError?
                    callback releaseError, null
                else
                    callback findError, technicalUserDetails                    

               constructor: (envVal) ->
        @technical-user = new TechnicalUserModel envVal

    authenticate: (authenticationData, poolManager, queueManager, callback) =>
        _authenticate.call @, authenticationData, poolManager, queueManager, (authenticationError, authenticationResult) =>
            callback authenticationError, authenticationResult

    getTechnicalUser: (userName, poolManager, queueManager, callback) =>
        _getStudent.call @, userName, poolManager, queueManager, (getTechnicalUserError, technicalUserDetails) =>
            callback getTechnicalUserError, technicalUserDetails