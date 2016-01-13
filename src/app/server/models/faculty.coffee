'use strict'

AuthorizationManager = require('../lib/authorization-manager').AuthorizationManager
ConfigurationManager = require('../lib/config-manager').ConfigurationManager
DataManager          = require('../lib/data-manager').DataManager
validator            = require('validator')
async                = require 'async'

exports.FacultyModel = class FacultyModel

    _checkAndSanitizeCode = (codeName, errorStr, callback) ->
        if validator.isNull(codeName) or not validator.isAlphanumeric(codeName)
            invalidCodenameError = new Error errorStr
            callback invalidCodenameError, null
        else
            callback null, validator.trim(codeName)

    _checkAndSanitizeCourseCode = (courseCode, callback) ->
        _checkAndSanitizeCode.call @, courseCode, "Invalid Course Code", (codeNameError, validCourseCode) =>
            callback codeNameError, validCourseCode

    _checkAndSanitizeCourseDescription = (courseDesc, callback) ->
        _checkAndSanitizeWords.call @, courseDesc, "Invalid Course Description Part", "Empty Course Description", (courseDescError, validCourseDesc) =>
            callback courseDescError, validCourseDesc

    _checkAndSanitizeCourses = (courses, callback) ->
        courseErrorStrs = []
        validCourses = []
        for singleCourse, singleCourseIdx in courses
            do (singleCourse, singleCourseIdx) =>
                _checkAndSanitizeSingleCourse.call @, singleCourse, (singleCourseError, validSingleCourse) =>
                    if singleCourseError
                        courseErrorStrs.push "Course Item #{singleCourseIdx + 1} Error: #{singleCourseError.message} "
                    else
                        validCourses.push validSingleCourse
        if courseErrorStrs.length > 0
            callback new Error(courseErrorStrs.join(', ')), null
        else
            callback null, validCourses

    _checkAndSanitizeCourseTitle = (courseTitle, callback) ->
        _checkAndSanitizeWords.call @, courseTitle, "Invalid Course Title Part", "Empty Course Title", (courseTitleError, validCourseTitle) =>
            callback courseTitleError, validCourseTitle

    _checkAndSanitizeContact = (contactDetails, entityName, callback) ->
        _checkAndSanitizeEmailAddress.call @, contactDetails.email, entityName, (emailError, validEmailAddress) =>
            if emailError?
                callback emailError, null
            else
                _checkAndSanitizeTelephoneNumber.call @, contactDetails.telephone, entityName, (telephoneError, validTelephoneNumber) =>
                    if telephoneError?
                        callback telephoneError, null
                    else
                        validContact =
                            email: validEmailAddress
                            telephone: validTelephoneNumber
                        callback null, validContact

    _checkAndSanitizeDepartments = (departments, callback) ->
        departmentErrorStrs = []
        validDepartments = []
        for singleDepartment, singleDepartmentIdx of departments
            do (singleDepartment, singleDepartmentIdx) =>
                _checkAndSanitizeSingleDepartment.call @, singleDepartment, (singleDepartmentError, validSingleDepartment) =>
                    if singleDepartmentError?
                        departmentErrorStrs.push "Department Item #{singleDepartmentIdx + 1} Error: #{singleDepartmentError.message}"
                    else
                        validDepartments.push validSingleDepartment
        if departmentErrorStrs.length > 0
            callback new Error(departmentErrorStrs.join(', ')), null
        else
            callback null, validDepartments

    _checkAndSanitizeDepartmentCode = (departmentCode, callback) ->
        _checkAndSanitizeCode.call @, departmentCode, "Invalid Department Code", (codeNameError, validDepartmentCode) =>
            callback codeNameError, validDepartmentCode

    _checkAndSanitizeEmailAddress = (emailAddress, entityName, callback) ->
        if validator.isNull(emailAddress) or not validator.isEmail(emailAddress)
            invalidEmailAddress = new Error "Invalid #{entityName} Email Address"
            callback invalidEmailAddress, null
        else
            callback null, validator.trimm(emailAddress)

    _checkAndSanitizeFacultyID = (facultyId, callback) ->
        if validator.isNull(facultyId) or not validator.isAlpha(facultyId)
            invalidFacultyIDError = new Error "Invalid Faculty Identifier"
            callback invalidFacultyIDError, null
        else
            callback null, validator.trim(facultyId)

    _checkAndSanitizeDepartmentName = (departmentName, callback) ->
        _checkAndSanitizeName.call @, departmentName, "Invalid Department Name Part", "Empty Department Name", (departmentNameError, validDepartmentName) =>
            callback departmentNameError, validDepartmentName

    _checkAndSanitizeFacultyName = (facultyName, callback) ->
        _checkAndSanitizeName.call @, facultyName, "Invalid Faculty Name Part", "Empty Faculty Name", (facultyNameError, validFacultyName) =>
            callback facultyNameError, validFacultyName

    _checkAndSanitizeForInsertion = (facultyData, callback) ->
        _checkAndSanitizeSingleFaculty.call @, facultyData, (facultyCheckError, validFaculty) =>
            callback facultyCheckError, validFaculty

    _checkAndSanitizeName = (name, namePartErrorStr, emptyNameStr, callback) ->
        _checkAndSanitizeWords.call @, name, namePartErrorStr, emptyNameStr, (nameError, validName) =>
            callback nameError, validName

    _checkAndSanitizeProgrammeCode = (programmeCode, callback) ->
        _checkAndSanitizeCode.call @, programmeCode, "Invalid Programme Code", (codeNameError, validProgrammeCode) =>
            callback codeNameError, validProgrammeCode

    _checkAndSanitizeProgrammeName = (programmeName, callback) ->
        _checkAndSanitizeName.call @, programmeName, "Invalid Programme Name Part", "Empty Programme Name", (programmeNameError, validProgrammeName) =>
            callback programmeNameError, validProgrammeName

    _checkAndSanitizeProgrammes = (programmes, callback) ->
        programmeErrorStrs = []
        validProgrammes = []
        for singleProgramme, singleProgrammeIdx in programmeErrorStrs
            do (singleProgramme, singleProgrammeIdx) =>
                _checkAndSanitizeSingleProgramme.call @, singleProgramme, (singleProgrammeError, validSingleProgramme) =>
                    if singleProgrammeError?
                        programmeErrorStrs.push "Programme Item #{singleProgrammeIdx + 1} Error: #{singleProgrammeError.message} "
                    else
                        validProgrammes.push validSingleProgramme
        if programmeErrorStrs.length > 0
            callback new Error(programmeErrorStrs.join(', ')), null
        else
            callback null, validProgrammes

    _checkAndSanitizeSemester = (semester, callback) ->
        if validator.isNull(semester) or not validator.isNumeric(semester) or not validator.isIn(semester, [1, 2, 3, 4, 5, 6, 7, 8])
            invalidSemesterError = new Error "Invalid Semester"
            callback invalidSemesterError, null
        else
            callback null, semester

    _checkAndSanitizeSingleCourse = (courseDetails, callback) ->
        singleCourseOptions =
            code: (codePartialCallback) =>
                _checkAndSanitizeCourseCode.call @, courseDetails.code, (courseCodeError, validCourseCode) =>
                    codePartialCallback courseCodeError, validCourseCode
            title: (titlePartialCallback) =>
                _checkAndSanitizeCourseTitle.call @, courseDetails.title, (courseTitleError, validCourseTitle) =>
                    titlePartialCallback courseTitleError, validCourseTitle
            description: (descPartialCallback) =>
                _checkAndSanitizeCourseDescription.call @, courseDetails.description, (courseDescError, validCourseDescription) =>
                    descPartialCallback courseCodeError, validCourseDescription
            semester: (semesterPartialCallback) =>
                _checkAndSanitizeSemester.call @, courseDetails.semester, (courseSemesterError, validCourseSemester) =>
                    semesterPartialCallback courseSemesterError, validCourseSemester
            contact: (contactPartialCallback) =>
                _checkAndSanitizeContact.call @, courseDetails.contact, "Course", (courseContactError, validCourseContact) =>
                    contactPartialCallback courseContactError, validCourseContact
        async.parallel singleCourseOptions, (courseCheckError, validCourse) =>
            callback courseCheckError, validCourse

    _checkAndSanitizeSingleDepartment = (departmentDetails, callback) ->
        singleDepartmentOptions =
            code: (codePartialCallback) =>
                _checkAndSanitizeDepartmentCode.call @, departmentDetails.code, (departmentCodeError, validDepartmentCode) =>
                    codePartialCallback departmentCodeError, validDepartmentCode
            name: (namePartialCallback) =>
                _checkAndSanitizeDepartmentName.call @, departmentDetails.name, (departmentNameError, validDepartmentName) =>
                    namePartialCallback departmentNameError, validDepartmentName
            contact: (contactPartialCallback) =>
                _checkAndSanitizeContact.call @, departmentDetails.contact, "Department", (departmentContactError, validDepartmentContact) =>
                    contactPartialCallback departmentContactError, validDepartmentContact
            programmes: (programmesPartialCallback) =>
                _checkAndSanitizeProgrammes.call @, departmentDetails.programmes, (departmentProgrammesError, validDepartmentProgrammes) =>
                    programmesPartialCallback departmentProgrammesError, validDepartmentProgrammes
        async.parallel singleDepartmentOptions, (departmentCheckError, validDepartment) =>
            callback departmentCheckError, validDepartment

    _checkAndSanitizeSingleFaculty = (facultyDetails, callback) ->
        singleFacultyOptions =
            name: (namePartialCallback) =>
                _checkAndSanitizeFacultyName.call @, facultyDetails.name, (facultyNameError, validFacultyName) =>
                    namePartialCallback facultyNameError, validFacultyName
            contact: (contactPartialCallback) =>
                _checkAndSanitizeContact.call @, facultyDetails.contact, "Faculty", (facultyContactError, validFacultyContact) =>
                    contactPartialCallback facultyContactError, validFacultyContact
            departments: (departmentPartialCallback) =>
                _checkAndSanitizeDepartments.call @, facultyDetails.departments, (facultyDepartmentsError, validFacultyDepartments) =>
                    departmentPartialCallback facultyDepartmentsError, validFacultyDepartments
        async.parallel singleFacultyOptions, (facultyCheckError, validFaculty) =>
            callback facultyCheckError, validFaculty

    _checkAndSanitizeSingleProgramme = (programmeDetails, callback) ->
        singleProgrammeOptions =
            code: (codePartialCallback) =>
                _checkAndSanitizeProgrammeCode.call @, programmeDetails.code, (programmeCodeError, validProgrammeCode) =>
                    codePartialCallback programmeCodeError, validProgrammeCode
            name: (namePartialCallback) =>
                _checkAndSanitizeProgrammeName.call @, programmeDetails.name, (programmeNameError, validProgrammeName) =>
                    namePartialCallback programmeNameError, validProgrammeName
            courses: (coursesPartialCallback) =>
                _checkAndSanitizeCourses.call @, programmeDetails.courses, (programmeCoursesError, validProgrammeCourses) =>
                    coursesPartialCallback programmeCoursesError, validProgrammeCourses
        async.parallel singleProgrammeOptions, (programmeCheckError, validProgramme) =>
            callback programmeCheckError, validProgramme

    _checkAndSanitizeTelephoneNumber = (telephoneNumber, entityName, callback) ->
        namTelRegex = /^(\+?264|0)(61207)\d{4}$/
        if validator.isNull(telephoneNumber) or not namTelRegex.test(telephoneNumber)
            invalidTelephoneNumberError = new Error "Invalid #{entityName} Telephone Number"
            callback invalidTelephoneNumberError, null
        else
            callback null, validator.trim(telephoneNumber)

    _checkAndSanitizeWords = (words, wordPartErrorStr, emptyWordErrorStr, callback) ->
        wordComponentError = undefined
        wordComponents = words.split " "
        validWordComponents = []
        for wordComponentItem in wordComponents
            do (wordComponentItem) =>
                if validator.isNull(wordComponentItem) or not validator.isAlpha(wordComponentItem)
                    if not wordComponentError?
                        wordComponentError = new Error wordPartErrorStr
                else
                    validWordComponents.push validator.trim(wordComponentItem)
        if wordComponentError?
            callback wordComponentError, null
        else if validWordComponents.length > 0
            callback null, validWordComponents.join(' ')
        else
            emptyWordError = new Error emptyWordErrorStr
            callback emptyWordError, null

    _checkAuthorization = (username, mthName, callback) ->
        _checkAndSanitizeUsername.call @, username, (checkError, validUsername) =>
            if checkError?
                callback checkError, null
            else
                DataManager.getDBManagerInstance(dbURL).findTechnicalUser validUsername, (findTechnicalUserError, technicalUserDoc) =>
                    if findTechnicalUserError?
                        callback findTechnicalUserError, null
                    else
                        AuthorizationManager.getAuthorizationManagerInstance().checkAuthorization technicalUserDoc.profile, mthName, (authorizationError, authorizationResult) =>
                            callback authorizationError, authorizationResult

    _findAll = (callback) ->
        ConfigurationManager.getConfigurationManager().getDBURL @appEnv, (urlError, dbURL) =>
            if urlError?
                callback urlError, null
            else
                DataManager.getDBManagerInstance(dbURL).findAllFaculties (findAllError, allFaculties) =>
                    callback findAllError, allFaculties

    _findOne = (facultyId, callback) ->
        _checkAndSanitizeFacultyID.call @, facultyId, (facultyIdError, validFacultyID) =>
            if facultyIdError?
                callback facultyIdError, null
            else
                ConfigurationManager.getConfigurationManager().getDBURL @appEnv, (urlError, dbURL) =>
                    if urlError?
                        callback urlError, null
                    else
                        DataManager.getDBManagerInstance(dbURL).findFaculty validFacultyID, (findError, findResult) =>
                            callback findError, findResult

    _insertFaculty = (facultyId, facultyData, callback) ->
        _checkAndSanitizeFacultyID.call @, facultyId, (facultyIdError, validFacultyID) =>
            if facultyIdError?
                callback facultyIdError, null
            else
                _checkAndSanitizeForInsertion.call @, facultyData, (facultyDataError, validFacultyData) =>
                    if facultyDataError?
                        callback facultyDataError, null
                    else
                        ConfigurationManager.getConfigurationManager().getDBURL @appEnv, (urlError, dbURL) =>
                            if urlError?
                                callback urlError, null
                            else
                                dataManager = DataManager.getDBManagerInstance dbURL
                                dataManager.insertFaculty validFacultyID, validFacultyData, (saveError, saveResult) =>
                                    callback saveError, saveResult

    constructor: (@appEnv) ->

    checkAuthorization: (username, mthName, callback) =>
        _checkAuthorization.call @, username, mthName, (authorizationError, authorizationResult) =>
            callback authorizationError, authorizationResult

    insertFaculty: (facultyId, facultyData, callback) =>
        _insertFaculty.call @, facultyId, facultyData, (insertError, insertResult) =>
            callback insertError, insertResult

    findAll: (callback) =>
        _findAll.call @, (findAllError, allStudents) =>
            callback findAllError, allStudents

    findOne: (facultyId, callback) =>
        _findOne.call @, facultyId, (findOneError, facultyDetails) =>
            callback findOneError, facultyDetails
