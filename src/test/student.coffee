'use strict'

PoolManager           = require('../app/server/lib/pool-manager').PoolManager
QueueManager          = require('../app/server/lib/queue-manager').QueueManager
StudentRequestHandler = require('../app/server/route-handlers/students').StudentRequestHandler

should = require 'should'

describe 'Students Controller', ->
    before (done) =>
        poolManager = PoolManager.getPoolManagerInstance evtEmitter
        queueManager = QueueManager.getQueueManagerInstance evtEmitter
        poolManager.setExecutionEnvironment 'test'
        studentRequestHandler = StudentRequestHandler.getRequestHandler()
        done()

    describe 'student password creation',  ->
        it 'should not create empty passwords', (done) =>
            request =
                params:
                    id: 200530303
                body:
                    password: ""
                    confirmPassword: ""
            response =
                statusCode: ""
                body: {}
                json: (options) ->
                    args = [].slice.call arguments
                    if args.length > 1
                        if typeof args[0] is 'number'
                            @statusCode = args[0]
                        @body = args[1]
                    else
                        @statusCode = 200
                        @body = args[0]
            studentRequestHandler.createPassword queueManager, poolManager, request, response, (createPasswordError, createPasswordResult) =>
                response.should.have.statusCode(500);
            response.body.should.be.(passwordCreationError)
                done()
         it 'should not create password  with empty student number', (done) =>
            request =
                params:
                    id: 
                body:
                    password: "myPassword"
                    confirmPassword: "myPassword"
            response =
                statusCode: ""
                body: {}
                json: (options) ->
                    args = [].slice.call arguments
                    if args.length > 1
                        if typeof args[0] is 'number'
                            @statusCode = args[0]
                        @body = args[1]
                    else
                        @statusCode = 200
                        @body = args[0]
            studentRequestHandler.createPassword queueManager, poolManager, request, response =>
            response.should.have.statusCode(500);
            response.body.should.be.(studentNumberError)
                done()
             it 'should not create password without matching the password and confirmPassword', (done) =>
            request =
                params:
                    id: 200530303
                body:
                    password: "myPassword"
                    confirmPassword: "Mypassword"
            response =
                statusCode: ""
                body: {}
                json: (options) ->
                    args = [].slice.call arguments
                    if args.length > 1
                        if typeof args[0] is 'number'
                            @statusCode = args[0]
                        @body = args[1]
                    else
                        @statusCode = 200
                        @body = args[0]
            studentRequestHandler.createPassword queueManager, poolManager, request, response, (createPasswordError, createPasswordResult) =>
                response.should.have.statusCode(500);
            response.body.should.be.(unconfirmedPasswordError)
                done()
              it 'should correctly create the password', (done) =>
            request =
                params:
                    id: 200530303
                body:
                    password: "myPassword"
                    confirmPassword: "myPassword"
            response =
                statusCode: ""
                body: {}
                json: (options) ->
                    args = [].slice.call arguments
                    if args.length > 1
                        if typeof args[0] is 'number'
                            @statusCode = args[0]
                        @body = args[1]
                    else
                        @statusCode = 200
                        @body = args[0]
            studentRequestHandler.createPassword queueManager, poolManager, request, response, (createPasswordError, createPasswordResult) =>
                
            response.should.have.statusCode(200);
            response.body.should.be.(passwordCreationResult)
                done()
                          


