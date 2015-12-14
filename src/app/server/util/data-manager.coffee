'use strict'

async     = require 'async'
Couchbase = require 'couchbase'

exports.DataManager = class DataManager

    _getDefaultBucket = (callback) ->
        _getDataBucket.call @, 'default', (bucketError, bucket) =>
            callback bucketError, bucket

    _getDataBucket = (bucketName, callback) ->
        currentBucket = @allBuckets[bucketName]
        if not currentBucket?
            aBucket = new Couchbase.Cluster('couchbase://192.100.4.145').openBucket(bucketName)
            @allBuckets[bucketName] = aBucket
            currentBucket = aBucket
        callback null, currentBucket

    _saveStudent = (studentData, callback) ->
        _getDataBucket.call @, 'students', (studentBucketError, studentBucket) =>
            if studentBucketError?
                callback studentBucketError, null
            else
                studentBucket.insert studentData.studentNumber, studentData, (saveStudentError, saveStudentResult) =>
                    callback saveStudentError, saveStudentResult

    constructor: () ->
        @allBuckets = {}

    saveStudent: (studentData, callback) =>
        _saveStudent.call @, studentData, (saveError, saveResult) =>
            callback saveError, saveResult
