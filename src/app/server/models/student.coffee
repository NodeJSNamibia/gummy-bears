'use strict'

exports.StudentModel = class StudentModel
    _saveStudent = (studentData, callback) ->
        @dataManager.saveStudent studentData, (saveError, saveResult) =>
            callback saveError, saveResult

    constructor: (@dataManager) ->
        # create a student model

    saveStudent: (studentData, callback) =>
        # need to address when to set the password
        _saveStudent.call @, studentData, (saveError, saveResult) =>
            callback saveError, saveResult
