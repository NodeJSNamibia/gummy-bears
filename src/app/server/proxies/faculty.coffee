'use strict'

FacultyModel = require('../models/faculty').FacultyModel

exports.FacultyProxy = class FacultyProxy

    _getID = (enrolledInProgramme, callback) ->
        @faculty.getID enrolledInProgramme, (facultyIDError, facultyID) =>
            callback facultyIDError, facultyID

    constructor: (appEnv) ->
        @faculty = new FacultyModel appEnv

    getID: (enrolledInProgramme, callback) =>
        _getID.call @, enrolledInProgramme, (facultyIDError, facultyID) =>
            callback facultyIDError, facultyID
