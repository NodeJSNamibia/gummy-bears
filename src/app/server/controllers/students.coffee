'use strict'

# This class represents a students controller. It handles all requests related to students
async              = require 'async'
StudentModel       = require('../models/student').StudentModel
StudentInfoLoader  = require('../util/student-info-loader').StudentInfoLoader
AbstractController = require('./abstract-controller').AbstractController

exports.StudentsController = class StudentsController extends AbstractController

    _authenticate = (authenticationData, poolManager, queueManager, callback) ->
        @student.authenticate authenticationData, poolManager, queueManager, (authenticationError, authenticationResult) =>
            @release poolManager, queueManager, (releaseError, releaseResult) =>
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

    _insertAllStudents = (poolManager, queueManager, callback) ->
        # load student information first
        StudentInfoLoader.getStudentInfoLoader().loadStudents (laodError, allStudents) =>
            if loadError?
                @release poolManager, queueManager, (releaseError, releaseResult) =>
                    if releaseError?
                        callback releaseError, null
                    else
                        callback loadError, null
            else
                async.each allStudents, @_insertSingleStudentIter, (insertError) =>
                    if insertError?
                        console.log insertError
                        @release poolManager, queueManager, (releaseError, releaseResult) =>
                            if releaseError?
                                callback releaseError, null
                            else
                                callback insertError, null
                    else
                        @release poolManager, queueManager, (releaseError, releaseResult) =>
                            if releaseError?
                                callback releaseError, null
                            else
                                callback null, {}

    _createPassword = (studentNumber, passwordData, poolManager, queueManager, callback) ->
        @student.createPassword studentNumber, passwordData, (createPasswordError, createPasswordResult) =>
            @release poolManager, queueManager, (releaseError, releaseResult) =>
                if releaseError?
                    callback releaseError, null
                else
                    callback createPasswordError, createPasswordResult

    _updateCourses = (studentNumber, courseData, poolManager, queueManager, callback) ->
        @student.updateCourses studentNumber, courseData, (courseUpdateError, courseUpdateResult) =>
            @release poolManager, queueManager, (releaseError, releaseResult) =>
                if releaseError?
                    callback releaseError, null
                else
                    callback courseUpdateError, courseUpdateResult

    _getStudent = (studentNumber, poolManager, queueManager, callback) ->
        @student.findOne studentNumber, (findError, studentDetails) =>
            @release poolManager, queueManager, (releaseError, releaseResult) =>
                if releaseError?
                    callback releaseError, null
                else
                    callback findError, studentDetails

    _getAllStudents = (poolManager, queueManager, callback) ->
        @student.findAll (findError, allStudents) =>
            @release poolManager, queueManager, (releaseError, releaseResult) =>
                if releaseError?
                    callback releaseError, null
                else
                    callback findError, allStudents

    constructor: (envVal) ->
        @student = new StudentModel envVal

    insertAllStudents: (poolManager, queueManager, callback) =>
        _insertAllStudents.call @, poolManager, queueManager, (insertAllError, insertAllResult) =>
            callback insertAllError, insertAllResult

    createPassword: (studentNumber, passwordData, poolManager, queueManager, callback) =>
        _createPassword.call @, studentNumber, passwordData, poolManager, (createPasswordError, createPasswordResult) =>
            callback createPasswordError, createPasswordResult

    updateCourses: (studentNumber, courseData, poolManager, queueManager, callback) =>
        _updateCourses.call @, studentNumber, courseData, poolManager, queueManager, (courseUpdateError, courseUpdateResult) =>
            callback courseUpdateError, courseUpdateResult

    authenticate: (authenticationData, poolManager, queueManager, callback) =>
        _authenticate.call @, authenticationData, poolManager, queueManager, (authenticationError, authenticationResult) =>
            callback authenticationError, authenticationResult

    getStudent: (studentNumber, poolManager, queueManager, callback) =>
        _getStudent.call @, studentNumber, poolManager, queueManager, (getStudentError, studentDetails) =>
            callback getStudentError, studentDetails

    getAllStudents: (poolManager, queueManager, callback) =>
        _getAllStudents.call @, poolManager, queueManager, (getAllStudentsError, allStudents) =>
            callback getAllStudentsError, allStudents
