'use strict'

StudentModel = require('../models/student').StudentModel

exports.StudentProxy = class StudentProxy

    _findProgramme = (studentNumber, callback) ->
        @student.findProgramme studentNumber, (programmeError, enrolledInProgramme) =>
            callback programmeError, enrolledInProgramme

    constructor: (appEnv) ->
        @student = new StudentModel appEnv

    findProgramme: (studentNumber, callback) =>
        _findProgramme.call @, studentNumber, (programmeError, enrolledInProgramme) =>
            callback programmeError, enrolledInProgramme
