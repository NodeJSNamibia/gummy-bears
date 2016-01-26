'use strict'

# This class represents a login record model

DataManager          = require('../lib/data-manager').DataManager
uuid                 = require 'uuid4'
moment               = require 'moment'

exports.LoginRecordModel = class LoginRecordModel

    _save = (validStudentNumber, callback) ->
        DataManager.getInstance @appEnv, (dbInstanceError, dbInstance) =>
            if dbInstanceError?
                callback dbInstanceError, null
            else
                now = moment()
                recordID = uuid()
                studentLR =
                    id: recordID
                    studentNumber: validStudentNumber
                    date: now.format('YYYY-MM-DD')
                    time: now.format('HH:mm')
                dbInstance.insertLoginRecord recordID, studentLR, (saveError, saveResult) =>
                    callback saveError, saveResult

    constructor: (@appEnv) ->

    save: (studentNumber, callback) =>
        _save.call @, studentNumber, (saveLRError, saveLRResult) =>
            callback saveLRError, saveLRResult
