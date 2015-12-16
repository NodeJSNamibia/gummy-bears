'use strict'

async     = require 'async'
Couchbase = require 'couchbase'

exports.DataManager = class DataManager

    _dbManagerInstance = undefined

    @getDBManagerInstance = (dbURL) ->
        _dbManagerInstance ?= new _LocalDBManager

        class _LocalDBManager

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

            _insertDocument = (bucketName, docuID, docuData, callback) ->
                _getDataBucket.call @, bucketName, (bucketError, bucket) =>
                    if bucketError?
                        callback bucketError, null
                    else
                        bucket.insert docuID, docuData, (insertError, insertResult) =>
                            callback insertError, insertResult

            constructor: (@dbURL) ->
                @allBuckets = {}

            insertStudent: (studentData, callback) =>
                _insertDocument.call @, 'students', studentData.studentNumber, studentData, (insertStudentError, insertStudentResult) =>
                    callback insertStudentError, insertStudentResult
