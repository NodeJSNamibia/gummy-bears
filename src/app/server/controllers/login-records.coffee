'use strict'

# This class represents a login records controller

LoginRecordModel = require('../models/login-record').LoginRecordModel

exports.LoginRecordsController = class LoginRecordsController
    _release = (poolManager, controllerRef, callback) ->
        poolManager.release 'students', controllerRef, (releaseError, releaseResult) =>
            callback releaseError, releaseResult

    _save = (studentNumber, poolManager, callback) ->
        @loginRecord.save studentNumber, (saveLRError, saveLRResult) =>
            _release.call @, poolManager, @, (releaseError, releaseResult) =>
                if releaseError?
                    callback releaseError, null
                else
                    callback saveLRError, saveLRResult

    constructor: (envVal) ->
        @loginRecord = new LoginRecordModel envVal

    save: (studentNumber, poolManager, callback) =>
        _save.call @, studentNumber, poolManager, (saveLRError, saveLRResult) =>
            callback saveLRError, saveLRResult
