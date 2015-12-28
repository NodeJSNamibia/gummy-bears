'use strict'

ConfigurationManager = require('../util/config-manager').ConfigurationManager
DataManager          = require('../util/data-manager').DataManager
PasswordHandler      = require('../util/password-handler').PasswordHandler
validator            = require('validator')
async                = require 'async'

exports.StudentModel = class StudentModel

    _checkAndSanitizeStudentNumber = (studentNumber, callback) ->
        if not validator.isNumeric(studentNumber)
            invalidStudentNumberError = new Error "Invalid Student Number"
            callback invalidStudentNumberError, null
        else
            callback null, validator.toInt(studentNumber)

    _checkAndSanitizeString = (strValue, errorMessage,  callback) ->
        if not validator.isAlpha(strValue) or validator.isNull(strValue)
            invalidNameError = new Error errorMessage
            callback invalidNameError, null
        else
            callback null, validator.trim(strValue)

    _checkAndSanitizeTitle = (titleValue, callback) ->
        if not (validator.isAlpha(titleValue)  and validator.isIn(titleValue, ["Mr", "Mrs", "Ms"]))
            invalidTitleError = new Error "Invalid Title"
            callback invalidTitleError, null
        else
            callback null, validator.trim(titleValue)

    _checkAndSanitizeYearOfStudy = (yearOfStudy, callback) ->
        if not (validator.isAlpha(yearOfStudy) and validator.isIn(yearOfStudy, ["first", "second", "third", "honours"]))
            invalidYearOfStudyError = new Error "Invalid Year of study"
            callback invalidYearOfStudyError, null
        else
            callback null, validator.trim(yearOfStudy)

    _checkAndSanitizeModeOfStudy = (modeOfStudy, callback) ->
        if not (validator.isAlpha(modeOfStudy) and validator.isIn(modeOfStudy, ["PM","FM"]))
            invalidModeOfStudyError = new Error "Invalid Mode of study"
            callback invalidModeOfStudyError, null
        else
            callback null, validator.trim(modeOfStudy)

    _checkAndSanitizeCourses = (courses, callback) ->
        # will use a regex to represent the array
        callback null, courses

    _checkAndSanitizeEmailAddresses = (emailAddress1, emailAddress2, callback) ->
        emailAddresses = []
        error1Str = undefined
        error2Str = undefined
        emailError = undfefined
        if emailAddress1?
            if not validator.isEmail emailAddress1
                error1Str = "Invalid First Email Address"
            else
                emailAddresses.push emailAddress1
        if emailAddress2?
            if not validator.isEmail emailAddress2
                error2Str = "Invalid Second Email Address"
            else
                emailAddresses.push emailAddress2
        if not error1Str? and not error2Str?
            if emailAddresses.length is 0
                emailError = new Error "No valid email address"
                callback emailError, null
            else
                callback null, emailAddresses
        else
            errorStr = error1Str ? ""
            if error2Str?
                errorStr += " #{error2Str}"
            emailError = new Error errorStr
            callback emailError, null

    _checkAndSanitizeForInsertion = (studentData, callback) ->
        checkOptions = {}
        # add student number for validation
        checkOptions["studentNumber"] = (partialCallback) =>
            _checkAndSanitizeStudentNumber.call @, studentData.studentNumber, (studentNumberError, studentNumber) =>
                partialCallback studentNumberError, studentNumber
        # add the student first name for validation
        checkOptions["firstName"] = (partialCallback) =>
            _checkAndSanitizeString.call @, studentData.firstName, "Invalid Student First Name", (firstNameError, firstName) =>
                partialCallback firstNameError, firstName
        # add the student last name for validation
        checkOptions["lastName"] = (partialCallback) =>
            _checkAndSanitizeString.call @, studentData.lastName, "Invalid Student Last Name", (lastNameError, lastName) =>
                partialCallback lastNameError, lastName
        # add the student title for validation
        checkOptions["title"] = (partialCallback) =>
            _checkAndSanitizeTitle.call @, studentData.title, (titleError, title) =>
                partialCallback titleError, title
        # add the student nationality for validation
        checkOptions["nationality"] = (partialCallback) =>
            _checkAndSanitizeString.call @, studentData.nationality, "Invalid Nationality", (nationalityError, nationality) =>
                partialCallback nationalityError, nationality
        # add the student year of study for validation
        checkOptions["yearOfStudy"] = (partialCallback) =>
            _checkAndSanitizeYearOfStudy.call @, studentData.yearOfStudy, (yearOfStudyError, yearOfStudy) =>
                callback yearOfStudyError, yearOfStudy
        # add the student mode of study for validation
        checkOptions["modeOfStudy"] = (partialCallback) =>
            _checkAndSanitizeModeOfStudy.call @, studentData.modeOfStudy, (modeOfStudyError, modeOfStudy) =>
                partialCallback modeOfStudyError, modeOfStudy
        # add the student programme for validation
        checkOptions["programme"] = (partialCallback) =>
            _checkAndSanitizeString.call @, studentData.programme, "Invalid Programme Code", (programmeError, programme) =>
                partialCallback programmeError, Programme
        # add the student email addresses for validation
        checkOptions["emailAddresses"] = (partialCallback) =>
            _checkAndSanitizeEmailAddresses.call @, studentData.emailAddress1, studentData.emailAddress2, (emailError, emailAddresses) =>
                partialCallback emailError, emailAddresses
        async.parallel checkOptions, (checkError, studentInfo) =>
            callback checkError, studentInfo

    _authenticate = (authenticationData, callback) ->
        _checkAndSanitizeStudentNumber.call @, authenticationData.studentNumber, (studentNumberError, validStudentNumber) =>
            if studentNumberError?
                callback studentNumberError, null
            else
                ConfigurationManager.getConfigurationManager().getDBURL @appEnv, (urlError, dbURL) =>
                    if urlError?
                        callback urlError, null
                    else
                        DataManager.getDBManagerInstance(dbURL).findStudent validStudentNumber, (findStudentError, studentDoc) =>
                            if findStudentError?
                                callback findStudentError, null
                            else
                                new PasswordHandler().verifyPassword authenticationData.password, studentDoc.password, (verifyError, verificationResult) =>
                                    if verifyError?
                                        callback verifyError, null
                                    else
                                        if verificationResult
                                            # will send the proper object after authentication
                                            callback null, {}
                                        else
                                            authenticationError = new Error "Authentication failed for student #{validStudentNumber}"
                                            callback authenticationError, null

    _insertStudent = (studentData, callback) ->
        _checkAndSanitizeForInsertion.call @, studentData, (checkError, studentInfo) =>
            if checkError?
                callback checkError, null
            else
                homeAddress = {}
                if studentData["address line 1"]?
                    homeAddress[addressLine1] = studentData["address line 1"]
                if studentData["address line 2"]?
                    homeAddress[addressLine2] = studentData["address line 2"]
                if studentData["address line 3"]?
                    homeAddress[addressLine3] = studentData["address line 3"]
                if studentData["address line 4"]?
                    homeAddress[addressLine4] = studentData["address line 4"]
                studentInfo["homeAddress"] = homeAddress
                ConfigurationManager.getConfigurationManager().getDBURL @appEnv, (urlError, dbURL) =>
                    if urlError?
                        callback urlError, null
                    else
                        dataManager = DataManager.getDBManagerInstance dbURL
                        dataManager.insertStudent studentInfo, (saveError, saveResult) =>
                            callback saveError, saveResult

    _createPassword = (studentNumber, passwordData, callback) ->
        _checkAndSanitizeStudentNumber.call @, studentNumber, (studentNumberError, validStudentNumber) =>
            if studentNumberError?
                callback studentNumberError, null
            else
                if passwordData.password isnt passwordData.confirmPassword
                    unconfirmedPasswordError = new Error "Password and confirmation are distinct"
                    callback unconfirmedPasswordError, null
                else
                    new PasswordHandler().hashPassword passwordData.password, (hashError, hashedPassword) =>
                        if hashError?
                            callback hashError, null
                        else
                            ConfigurationManager.getConfigurationManager().getDBURL @appEnv, (urlError, dbURL) =>
                                if urlError?
                                    callback urlError, null
                                else
                                    DataManager.getDBManagerInstance(dbURL).updateStudent validStudentNumber, {password: hashedPassword}, (updateError, updateResult) =>
                                        callback updateError, updateResult

    _updateCourses = (studentNumber, courseData, callback) ->
        _checkAndSanitizeStudentNumber.call @, studentNumber, (studentNumberError, validStudentNumber) =>
            if studentNumberError?
                callback studentNumberError, null
            else
                _checkAndSanitizeCourses.call @, courseData.courses, (courseError, validCourses) =>
                    ConfigurationManager.getConfigurationManager().getDBURL @appEnv, (urlError, dbURL) =>
                        if urlError?
                            callback urlError, null
                        else
                            DataManager.getDBManagerInstance(dbURL).updateStudent validStudentNumber, {courses: validCoursess}, (updateError, updateResult) =>
                                callback updateError, updateResult

    _findOne = (studentNumber, callback) ->
        _checkAndSanitizeStudentNumber.call @, studentNumber, (studentNumberError, validStudentNumber) =>
            if studentNumberError?
                callback studentNumberError, null
            else
                ConfigurationManager.getConfigurationManager().getDBURL @appEnv, (urlError, dbURL) =>
                    if urlError?
                        callback urlError, null
                    else
                        DataManager.getDBManagerInstance(dbURL).updateStudent validStudentNumber, (findError, findResult) =>
                            callback findError, findResult

    constructor: (@appEnv) ->

    insertStudent: (studentData, callback) =>
        _insertStudent.call @, studentData, (saveError, saveResult) =>
            callback saveError, saveResult

    createPassword: (studentNumber, passwordData, callback) =>
        _createPassword.call @, studentNumber, passwordData, (createPasswordError, createPasswordResult) =>
            callback createPasswordError, createPasswordResult

    updateCourses: (studentNumber, courseData, callback) =>
        _updateCourses.call @, studentNumber, courseData, (courseUpdateError, courseUpdateResult) =>
            callback courseUpdateError, courseUpdateResult

    authenticate: (authenticationData, callback) =>
        _authenticate.call @, authenticationData, (authenticationError, authenticationResult) =>
            callback authenticationError, authenticationResult

    findOne: (studentNumber, callback) =>
        _findOne.call @, studentNumber, (findError, studentDetails) =>
            callback findError, studentDetails
