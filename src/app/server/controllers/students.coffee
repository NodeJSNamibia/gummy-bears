'use strict'

# This class represents a students controller. It handles all requests related to students
async             = require 'async'
StudentModel      = require('../models/student').StudentModel
StudentInfoLoader = require('../util/student-info-loader').StudentInfoLoader

exports.StudentsController = class StudentsController

    _release = (poolManager, controllerRef, callback) ->
        poolManager.release 'students', controllerRef, (releaseError, releaseResult) =>
            callback releaseError, releaseResult

    _authenticate = (authenticationData, poolManager, callback) ->
        @student.authenticate authenticationData, poolManager, (authenticationError, authenticationResult) =>
            _release.call @, poolManager, @, (releaseError, releaseResult) =>
                if releaseError?
                    callback releaseError, null
                else
                    callback authenticationError, authenticationResult

    _insertSingleStudentIter = (singleStudentData, callback) ->
        # create the proper object representing the student
        studentEmails = []
        studentEmails.push singleStudentData["Email 1"]
        studentEmails.push singleStudentData["Email 2"]
        studentInfo =
            studentNumber: singleStudentData["Student Number"]
            firstName: singleStudentData["First Name"]
            lastName: singleStudentData["Last Name"]
            gender: singleStudentData["Gender"]
            emailAddresses: studentEmails
            nationality: singleStudentData["Nationality"]
            yearOfStudy: singleStudentData["Year Of Study"]
            modeOfStudy: singleStudentData["Mode Of Study"]
            programme: singleStudentData["Programme Code"]
            homeAddress:
                street: singleStudentData["Street Name"]
                number: singleStudentData["Street Number"]
                city: singleStudentData["City"]
                region: singleStudentData["Region"]
                country: singleStudentData["Country"]
        @student.insertStudent studentInfo, (saveError, saveResult) =>
            callback saveError, saveResult

    _insertAllStudents = (poolManager, callback) ->
        # load student information first
        StudentInfoLoader.getStudentInfoLoader().loadStudents (laodError, allStudents) =>
            if loadError?
                _release.call @, poolManager, @, (releaseError, releaseResult) =>
                    if releaseError?
                        callback releaseError, null
                    else
                        callback loadError, null
            else
                async.each allStudents, @_insertSingleStudentIter, (insertError) =>
                    if insertError?
                        console.log insertError
                        _release.call @, poolManager, @, (releaseError, releaseResult) =>
                            if releaseError?
                                callback releaseError, null
                            else
                                callback insertError, null
                    else
                        _release.call @, poolManager, @, (releaseError, releaseResult) =>
                            if releaseError?
                                callback releaseError, null
                            else
                                callback null, {}

    _createPassword = (studentNumber, passwordData, poolManager, callback) ->
        @student.createPassword studentNumber, passwordData, (createPasswordError, createPasswordResult) =>
            _release.call @, poolManager, @, (releaseError, releaseResult) =>
                if releaseError?
                    callback releaseError, null
                else
                    callback createPasswordError, createPasswordResult

    _updateCourses = (studentNumber, courseData, poolManager, callback) ->
        @student.updateCourses studentNumber, courseData, (courseUpdateError, courseUpdateResult) =>
            _release.call @, poolManager, @, (releaseError, releaseResult) =>
                if releaseError?
                    callback releaseError, null
                else
                    callback courseUpdateError, courseUpdateResult

    _getStudent = (studentNumber, poolManager, callback) ->
        @student.findOne studentNumber, (findError, studentDetails) =>
            _release.call @, poolManager, @, (releaseError, releaseResult) =>
                if releaseError?
                    callback releaseError, null
                else
                    callback findError, studentDetails

    _getAllStudents = (poolManager, callback) ->
        @student.findAll (findError, allStudents) =>
            _release.call @, poolManager, @, (releaseError, releaseResult) =>
                if releaseError?
                    callback releaseError, null
                else
                    callback findError, allStudents

    constructor: (envVal) ->
        @student = new StudentModel envVal

    insertAllStudents: (poolManager, callback) =>
        _insertAllStudents.call @, poolManager, (insertAllError, insertAllResult) =>
            callback insertAllError, insertAllResult

    createPassword: (studentNumber, passwordData, poolManager, callback) =>
        _createPassword.call @, studentNumber, passwordData, poolManager, (createPasswordError, createPasswordResult) =>
            callback createPasswordError, createPasswordResult

    updateCourses: (studentNumber, courseData, poolManager, callback) =>
        _updateCourses.call @, studentNumber, courseData, poolManager, (courseUpdateError, courseUpdateResult) =>
            callback courseUpdateError, courseUpdateResult

    authenticate: (authenticationData, poolManager, callback) =>
        _authenticate.call @, authenticationData, poolManager, (authenticationError, authenticationResult) =>
            callback authenticationError, authenticationResult

    getStudent: (studentNumber, poolManager, callback) =>
        _getStudent.call @, studentNumber, poolManager, (getStudentError, studentDetails) =>
            callback getStudentError, studentDetails

    getAllStudents: (poolManager, callback) =>
        _getAllStudents.call @, poolManager, (getAllStudentsError, allStudents) =>
            callback getAllStudentsError, allStudents
