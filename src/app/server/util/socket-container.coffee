'use strict'

FacultyProxy = require('../proxies/faculty').FacultyProxy
StudentProxy = require('../proxies/student').StudentProxy

exports.SocketContainer = class SocketContainer
    _socketContainerInstance = undefined

    @getSocketContainer: ->
        _socketContainerInstance ?= new _LocalSocketContainer

    class _LocalSocketContainer
        _setSocket = (io) ->
            if io?
                io.sockets.on 'connection', (studentSocket) =>
                    socket.emit 'handshake', {value: 'hi'}
                    socket.on 'handshake', (studentData) =>
                        studentNumber = studentData.studentNumber
                        if studentNumber?
                            @socketMap[studentNumber] = studentSocket

        _sendNotification = (target, notificationContent, appEnv, callback) ->
            if target is 'all'
                for studentNumber, studentSocket of @socketMap
                    do (studentNumber, studentSocket) =>
                        studentSocket.emit 'quickNotification', {content: notificationContent}
                callback null, null
            else
                new FacultyProxy(appEnv).getProgrammeList target, (programmeListError, programmeList) =>
                    if programmeListError?
                        callback programmeListError, null
                    else
                        
                facID = target
                callback null, null

        constructor: ->
            @socketMap = {}

        setSocket: (io) =>
            _setSocket.call @, io

        sendNotification: (target, notificationContent, appEnv, callback) =>
            _sendNotification.call @, target, notificationContent, appEnv, (sendNotificationError, sendNotificationResult) =>
                callback sendNotificationError, sendNotificationResult
