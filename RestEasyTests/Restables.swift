//
//  Restables.swift
//  RestEasyTests
//
//  Created by Ryan Baldwin on 2017-08-24.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Foundation
@testable import RestEasy

/// A `Restable` which will always throw an `HTTPError.noRequest` when submitted.
struct NoRequestRestable: Restable {
    typealias ResponseType = Person
    
    var baseURL: String = ""
    var path: String = ""
    
    func request() throws -> URLRequest {
        throw HTTPError.noRequest
    }
}

/// A `Restable` which will always complete with an `HTTPError.other(HTTPError.noData)` when submitted.
struct OtherErrorRestable: Restable {
    typealias ResponseType = Person
    
    var baseURL: String = "https://www.google.com"
    var path: String = "/"
    
    func request() throws -> URLRequest {
        return try HTTPMethod.get.makeURLRequest(url: "\(baseURL)\(path)")
    }
}

// MARK: Deletable
struct DeletePersonRequest: Deletable {
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

// MARK: Gettable

struct GetPersonRequest: Gettable {
    typealias ResponseType = Person
    var path = "/"
}

struct PatchPersonRequest: Patchable {
    typealias ResponseType = Person
    var path = "/"
}

struct PostPersonRequest: Postable {
    typealias ResponseType = Person
    var path = "/"
}

struct PutPersonRequest: Puttable {
    typealias ResponseType = Person
    var path = "/"
}
