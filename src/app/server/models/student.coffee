'use strict'

ConfigurationManager = require('../util/config-manager').ConfigurationManager
DataManager          = require('../util/data-manager').DataManager
validator                = require('validator')
async                = require 'async'

exports.StudentModel = class StudentModel

    "studentNumber": 09873422344,
    "firstName": "Alex",
    "lastName": "Jones",
    "emailAddresses": ["alex.jones@gmail.com","ajones@nust.na"],
    "gender": "Male",
    "title": "Mr",
    "nationality": "Namibian",
    "yearOfStudy": "first",
    "modeOfStudy": "FM",
    "password": "@da33409DDff",
    "homeAddress": {
        "address line 1": "4 Storch Street",
        "address line 2": "Private Bag 12890"
    },
    "courses": ["course1","course2"],
    "programme": "80BHSE"

    _checkAndSanitizeStudentNumber = (studentNumber, callback) ->
        if not validator.isNumeric(studentNumber)
            invalidStudentNumberError = new Error "Invalid Student Number"
            callback invalidStudentNumberError, null
        else
            callback null, validator.toInt(studentNumber)

    _checkAndSanitizeName = (name, errorMessage,  callback) ->
        if not validator.isAlpha(name) or validator.isNull(name)
            invalidNameError = new Error errorMessage
            callback invalidNameError, null
        else
            callback null, validator.trim(name)

    _checkAndSanitizeTitle = (titleValue, callback) ->
        if not (validator.isAlpha(titleValue)  and validator.isIn(titleValue, ["Mr", "Mrs", "Ms"]))
            invalidTitleError = new Error "Invalid Title"
            callback invalidTitleError, null
        else
            callback null, validator.trim(titleValue)

    _checkAndSanitizeForInsertion = (studentData, callback) ->
        checkOptions = {}
        checkOptions["studentNumber"] = (partialCallback) =>
            _checkAndSanitizeStudentNumber.call @, studentData.studentNumber, (studentNumberError, studentNumber) =>
                partialCallback studentNumberError, studentNumber
        checkOptions["firstName"] = (partialCallback) =>
            _checkAndSanitizeName.call @, studentData.firstName, "Invalid Student First Name", (firstNameError, firstName) =>
                partialCallback firstNameError, firstName
        checkOptions["lastName"] = (partialCallback) =>
            _checkAndSanitizeName.call @, studentData.lastName, "Invalid Student Last Name", (lastNameError, lastName) =>
                partialCallback lastNameError, lastName
        checkOptions["title"] = (partialCallback) =>
            _checkAndSanitizeTitle.call @, studentData.title, (titleError, title) =>
                partialCallback titleError, title
        async.parallel checkOptions, (checkError, studentInfo) =>
            callback checkError, studentInfo

    _insertStudent = (studentData, callback) ->
        _checkAndSanitizeForInsertion.call @, studentData, (checkError, studentInfo) =>
            if checkError?
                callback checkError, null
            else
                ConfigurationManager.getConfigurationManager().getDBURL @appEnv, (urlError, dbURL) =>
                    if urlError?
                        callback urlError, null
                    else
                        dataManager = DataManager.getDBManagerInstance dbURL
                        dataManager.saveStudent studentData, (saveError, saveResult) =>
                            callback saveError, saveResult

    constructor: (@appEnv) ->

    insertStudent: (studentData, callback) =>
        _insertStudent.call @, studentData, (saveError, saveResult) =>
            callback saveError, saveResult
