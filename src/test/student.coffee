'use strict'

StudentRequestHandler = require('../app/server/route-handlers/students').StudentRequestHandler

should = require 'should'

describe 'Students Controller', ->
    it 'should correctly authenticate a user with the right credentials', (done) =>
        new StudentsController('test').authenticate {studentNumber: 0323233243, password: "scary"}, (authenticationError, authenticationResult) =>
            should.not.exist(authenticationError)
            # more comparisons
            done()
    it 'should not create blank passwords',(done)=>
        StudentRequestHandler('test').createPassword{200513133,{password:" ",confirmPassword:" "},poolManager,queueManager,(createPasswordError, createPasswordResult)=>
            should.exist(createPasswordError)
            done()
        
