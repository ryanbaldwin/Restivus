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

extension Authenticating {
    func sign(request: URLRequest) -> URLRequest {
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

struct DeletePersonRequest: Authenticating, Deletable {
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

struct GetPersonRequest: Authenticating, Gettable {
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
struct PatchPersonRequest: Authenticating, Patchable {
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

struct PostPersonRequest: Authenticating, Postable {
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

struct PutPersonRequest: Authenticating, Puttable {
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

