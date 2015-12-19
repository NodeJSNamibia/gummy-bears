'use strict'

ConfigurationManager = require('../util/config-manager').ConfigurationManager
DataManager          = require('../util/data-manager').DataManager
check                = require('validator').check
sanitize             = require('validator').sanitize

exports.StudentModel = class StudentModel
    _cleanForInsertion = (studentData, callback) ->
        callback null, null

    _insertStudent = (studentData, callback) ->
        # first validate and sanitize the object
        ConfigurationManager.getConfigurationManager().getDBURL @appEnv, (urlError, dbURL) =>
            if urlError?
                callback urlError, null
            else
                dataManager = DataManager.getDBManagerInstance dbURL
                dataManager.saveStudent studentData, (saveError, saveResult) =>
                    callback saveError, saveResult

    constructor: (@appEnv) ->

    insertStudent: (studentData, callback) =>
        _insertStudent.call @, studentData, (saveError, saveResult) =>
            callback saveError, saveResult
