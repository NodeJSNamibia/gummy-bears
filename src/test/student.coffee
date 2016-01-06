'use strict'

StudentRequestHandler = require('../app/server/route-handlers/students').StudentRequestHandler

should = require 'should'

describe 'Students Controller', ->
    it 'should correctly authenticate a user with the right credentials', (done) =>
        new StudentsController('test').authenticate {studentNumber: 0323233243, password: "scary"}, (authenticationError, authenticationResult) =>
            should.not.exist(authenticationError)
            # more comparisons
            done()
