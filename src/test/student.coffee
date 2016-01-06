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
            studentRequestHandler.createPassword queueManager, poolManager, {}, {}, (createPasswordError, createPasswordResult) =>
                should.exist createPasswordError
                done()
        
    #     it 'should not create blank passwords', (done) =>
    #         StudentRequestHandler('test').createPassword{200513133},{password:" ",confirmPassword:" "},poolManager,queueManager,(createPasswordError, createPasswordResult)=>
    #             should.exist(createPasswordError)
    #             done()
       #
    #    it 'should not create a passwords without a student number',(done)=>
    #         StudentRequestHandler('test').createPassword{0},{password:"Oweek",confirmPassword:"Oweek"},poolManager,queueManager,(createPasswordError, createPasswordResult)=>
    #             should.exist(createPasswordError)
    #             done()
    #     it 'should match the password and the confirm password fields',(done)=>
    #         StudentRequestHandler('test').createPassword{200513133},{password:"Oweek",confirmPassword:"orWeek"},poolManager,queueManager,(createPasswordError, createPasswordResult)=>
    #             should.exist(createPasswordError)
    #             done()
    #     it 'should correctly create the password with the right inputs',(done)=>
    #         StudentRequestHandler('test').createPassword{200513133},{password:"Oweek",confirmPassword:"Oweek"},poolManager,queueManager,(createPasswordError, createPasswordResult)=>
    #             should.exist(authenticationResult)
    #             done()
