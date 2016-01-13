'use strict'

# This class represents a technical users controller.
# It handles all requests related to technical user

async                   = require 'async'
TechnicalUserModel      = require('../models/technical-user').TechnicalUserModel
AbstractController      = require('./abstract-controller').AbstractController

exports.TechnicalUsersController = class TechnicalUsersController extends AbstractController

    _authenticate = (authenticationData, poolManager, queueManager, callback) ->
        @technicalUser.authenticate authenticationData, (authenticationError, authenticationResult) =>
            @release 'technical-users', poolManager, queueManager, (releaseError, releaseResult) =>
                if releaseError?
                    callback releaseError, null
                else
                    callback authenticationError, authenticationResult

    _getTechnicalUser = (username, poolManager, queueManager, callback) ->
        @technicalUser.findOne username, (findError, technicalUserDetails) =>
            @release 'technical-users', poolManager, queueManager, (releaseError, releaseResult) =>
                if releaseError?
                    callback releaseError, null
                else
                    callback findError, technicalUserDetails

    constructor: (envVal) ->
        @technicalUser = new TechnicalUserModel envVal

    authenticate: (authenticationData, poolManager, queueManager, callback) =>
        _authenticate.call @, authenticationData, poolManager, queueManager, (authenticationError, authenticationResult) =>
            callback authenticationError, authenticationResult

    getTechnicalUser: (userName, poolManager, queueManager, callback) =>
        _getStudent.call @, userName, poolManager, queueManager, (getTechnicalUserError, technicalUserDetails) =>
            callback getTechnicalUserError, technicalUserDetails
