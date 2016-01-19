'use strict'

AuthorizationManager       = require('../lib/authorization-manager').AuthorizationManager
ConfigurationManager       = require('../lib/config-manager').ConfigurationManager
CheckAndSanitizationHelper = require('../util/sanitization-helper').CheckAndSanitizationHelper
DataManager                = require('../lib/data-manager').DataManager
PasswordHandler            = require('../util/password-handler').PasswordHandler
validator                  = require('validator')
async                      = require 'async'

exports.StudentModel = class StudentModel

    _checkAndSanitizeStudentNumber = (studentNumber, callback) ->
        @sanitizationHelper.checkAndSanitizeNumber studentNumber, "Invalid Student Number", validator, (studentNumberError, validStudentNumber) =>
            callback studentNumberError, validStudentNumber

    _checkAndSanitizeTitle = (titleValue, callback) ->
        @sanitizationHelper.checkAndSanitizeTitle titleValue, "Invalid Student Title", ["Mr", "Mrs", "Ms"], validator, (titleValueError, validTitleValue) =>
            callback titleValueError, validTitleValue

    _checkAndSanitizeYearOfStudy = (yearOfStudy, callback) ->
        @sanitizationHelper.checkAndSanitizeTitle yearOfStudy, "Invalid Year of Study", ["first", "second", "third", "honours"], validator, (yearOfStudyError, validYearOfStudy) =>
            callback yearOfStudyError, validYearOfStudy

    _checkAndSanitizeModeOfStudy = (modeOfStudy, callback) ->
        @sanitizationHelper.checkAndSanitizeTitle modeOfStudy, "Invalid Mode of Study", ["PM","FM"], validator, (modeOfStudyError, validModeOfStudy) =>
            callback modeOfStudyError, validModeOfStudy

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
                @sanitizationHelper.checkAndSanitizePersonName studentData.firstName, "Invalid Student First Name", validator, (firstNameError, validFirstName) =>
                    firstNamePartialCallback firstNameError, validFirstName
            lastName: (lastNamePartialCallback) =>
                @sanitizationHelper.checkAndSanitizePersonName studentData.lastName, "Invalid Student Last Name", validator, (lastNameError, validLastName) =>
                    lastNamePartialCallback lastNameError, validLastName
            title: (titlePartialCallback) =>
                _checkAndSanitizeTitle.call @, studentData.title, (studentTitleError, validStudentTitle) =>
                    titlePartialCallback studentTitleError, validStudentTitle
            nationality: (nationalityPartialCallback) =>
                @sanitizationHelper.checkAndSanitizeString studentData.nationality, "Invalid Nationality", validator, (nationalityError, validNationality) =>
                    nationalityPartialCallback nationalityError, validNationality
            yearOfStudy: (yearOfStudyPartialCallback) =>
                _checkAndSanitizeYearOfStudy.call @, studentData.yearOfStudy, (yearOfStudyError, validYearOfStudy) =>
                    yearOfStudyPartialCallback yearOfStudyError, validYearOfStudy
            modeOfStudy: (modeOfStudyPartialCallback) =>
                _checkAndSanitizeModeOfStudy.call @, studentData.modeOfStudy, (modeOfStudyError, validModeOfStudy) =>
                    partialCallback modeOfStudyError, validModeOfStudy
            programme: (programmePartialCallback) =>
                @sanitizationHelper.checkAndSanitizeCode studentData.programme, "Invalid Programme Code", validator, (programmeError, validProgramme) =>
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
        @sanitizationHelper = new CheckAndSanitizationHelper()

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
