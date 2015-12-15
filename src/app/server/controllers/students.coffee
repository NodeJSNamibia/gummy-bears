'use strict'

# This class represents a students controller. It handles all requests related to students
async = require 'async'

StudentModel = require('../models/student').StudentModel

exports.StudentsController = class StudentsController

    _insertSingleStudentIter = (singleStudentData, callback) ->
        @student.saveStudent singleStudentData, (saveError, saveResult) =>
            callback saveError, saveResult

    constructor: (dbURL) ->
        @student = new StudentModel dbURL

    insertAllStudents: (callback) =>
        callback null, null

    saveAllStudents: (callback) =>
        # will read student data from a file
        # and then add those students one at a time
        allStudents = []
        async.each allStudents, @insertSingleStudentIter, (insertError) =>
            if insertError?
                console.log insertError
                callback insertError, null
            else
                # Need to figure out what to send back to the client
                callback null, {}

    insertSingleStudentIter: (singleStudentData, callback) =>
        _insertSingleStudentIter.call @, singleStudentData, (insertError, insertResult) =>
            callback insertError
