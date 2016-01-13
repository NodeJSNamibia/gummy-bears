'use strict'

async     = require 'async'
Couchbase = require 'couchbase'

exports.DataManager = class DataManager

    _dbManagerInstance = undefined

    @getDBManagerInstance: (dbURL) ->
        _dbManagerInstance ?= new _LocalDBManager

    class _LocalDBManager

        _findAllStudents = (callback) ->
            _getDataBucket.call @, 'student', (bucketError, bucket) =>
                if bucketError?
                    callback bucketError, null
                else
                    ViewQuery = Couchbase.ViewQuery
                    allStudentsQuery = ViewQuery.from @studentDesignDoc, @studentView
                    bucket.query allStudentsQuery, (multiStudentError, studentCol) =>
                        if multiStudentError?
                            callback multiStudentError, null
                        else
                            allStudents = (curStudent.value for curStudent in studentCol)
                            callback null, allStudents

        _findAllFaculties = (callback) ->
            _getDataBucket.call @, 'faculty', (bucketError, bucket) =>
                if bucketError?
                    callback bucketError, null
                else
                    ViewQuery = Couchbase.ViewQuery
                    allFacultiesQuery = ViewQuery.from @facultyDesignDoc, @facultyView
                    bucket.query allFacultiesQuery, (multiFacultyError, facultyCol) =>
                        if multiFacultyError?
                            callback multiFacultyError, null
                        else
                            allFaculties = (curFaculty.value for curFaculty in facultyCol)
                            callback null, allFaculties

        _findDocument = (bucketName, docID, callback) ->
            _getDataBucket.call @, bucketName, (bucketError, bucket) =>
                if bucketError?
                    callback bucketError, null
                else
                    bucket.get docID, (docError, docData) =>
                        callback docError, docData

        _findAllFacultyByProgrammeCode = (programmeCode, callback) ->
            _findAllFaculties.call @, (allFacultiesError, allFaculties) =>
                if allFacultiesError?
                    callback allFacultiesError, null
                else
                    result = undefined
                    for curFaculty in allFaculties
                        curDepartments = curFaculty.departments
                        for curDepartment in curStudent
                            curProgrammes = curDepartment.programmes
                            for curProgramme in curProgrammes
                                if curProgramme is programmeCode
                                    result =
                                        facultyName: curFaculty.name
                                        programmeName: curProgramme.name
                                    breakDeptLoop = true
                                    break
                            if breakDeptLoop
                                breakFacLoop = true
                                break
                        if breakFacLoop = true
                            break
                    if not result?
                        unknownProgrammeError = new Error "Programme #{programmeCode} does not belong to an existing faculty"
                        callback unknownProgrammeError, null
                    else
                        callback null, result

        _getDataBucket = (bucketName, callback) ->
            currentBucket = @allBuckets[bucketName]
            if not currentBucket?
                urlString = "couchbase://" + "#{@dbURL}"
                aBucket = new CouchBase.Cluster(urlString).openBucket(bucketName)
                @allBuckets[bucketName] = aBucket
                currentBucket = aBucket
            callback null, currentBucket

        _getDefaultBucket = (callback) ->
            _getDataBucket.call @, 'default', (defaultBucketError, defaultBucket) =>
                callback defaultBucketError, defaultBucket

        _insertDocument = (bucketName, docID, docuData, callback) ->
            _getDataBucket.call @, bucketName, (bucketError, bucket) =>
                if bucketError?
                    callback bucketError, null
                else
                    bucket.insert docID, docuData, (insertError, insertResult) =>
                        callback insertError, insertResult

        _updateDocument = (bucketName, docID, newData, callback) ->
            _getDataBucket.call @, bucketName, (bucketError, bucket) =>
                if bucketError?
                    callback bucketError, null
                else
                    bucket.get docID, (docError, docData) =>
                        if docError?
                            callback docError, null
                        else
                            docData[entryKey] = entryValue for entryKey, entryValue of newData
                            bucket.upsert docID, docData, (updateError, updateResult) =>
                                callback updateError, updateResult

        constructor: (@dbURL) ->
            @allBuckets = {}
            @studentDesignDoc = 'students_dd'
            @studentView = 'students'

        findStudent: (studentNumber, callback) =>
            _findDocument.call @, 'student', studentNumber, (findStudentError, studentDoc) =>
                callback findStudentError, studentDoc

        findAllStudents: (callback) =>
            _findAllStudents.call @, (findAllError, allStudents) =>
                callback findAllError, allStudents

        findAllFaculties: (callback) =>
            _findAllFaculties.call @, (findAllError, allFaculties) =>
                callback findAllError, allFaculties

        findFacultyByProgrammeCode: (programmeCode, callback) =>
            _findAllFacultyByProgrammeCode.call @, programmeCode, (facultyNameError, faculty) =>
                callback facultyNameError, faculty

        insertFaculty: (facultyId, facultyData, callback) =>
            _insertDocument.call @, 'faculty', facultyId, facultyData, (insertFacultyError, insertFacultyResult) =>
                callback insertFacultyError, insertFacultyResult

        insertLoginRecord: (recordID, studentLR, callback) =>
            _insertDocument.call @, 'login-record', recordID, studentLR, (insertLoginRecordError, insertLoginRecordResult) =>
                callback insertLoginRecordError, insertLoginRecordResult

        insertStudent: (studentData, callback) =>
            _insertDocument.call @, 'student', studentData.studentNumber, studentData, (insertStudentError, insertStudentResult) =>
                callback insertStudentError, insertStudentResult

        updateStudent: (studentNumber, studentData, callback) =>
            _updateDocument.call @, 'student', studentNumber, studentData, (updateStudentError, updateStudentResult) =>
                    callback updateStudentError, updateStudentResult