'use strict'

AuthorizationManager = require('../lib/authorization-manager').AuthorizationManager
ConfigurationManager = require('../lib/config-manager').ConfigurationManager
DataManager          = require('../lib/data-manager').DataManager
PasswordHandler      = require('../util/password-handler').PasswordHandler
validator            = require('validator')
async                = require 'async'

exports.StudentModel = class StudentModel

    _checkAndSanitizeStudentNumber = (studentNumber, callback) ->
        if validator.isNull(studentNumber) or not validator.isNumeric(studentNumber)
            invalidStudentNumberError = new Error "Invalid Student Number"
            callback invalidStudentNumberError, null
        else
            callback null, validator.toInt(studentNumber)

    # should change the programme check and sanitization
    _checkAndSanitizeString = (strValue, errorMessage,  callback) ->
        if not validator.isAlpha(strValue) or validator.isNull(strValue)
            invalidNameError = new Error errorMessage
            callback invalidNameError, null
        else
            callback null, validator.trim(strValue)

    _checkAndSanitizeTitle = (titleValue, callback) ->
        if validator.isNull(titleValue) or not (validator.isAlpha(titleValue)  and validator.isIn(titleValue, ["Mr", "Mrs", "Ms"]))
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
        courseCodeErrorStrs = []
        validCourseCodes = []
        for singleCourseCode, singleCourseCodeIdx in courses
            do (singleCourseCode, singleCourseCodeIdx) =>
                if validator.isNull(singleCourseCode) or not validator.isAlphanumeric(singleCourseCode)
                    courseCodeErrorStrs.push "Course Item #{singleCourseCodeIdx + 1} Error: Invalid Course Code"
                else
                    validCourseCodes.push validator.trim(singleCourseCode)
        if courseCodeErrorStrs.length > 0
            callback new Error(courseCodeErrorStrs.join(', ')), null
        else
            callback null, validCourseCodes

    _checkAndSanitizeEmailAddresses = (emailAddresses, callback) ->
        validEmailAddresses = []
        emailAddressErrorStrs = []
        for singleEmailAddress, singleEmailAddressIdx in emailAddresses
            do (singleEmailAddress, singleEmailAddressIdx) =>
                if validator.isNull(singleEmailAddress) or not validator.isEmail(singleEmailAddress)
                    emailAddressErrorStrs.push "Email Address Item #{singleEmailAddressIdx + 1} Error: Invalid Email Address"
                else
                    validEmailAddresses.push validator.trim(singleEmailAddress)
        if validEmailAddresses.length > 0
            callback null, validEmailAddresses
        else
            callback new Error(emailAddressErrorStrs.join(', ')), null

    _checkAndSanitizeForInsertion = (studentData, callback) ->
        checkOptions =
            studentNumber: (studentNumberPartialCallback) =>
                _checkAndSanitizeStudentNumber.call @, studentData.studentNumber, (studentNumberError, validStudentNumber) =>
                    studentNumberPartialCallback studentNumberError, validStudentNumber
            firstName: (firstNamePartialCallback) =>
                _checkAndSanitizeString.call @, studentData.firstName, "Invalid Student First Name", (firstNameError, validFirstName) =>
                    firstNamePartialCallback firstNameError, validFirstName[0].toUpperCase() + validFirstName[1..-1].toLowerCase()
            lastName: (lastNamePartialCallback) =>
                _checkAndSanitizeString.call @, studentData.lastName, "Invalid Student Last Name", (lastNameError, validLastName) =>
                    lastNamePartialCallback lastNameError, validLastName[0].toUpperCase() + validLastName[1..-1].toLowerCase()
            nationality: (nationalityPartialCallback) =>
                _checkAndSanitizeString.call @, studentData.nationality, "Invalid Nationality", (nationalityError, validNationality) =>
                    nationalityPartialCallback nationalityError, validNationality
            yearOfStudy: (yearOfStudyPartialCallback) =>
                _checkAndSanitizeYearOfStudy.call @, studentData.yearOfStudy, (yearOfStudyError, validYearOfStudy) =>
                    yearOfStudyPartialCallback yearOfStudyError, validYearOfStudy
            modeOfStudy: (modeOfStudyPartialCallback) =>
                _checkAndSanitizeModeOfStudy.call @, studentData.modeOfStudy, (modeOfStudyError, validModeOfStudy) =>
                    partialCallback modeOfStudyError, validModeOfStudy
            programme: (programmePartialCallback) =>
                _checkAndSanitizeString.call @, studentData.programme, "Invalid Programme Code", (programmeError, validProgramme) =>
                    programmePartialCallback programmeError, validProgramme
            emailAddresses: (emailAddressPartialCallback) =>
                _checkAndSanitizeEmailAddresses.call @, [studentData.emailAddress1, studentData.emailAddress2], (emailError, validEmailAddresses) =>
                    emailAddressPartialCallback emailError, validEmailAddresses
        async.parallel checkOptions, (checkError, studentInfo) =>
            callback checkError, studentInfo

    # carry the queue manager along
    _authenticate = (authenticationData, facultyProxy, callback) ->
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
                                        if not verificationResult
                                            authenticationError = new Error "Authentication failed for student #{validStudentNumber}"
                                            callback authenticationError, null
                                        else
                                            facultyProxy.getName studentDoc.programme, (facultyNameError, facultyRes) =>
                                                if facultyNameError?
                                                    callback facultyNameError, null
                                                else
                                                    studentAuthRes =
                                                        name: studentDoc.firstName
                                                        surname: studentDoc.lastName
                                                        studentNumber: validStudentNumber
                                                        faculty: facultyRes.facultyName
                                                        programme: facultyRes.programmeName
                                                    callback null, studentAuthRes

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
                        DataManager.getDBManagerInstance(dbURL).insertStudent studentInfo, (saveError, saveResult) =>
                            callback saveError, saveResult

    _checkAuthorization = (username, mthName, technicalUserProxy, callback) ->
        technicalUserProxy.findTechnicalUserProfile username, (technicalUserProfileError, technicalUserProfile) =>
            if technicalUserProfileError?
                callback technicalUserProfileError, null
            else
                AuthorizationManager.getAuthorizationManagerInstance().checkAuthorization technicalUserProfile, mthName, (authorizationError, authorizationResult) =>
                    callback authorizationError, authorizationResult

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
                        DataManager.getDBManagerInstance(dbURL).findStudent validStudentNumber, (findError, findResult) =>
                            if findError?
                                callback findError, null
                            else
                                studentRes = {}
                                studentRes[entryKey] = entryValue for entryKey, entryValue of findResult when entryKey isnt 'password'
                                callback null, studentRes

    _findAll = (callback) ->
        ConfigurationManager.getConfigurationManager().getDBURL @appEnv, (urlError, dbURL) =>
            if urlError?
                callback urlError, null
            else
                DataManager.getDBManagerInstance(dbURL).findAllStudents (findAllError, allStudents) =>
                    if findAllError?
                        callback findAllError, null
                    else
                        filteredStudentCol = []
                        for curStudent in allStudents
                            do (curStudent) =>
                                studentCopy = {}
                                studentCopy[entryKey] = entryValue for entryKey, entryValue of curStudent when entryKey isnt 'password'
                                filteredStudentCol.push studentCopy
                        callback null, filteredStudentCol

    _findProgramme = (studentNumber, callback) ->
        _checkAndSanitizeStudentNumber.call @, studentNumber, (studentNumberError, validStudentNumber) =>
            if studentNumberError?
                callback studentNumberError, null
            else
                ConfigurationManager.getConfigurationManager().getDBURL @appEnv, (urlError, dbURL) =>
                    if urlError?
                        callback urlError, null
                    else
                        DataManager.getDBManagerInstance(dbURL).findStudent validStudentNumber, (findError, findResult) =>
                            if findError?
                                callback findError, null
                            else
                                callback null, findResult.programme

    constructor: (@appEnv) ->

    insertStudent: (studentData, callback) =>
        _insertStudent.call @, studentData, (saveError, saveResult) =>
            callback saveError, saveResult

    checkAuthorization: (username, mthName, technicalUserProxy, callback) =>
        _checkAuthorization.call @, username, mthName, technicalUserProxy, (authorizationError, authorizationResult) =>
            callback authorizationError, authorizationResult

    createPassword: (studentNumber, passwordData, callback) =>
        _createPassword.call @, studentNumber, passwordData, (createPasswordError, createPasswordResult) =>
            callback createPasswordError, createPasswordResult

    updateCourses: (studentNumber, courseData, callback) =>
        _updateCourses.call @, studentNumber, courseData, (courseUpdateError, courseUpdateResult) =>
            callback courseUpdateError, courseUpdateResult

    authenticate: (authenticationData, facultyProxy, callback) =>
        _authenticate.call @, authenticationData, facultyProxy, (authenticationError, authenticationResult) =>
            callback authenticationError, authenticationResult

    findOne: (studentNumber, callback) =>
        _findOne.call @, studentNumber, (findError, studentDetails) =>
            callback findError, studentDetails

    findAll: (callback) =>
        _findAll.call @, (findAllError, allStudents) =>
            callback findAllError, allStudents

    findProgramme: (studentNumber, callback) =>
        _findProgramme.call @, studentNumber, (programmeError, enrolledInProgramme) =>
            callback programmeError, enrolledInProgramme
