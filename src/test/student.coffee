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
        StudentRequestHandler('test').createPassword{200513133},{password:" ",confirmPassword:" "},poolManager,queueManager,(createPasswordError, createPasswordResult)=>
            should.exist(createPasswordError)
            done()
        
   it 'should not create a passwords without a student number',(done)=>
        StudentRequestHandler('test').createPassword{0},{password:"Oweek",confirmPassword:"Oweek"},poolManager,queueManager,(createPasswordError, createPasswordResult)=>
            should.exist(createPasswordError)
            done()
    it 'should match the password and the confirm password fields',(done)=>
        StudentRequestHandler('test').createPassword{200513133},{password:"Oweek",confirmPassword:"orWeek"},poolManager,queueManager,(createPasswordError, createPasswordResult)=>
            should.exist(createPasswordError)
            done()
    it 'should correctly create the password with the right inputs',(done)=>
        StudentRequestHandler('test').createPassword{200513133},{password:"Oweek",confirmPassword:"OWeek"},poolManager,queueManager,(createPasswordError, createPasswordResult)=>
            should.exist(authenticationResult)
            done()      
            
            
