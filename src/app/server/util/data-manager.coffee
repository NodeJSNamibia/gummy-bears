'use strict'

async     = require 'async'
Couchbase = require 'couchbase'

exports.DataManager = class DataManager

    _dbManagerInstance = undefined

    @getDBManagerInstance = (dbURL) ->
        _dbManagerInstance ?= new _LocalDBManager

        class _LocalDBManager

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
                    urlString = "couchbase://{@dbURL}"
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

            insertStudent: (studentData, callback) =>
                _insertDocument.call @, 'students', studentData.studentNumber, studentData, (insertStudentError, insertStudentResult) =>
                    callback insertStudentError, insertStudentResult

            updateStudent: (studentNumber, studentData, callback) =>
                _updateDocument.call @, 'students', studentNumber, studentData, (updateStudentError, updateStudentResult) =>
                    callback updateStudentError, updateStudentResult

            findStudent: (studentNumber, callback) =>
                _findDocument.call @, 'students', studentNumber, (findStudentError, studentDoc) =>
                    callback findStudentError, studentDoc
