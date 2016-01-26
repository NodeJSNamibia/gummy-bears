'use strict'

async                   = require 'async'
AbstractController      = require('./abstract-controller').AbstractController
AcademicStructureLoader = require('../util/academic-structure-loader').AcademicStructureLoader
TechnicalUserProxy      = require('../proxies/technical-user').TechnicalUserProxy
FacultyModel            = require('../models/faculty').FacultyModel

exports.FacultiesController = class FacultiesController extends AbstractController

    _extractAcademicStructure = (rawStructure, callback) ->
        facultyObj = {}
        for curItem in rawStructure
            do (curItem) =>
                facId = curItem["Faculty Id"]
                currentFacObject = facultyObj[facId]
                if not currentFacObject?
                    _extractFaculty.call @, curItem, (facultyExtrationError, facultyExtractionResult) =>
                        if not facultyExtrationError?
                            facultyObj[facId] = facultyExtractionResult
                else
                    myDepartment = facultyObj[facId].departments[curItem["Department Code"]]
                    if myDepartment?
                        myProgramme = myDepartment.programmes[curItem["Programme Code"]]
                        if myProgramme?
                            myCourse = myProgramme.courses[curItem["Course Code"]]
                            if not myCourse?
                                _extractCourse.call @, curItem, (courseExtractionError, courseExtractionResult) =>
                                    if not courseExtractionError?
                                        myProgramme.courses[curItem["Course Code"]] = courseExtractionResult
                        else
                            _extractProgramme.call @, curItem, (programmeExtractionError, programmeExtractionResult) =>
                                if not programmeExtractionError?
                                    myDepartment.programmes[curItem["Programme Code"]] = programmeExtractionResult
                    else
                        _extractDepartment.call @, curItem, (departmentExtractionError, departmentExtractionResult) =>
                            if not departmentExtractionError?
                                facultyObj[facId].departments[curItem["Department Code"]] = departmentExtractionResult
        callback null, facultyObj

    _extractCourse = (courseDesc, callback) ->
        currentCourse =
            code: courseDesc["Course Code"]
            title: courseDesc["Course Title"]
            description: courseDesc["Course Description"]
            semester: courseDesc["Course Semester"]
            contact:
                email: courseDesc["Course Email Contact"]
                telephone: courseDesc["Course Telephone Contact"]
            timetable: []
        callback null, currentCourse

    _extractDepartment = (departmentDesc, callback) ->
        curDepartment =
            code: departmentDesc["Department Code"]
            name: departmentDesc["Department Name"]
            contact:
                email: departmentDesc["Department Email"]
                telephone: departmentDesc["Department Telephone"]
            programmes: {}
        _extractProgramme.call @, departmentDesc, (extractError, extractResult) =>
            if extractError?
                callback extractError, null
		    else
                curDepartment.programmes[departmentDesc["Programme Code"]] = extractResult
			    callback null, curDepartment

    _extractFaculty = (facultyDesc, callback) ->
        curFaculty =
            name: facultyDesc["Faculty Name"]
            contact:
                email: facultyDesc["Faculty Email"]
                telephone: facultyDesc["Faculty Telephone"]
            departments: {}
        _extractDepartment.call @, facultyDesc, (extractError, extractResult) =>
            if extractError?
                callback extractError, null
            else
                curFaculty.departments[facultyDesc["Department Code"]] = extractResult
                callback null, curFaculty

    _extractProgramme = (programmeDesc, callback) ->
        curProgramme =
            code: programmeDesc["Programme Code"]
            name: programmeDesc["Programme Name"]
            courses: {}
        _extractCourse.call @, programmeDesc, (extractError, extractResult) =>
            if extractError?
                callback extractError, null
            else
                curProgramme.courses[programmeDesc["Course Code"]] = extractResult
                callback null, curProgramme

    _getAllFaculties = (poolManager, queueManager, callback) ->
        @faculty.findAll (findError, allFaculties) =>
            @release 'faculties', poolManager, queueManager, (releaseError, releaseResult) =>
                if releaseError?
                    callback releaseError, null
                else
                    callback findError, allFaculties

    _getFaculty = (facultyId, poolManager, queueManager, callback) ->
        @faculty.findOne facultyId, (findError, facultyDetails) =>
            @release 'faculties', poolManager, queueManager, (releaseError, releaseResult) =>
                if releaseError?
                    callback releaseError, null
                else
                    callback findError, facultyDetails

    _handleSingleFaculty = (facultyId, facultyDesc, callback) ->
        @faculty.insertFaculty facultyId, facultyDesc, (insertError, insertResult) =>
            callback insertError, insertResult

    _insertAcademicStructure = (poolManager, queueManager, callback) ->
        @faculty.checkAuthorization username, 'insertAcademicStructure', @technicalUserProxy, (authorizationError, authorizationResult) =>
            if authorizationError?
                @release 'faculties', poolManager, queueManager, (releaseError1, releaseResult1) =>
                    if releaseError1?
                        callback releaseError1, null
                    else
                        callback authorizationError, null
            else if not authorizationResult
                unauthorizedInsertionError = new Error "Authorization Error! User #{username} is not authorized to insert academic structure."
                @release 'faculties', poolManager, queueManager, (releaseError1, releaseResult1) =>
                    if releaseError1?
                        callback releaseError1, null
                    else
                        callback unauthorizedInsertionError, null
            else
                AcademicStructureLoader.getInfoLoader().loadStructure (loadError, academicStructure) =>
                    if loadError?
                        @release 'faculties', poolManager, queueManager, (releaseError, releaseResult) =>
                            if releaseError?
                                callback releaseError, null
                            else
                                callback loadError, null
                    else
                        _extractAcademicStructure.call @, academicStructure, (extractionError, extractionResult) =>
                            if extractionError?
                                @release 'faculties', poolManager, queueManager, (releaseError1, releaseResult1) =>
                                    if releaseError1?
                                        callback releaseError1, null
                                    else
                                        callback extractionError, null
                            else
                                facultyHandlingFuncs = {}
                                for facultyId, facultyDesc of extractionResult
                                    do (facultyId, facultyDesc) =>
                                        curFacultyHandlingFunc = (partialCallback) =>
                                            _handleSingleFaculty.call @, facultyId, facultyDesc, (handleError, handleResult) =>
                                                partialCallback handleError, handleResult
                                        facultyHandlingFuncs[facultyId] = curFacultyHandlingFunc
                                async.series facultyHandlingFuncs, (handleSeriesError, handleSeriesResult) =>
                                    if handleSeriesError?
                                        @release 'faculties', poolManager, queueManager, (releaseError2, releaseResult2) =>
                                            if releaseError2?
                                                callback releaseError2, null
                                            else
                                                callback handleSeriesError, null
                                    else
                                        @release 'faculties', poolManager, queueManager, (releaseError3, releaseResult3) =>
                                            if releaseError3?
                                                callback releaseError3, null
                                            else
                                                callback null, handleSeriesResult

    constructor: (envVal) ->
        @faculty = new FacultyModel envVal
        @technicalUserProxy = new TechnicalUserProxy envVal

    insertAcademicStructure: (poolManager, queueManager, callback) =>
        _insertAcademicStructure.call @, poolManager, queueManager, (insertAllError, insertAllResult) =>
            callback insertAllError, insertAllResult

    getAllFaculties: (poolManager, queueManager, callback) =>
        _getAllFaculties.call @, poolManager, queueManager, (allFacultiesError, allFaculties) =>
            callback allFacultiesError, allFaculties

    getFaculty: (facultyId, poolManager, queueManager, callback) =>
        _getFaculty.call @, facultyId, poolManager, queueManager, (facultyError, facultyDetails) =>
            callback facultyError, facultyDetails
