'use strict'

# This class represents a login record model

ConfigurationManager = require('../util/config-manager').ConfigurationManager
DataManager          = require('../util/data-manager').DataManager
uuid                 = require 'uuid4'
moment               = require 'moment'

exports.LoginRecordModel = class LoginRecordModel

    _save = (validStudentNumber, callback) ->
        ConfigurationManager.getConfigurationManager().getDBURL @appEnv, (urlError, dbURL) =>
            if urlError?
                callback urlError, null
            else
                now = moment()
                recordID = uuid()
                studentLR =
                    id: recordID
                    studentNumber: validStudentNumber
                    date: now.format('YYYY-MM-DD')
                    time: now.format('HH:mm')
                dataManager = DataManager.getDBManagerInstance dbURL
                dataManager.insertLoginRecord recordID, studentLR, (saveError, saveResult) =>
                    callback saveError, saveResult

    constructor: (@appEnv) ->

    save: (studentNumber, callback) =>
        _save.call @, studentNumber, (saveLRError, saveLRResult) =>
            callback saveLRError, saveLRResult
