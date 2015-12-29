'use strict'

# This class represents a students controller. It handles all requests related to students
async             = require 'async'
StudentModel      = require('../models/student').StudentModel
StudentInfoLoader = require('../util/student-info-loader').StudentInfoLoader

exports.StudentsController = class StudentsController

    _authenticate = (authenticationData, callback) ->
        @student.authenticate authenticationData, (authenticationError, authenticationResult) =>
            if authenticationError?
                callback authenticationError, null
            else
                callback null, authenticationResult

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

    _insertAllStudents = (callback) ->
        # load student information first
        StudentInfoLoader.getStudentInfoLoader().loadStudents (laodError, allStudents) =>
            if loadError?
                callback loadError, null
            else
                async.each allStudents, @_insertSingleStudentIter, (insertError) =>
                    if insertError?
                        console.log insertError
                        callback insertError, null
                    else
                        # send a success response to the client
                        callback null, {}

    _createPassword = (studentNumber, passwordData, callback) ->
        @student.createPassword studentNumber, passwordData, (createPasswordError, createPasswordResult) =>
            callback createPasswordError, createPasswordResult

    _updateCourses = (studentNumber, courseData, callback) ->
        @student.updateCourses studentNumber, courseData, (courseUpdateError, courseUpdateResult) =>
            callback courseUpdateError, courseUpdateResult

    _getStudent = (studentNumber, callback) ->
        @student.findOne studentNumber, (findError, studentDetails) =>
            callback findError, studentDetails

    _getAllStudents = (callback) ->
        @student.findAll (findError, allStudents) =>
            callback findError, allStudents

    constructor: (envVal) ->
        @student = new StudentModel envVal

    insertAllStudents: (callback) =>
        _insertAllStudents.call @, (insertAllError, insertAllResult) =>
            callback insertAllError, insertAllResult

    createPassword: (studentNumber, passwordData, callback) =>
        _createPassword.call @, studentNumber, passwordData, (createPasswordError, createPasswordResult) =>
            callback createPasswordError, createPasswordResult

    updateCourses: (studentNumber, courseData, callback) =>
        _updateCourses.call @, studentNumber, courseData, (courseUpdateError, courseUpdateResult) =>
            callback courseUpdateError, courseUpdateResult

    authenticate: (authenticationData, callback) =>
        _authenticate.call @, authenticationData, (authenticationError, authenticationResult) =>
            callback authenticationError, authenticationResult

    getStudent: (studentNumber, callback) =>
        _getStudent.call @, studentNumber, (getStudentError, studentDetails) =>
            callback getStudentError, studentDetails

    getAllStudents: (callback) =>
        _getAllStudents.call @, (getAllStudentsError, allStudents) =>
            callback getAllStudentsError, allStudents
