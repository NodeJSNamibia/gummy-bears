'use strict'

ConfigurationManager = require('../lib/config-manager').ConfigurationManager
DataManager          = require('../lib/data-manager').DataManager
validator            = require('validator')
async                = require 'async'

exports.FacultyModel = class FacultyModel

    _checkAndSanitizeFacultyID = (facultyId, callback) ->
        callback null, facultyId

    _checkAndSanitizeForInsertion = (facultyData, callback) ->
        callback null, facultyData

    _insertFaculty = (facultyId, facultyData, callback) ->
        _checkAndSanitizeFacultyID.call @, facultyId, (facultyIdError, validFacultyID) =>
            if facultyIdError?
                callback facultyIdError, null
            else
                _checkAndSanitizeForInsertion.call @, facultyData, (facultyDataError, validFacultyData) =>
                    if facultyDataError?
                        callback facultyDataError, null
                    else
                        ConfigurationManager.getConfigurationManager().getDBURL @appEnv, (urlError, dbURL) =>
                            if urlError?
                                callback urlError, null
                            else
                                dataManager = DataManager.getDBManagerInstance dbURL
                                dataManager.insertFaculty validFacultyID, validFacultyData, (saveError, saveResult) =>
                                    callback saveError, saveResult

    constructor: (@appEnv) ->

    insertFaculty: (facultyId, facultyData, callback) =>
        _insertFaculty.call @, facultyId, facultyData, (insertError, insertResult) =>
            callback insertError, insertResult
