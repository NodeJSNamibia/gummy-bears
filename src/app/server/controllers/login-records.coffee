'use strict'

# This class represents a login records controller

LoginRecordModel   = require('../models/login-record').LoginRecordModel
AbstractController = require('./abstract-controller').AbstractController

exports.LoginRecordsController = class LoginRecordsController extends AbstractController

    _save = (studentNumber, poolManager, callback) ->
        @loginRecord.save studentNumber, (saveLRError, saveLRResult) =>
            @release poolManager, (releaseError, releaseResult) =>
                if releaseError?
                    callback releaseError, null
                else
                    callback saveLRError, saveLRResult

    constructor: (envVal) ->
        @loginRecord = new LoginRecordModel envVal

    save: (studentNumber, poolManager, callback) =>
        _save.call @, studentNumber, poolManager, (saveLRError, saveLRResult) =>
            callback saveLRError, saveLRResult
