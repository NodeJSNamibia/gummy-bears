'use strict'

DataManager = require('../util/data-manager').DataManager

exports.StudentModel = class StudentModel
    _saveStudent = (studentData, callback) ->
        @dataManager.saveStudent studentData, (saveError, saveResult) =>
            callback saveError, saveResult

    constructor: (dbURL) ->
        @dataManager = DataManager.getDBManagerInstance dbURL

    saveStudent: (studentData, callback) =>
        # need to address when to set the password
        _saveStudent.call @, studentData, (saveError, saveResult) =>
            callback saveError, saveResult
