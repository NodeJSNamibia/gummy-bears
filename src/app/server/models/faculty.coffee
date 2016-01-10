'use strict'

ConfigurationManager = require('../lib/config-manager').ConfigurationManager
DataManager          = require('../lib/data-manager').DataManager
validator            = require('validator')
async                = require 'async'

exports.FacultyModel = class FacultyModel

    _checkAndSanitizeFacultyID = (facultyId, callback) ->
        if not validator.isAlpha(facultyId) or validator.isNull(facultyId)
            invalidFacultyIDError = new Error "Invalid Faculty Identifier"
            callback invalidFacultyIDError, null
        else
            callback null, validator.trim(facultyId)

    _checkAndSanitizeName = (name, callback) ->
        nameComponentError = undefined
        nameComponents = name.split " "
        validNameComponents = []
        for nameComponentItem in nameComponents
            do (nameComponentItem) =>
                if not validator.isAlpha(nameComponentItem) or validator.isNull(nameComponentItem)
                    if not nameComponentError?
                        nameComponentError = new Error "Ivalid name part"
                else
                    validNameComponents.push nameComponentItem
        if nameComponentError?
            callback nameComponentError, null
        else if validNameComponents.length > 0
            callback null, validNameComponents.join(' ')
        else
            emptyNameError = new Error "Emtpy name"
            callback emptyNameError, null

    _checkAndSanitizeContact = (contactDetails, callback) ->
        callback null, null

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
