'use strict'

exports.FAQRequestHandler = class FAQRequestHandler
    _faqrhInstance = undefined

    @getRequestHandler: ->
        _faqrhInstance ?= new _LocalFAQRequestHandler

    class _LocalFAQRequestHandler
        _insertAllFAQs = (queueManager, poolManager, request, response) ->
            poolManager.acquire 'faqs', (controllerInstanceError, controllerInstance) =>
                if controllerInstanceError?
                    response.json 500, {error: controllerInstanceError.message}
                else if not controllerInstance?
                    insertAllFAQRequestObject =
                        methodName: 'insertAllFAQs'
                        arguments: [queueManager, poolManager, request, response]
                    queueManager.enqueueRequest 'faqs', insertAllFAQRequestObject
                else
                    controllerInstance.insertAllFAQs request.session?.user?.username, poolManager, queueManager, (FAQCreationError, FAQCreationResult) =>
                        if FAQCreationError?
                            response.json 500, {error: FAQCreationError.message}
                        else
                            response.json 201, FAQCreationResult

        _insertFAQ = (queueManager, poolManager, request, response) ->
            poolManager.acquire 'faqs', (controllerInstanceError, controllerInstance) =>
                if controllerInstanceError?
                    response.json 500, {error: controllerInstanceError.message}
                else if not controllerInstance?
                    insertFAQRequestObject =
                        methodName: 'insertFAQ'
                        arguments: [queueManager, poolManager, request, response]
                    queueManager.enqueueRequest 'faqs', insertFAQRequestObject
                else
                    controllerInstance.insertFAQ request.session?.user?.username, poolManager, queueManager, (FAQCreationError, FAQCreationResult) =>
                        if FAQCreationError?
                            response.json 500, {error: FAQCreationError.message}
                        else
                            response.json 201, FAQCreationResult

        _getAllFAQs = (queueManager, poolManager, request, response) ->
            poolManager.acquire 'faqs', (controllerInstanceError, controllerInstance) =>
                if controllerInstanceError?
                    response.json 500, {error: controllerInstanceError.message}
                else if not controllerInstance?
                    getAllFAQsRequestObject =
                        methodName: 'getAllFAQs'
                        arguments: [queueManager, poolManager, request, response]
                    queueManager.enqueueRequest 'faqs', getAllFAQsRequestObject
                else
                    controllerInstance.getAllFAQ poolManager, queueManager, (getAllFAQsError, allFAQs) =>
                        if getAllFAQsError?
                            response.json 500, {error: getAllFAQsError.message}
                        else
                            response.json 200, allFAQs

        _getFAQ = (queueManager, poolManager, request, response) ->
            poolManager.acquire 'faqs', (controllerInstanceError, controllerInstance) =>
                if controllerInstanceError?
                    response.json 500, {error: controllerInstanceError.message}
                else if not controllerInstance?
                    getFAQRequestObject =
                        methodName: 'getFAQ'
                        arguments: [queueManager, poolManager, request, response]
                    queueManager.enqueueRequest 'faqs', getFAQRequestObject
                else
                    controllerInstance.getFAQ request.params.id, poolManager, queueManager, (getFAQError, FAQDetails) =>
                        if getFAQError?
                            response.json 500, {error: getFAQError.message}
                        else
                            response.json 200, FAQDetails

        constructor: ->

        insertAllFAQs: (queueManager, poolManager, request, response) =>
            _insertAllFAQs.call @, queueManager, poolManager, request, response

        insertFAQ: (queueManager, poolManager, request, response) =>
            _insertFAQ.call @, queueManager, poolManager, request, response

        getAllFAQs: (queueManager, poolManager, request, response) =>
            _getAllFAQs.call @, queueManager, poolManager, request, response

        getFAQ: (queueManager, poolManager,  request, response) =>
            _getFAQ.call @, queueManager, poolManager, request, response
