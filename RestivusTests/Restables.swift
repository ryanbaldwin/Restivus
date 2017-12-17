//
//  Restivus.swift
//  RestivusTests
//
//  Created by Ryan Baldwin on 2017-08-24.
//  Copyright © 2017 bunnyhug.me. All rights governed under the Apache 2 License Agreement
//

import Foundation
@testable import Restivus

// By default, all our Restables, should they go over the wire,
// will return a 418 (I'm a teapot) from `httpstat.us`
extension Restable {
    var baseURL: String {
        return "http://httpstat.us"
    }
    
    var path: String {
        return "/418"
    }
}

extension Interceptable {
    func intercept(request: URLRequest) -> URLRequest {
        var req = request
        req.setValue("SIGNED", forHTTPHeaderField: "Is Signed")
        return req
    }
}

/// A `Restable` which will always complete with an `HTTPError.other(HTTPError.noData)` when submitted.
struct OtherErrorRestable: Restable {
    typealias ResponseType = Person
    
    func request() throws -> URLRequest {
        return try HTTPMethod.get.makeURLRequest(for: self)
    }
}

// MARK: DeletePerson requests

struct DeletePersonRequest: Interceptable, Deletable {
    typealias ResponseType = Person
    var path = "/"
}

struct EncodableDeletePersonRequest: Encodable {
    var personId: String
}
extension EncodableDeletePersonRequest: Deletable {
    typealias ResponseType = Person
    var path: String { return "/" }
}

// MARK: Get Person Requests

struct GetPersonRequest: Interceptable, Gettable {
    typealias ResponseType = Person
    var path = "/"
}

struct EncodableGetPersonRequest: Encodable {
    var personId: String
}
extension EncodableGetPersonRequest: Gettable {
    typealias ResponseType = Person
    var path: String { return "/" }
}

// MARK: Path Person Requests
struct PatchPersonRequest: Interceptable, Patchable {
    typealias ResponseType = Person
    var path = "/"
}

struct EncodablePatchPersonRequest: Encodable {
    var personId: String
}
extension EncodablePatchPersonRequest: Patchable {
    typealias ResponseType = Person
    var path: String { return "/" }
}

// MARK: Post Person Requests

struct PostPersonRequest: Interceptable, Postable {
    typealias ResponseType = Person
    let path = "/"
}

struct EncodablePostPersonRequest: Encodable {
    var personId: String
}
extension EncodablePostPersonRequest: Postable {
    typealias ResponseType = Person
    var path: String { return "/" }
}

// MARK: Put Person Requests

struct PutPersonRequest: Interceptable, Puttable {
    typealias ResponseType = Person
    var path = "/"
}

struct EncodablePutPersonRequest: Encodable {
    var personId: String
}
extension EncodablePutPersonRequest: Puttable {
    typealias ResponseType = Person
    var path: String { return "/" }
}

/// Issue #5 reports that Accept header can't be set on an Interceptable request.
/// This was a result of the actual interception occuring too soon in the submissions process.
/// This is a test request to ensure this is no longer the case.
struct InterceptableRequest: Interceptable, Gettable {
    typealias ResponseType = Raw
    var resultFormat: ResultFormat = .raw
    var path: String { return "/" }
    
    func intercept(request: URLRequest) -> URLRequest {
        var req = request
        req.setValue("ANYTHING-YOU-WANT", forHTTPHeaderField: "Accept")
        return req
    }
}
