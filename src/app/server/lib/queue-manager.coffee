'use strict'

# this class manages a queue where requests are stored in case an
# instance of the expected controller is not available

exports.QueueManager = class QueueManager

    _qmInstance = undefined

    @getQueueManagerInstance: ->
        _qmInstance ?= new _LocalQueueManager()

    class _LocalQueueManager
        constructor: ->
            @workers = {}
