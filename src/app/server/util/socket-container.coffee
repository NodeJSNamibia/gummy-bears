'use strict'

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

        constructor: ->
            @socketMap = {}

        setSocket: (io) =>
            _setSocket.call @, io
