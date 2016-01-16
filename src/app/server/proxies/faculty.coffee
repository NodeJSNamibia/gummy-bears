'use strict'

FacultyModel = require('../models/faculty').FacultyModel

exports.FacultyProxy = class FacultyProxy

    _getID = (enrolledInProgramme, callback) ->
        @faculty.getID enrolledInProgramme, (facultyIDError, facultyID) =>
            callback facultyIDError, facultyID

    _getName = (enrolledInProgramme, callback) ->
        @faculty.getName enrolledInProgramme, (facultyNameError, facultyNameObj) =>
            callback facultyNameError, facultyNameObj

    constructor: (appEnv) ->
        @faculty = new FacultyModel appEnv

    getID: (enrolledInProgramme, callback) =>
        _getID.call @, enrolledInProgramme, (facultyIDError, facultyID) =>
            callback facultyIDError, facultyID

    getName: (enrolledInProgramme, callback) =>
        _getName.call @, enrolledInProgramme, (facultyNameError, facultyNameObj) =>
            callback facultyNameError, facultyNameObj
