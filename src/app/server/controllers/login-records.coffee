'use strict'

# This class represents a login records controller

LoginRecordModel = require('../models/login-record').LoginRecordModel

exports.LoginRecordsController = class LoginRecordsController
    _save = (studentNumber, callback) ->
        @loginRecord.save studentNumber, (saveLRError, saveLRResult) =>
            callback saveLRError, saveLRResult

    constructor: (envVal) ->
        @loginRecord = new LoginRecordModel envVal

    save: (studentNumber, callback) =>
        _save.call @, studentNumber, (saveLRError, saveLRResult) =>
            callback saveLRError, saveLRResult
