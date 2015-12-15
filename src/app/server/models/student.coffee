'use strict'

ConfigurationManager = require('../util/config-manager').ConfigurationManager
DataManager          = require('../util/data-manager').DataManager

exports.StudentModel = class StudentModel
    _saveStudent = (studentData, callback) ->
        ConfigurationManager.getConfigurationManager().getDBURL @appEnv, (urlError, dbURL) =>
            if urlError?
                callback urlError, null
            else
                dataManager = DataManager.getDBManagerInstance dbURL
                dataManager.saveStudent studentData, (saveError, saveResult) =>
                    callback saveError, saveResult

    constructor: (@appEnv) ->

    saveStudent: (studentData, callback) =>
        # validate and sanitize the student info
        _saveStudent.call @, studentData, (saveError, saveResult) =>
            callback saveError, saveResult
