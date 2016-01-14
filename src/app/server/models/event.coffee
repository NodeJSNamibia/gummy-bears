'use strict'

AuthorizationManager = require('../lib/authorization-manager').AuthorizationManager
ConfigurationManager = require('../lib/config-manager').ConfigurationManager
DataManager          = require('../lib/data-manager').DataManager
validator            = require('validator')
async                = require 'async'

exports.EventModel = class EventModel

    constructor: (@appEnv) ->
