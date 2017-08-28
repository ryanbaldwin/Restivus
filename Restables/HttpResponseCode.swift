//
//  HttpResponseCode.swift
//  Restables
//
//  Created by Ryan Baldwin on 2017-08-21.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Foundation

import Foundation

public enum HttpResponseCode: Int {
    case `continue` = 100
    case switchingProtocols = 101
    case processing = 102
    
    case ok200 = 200
    case created201 = 201
    case accepted202 = 202
    case nonAuthoritativeInformation203 = 203
    case noContent204 = 204
    case resetContent205 = 205
    case partialContent206 = 206
    case multiStatus207 = 207
    case alreadyReported208 = 208
    case imUsed226 = 226
    
    case multipleChoices300 = 300
    case movedPermanently301 = 301
    case found302 = 302
    case seeOther303 = 303
    case notModified304 = 304
    case useProxy305 = 305
    case unused306 = 306
    case temporaryRedirect307 = 307
    case permanentRedirect308 = 308
    
    case badRequest400 = 400
    case unauthorized401 = 401
    case paymentRequired402 = 402
    case forbidden403 = 403
    case notFound404 = 404
    case methodNotAllowed405 = 405
    case notAcceptable406 = 406
    case proxyAuthenticationRequired407 = 407
    case requestTimeout408 = 408
    case conflict409 = 409
    case gone410 = 410
    case lengthRequired411 = 411
    case preconditionFailed412 = 412
    case requestEntityTooLarge413 = 413
    case requestUriTooLong414 = 414
    case unsupportedMediaType45 = 415
    case requestedRangeNotSatisfiable416 = 416
    case expectationFailed417 = 417
    case teapot418 = 418
    case enhanceYourCalm420 = 420
    case unprocessableEntity442 = 422
    case locked423 = 423
    case failedDependency424 = 424
    case reservedForWebDAV425 = 425
    case upgradeRequired426 = 426
    case preconditionRequired428 = 428
    case tooManyRequests429 = 429
    case requestHeaderFieldsTooLarge431 = 431
    case noResponse444 = 444
    case retryWith449 = 449
    case blockedByWindowsParentalControls450 = 450
    case unavailableForLegalReasons451 = 451
    case clientClosedRequest499 = 499
    
    case internalServerError500 = 500
    case notImplemented501 = 501
    case badGateway502 = 502
    case serviceUnavailable503 = 503
    case gatewayTimeout504 = 504
    case httpVersionNotSupported505 = 505
    case variantAlsoNegotiates506 = 506
    case insufficientStorage507 = 507
    case loopDetected508 = 508
    case bandwidthLimitExceeded509 = 509
    case notExtended510 = 510
    case networkAuthenticationRequired511 = 511
    case networkReadTimeoutError598 = 598
    case networkConnectTimeoutError599 = 599
}

extension HttpResponseCode {
    
    /// True if this response code is a member of the 1xx Informational set of codes; otherwise false
    var isInformational: Bool {
        return 100...199 ~= rawValue
    }
    
    /// True if this response code is a member of the 2xx Success response codes; otherwise false
    var isSuccess: Bool {
        return 200...299 ~= rawValue
    }
    
    /// True if this response code is a member of the 3xx Redirection response codes; otherwise false
    var isRedirection: Bool {
        return 300...399 ~= rawValue
    }
    
    /// True if this response code is a member of the 4xx Client Error response codes; otherwise false
    var isClientError: Bool {
        return 400...499 ~= rawValue
    }
    
    /// True if this response code is a member of the 5xx Server Error response codes; otherwise false
    var isServerError: Bool {
        return 500...599 ~= rawValue
    }
}

extension HTTPURLResponse {
    var responseCode: HttpResponseCode {
        return HttpResponseCode(rawValue: self.statusCode)!
    }
}

