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
