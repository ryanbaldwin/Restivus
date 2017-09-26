//
//  Restivous.swift
//  RestivousTests
//
//  Created by Ryan Baldwin on 2017-08-24.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Foundation
@testable import Restivous

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

/// A `Restable` which will always throw an `HTTPError.noRequest` when submitted.
struct NoRequestRestable: Restable {
    typealias ResponseType = Person
    
    func request() throws -> URLRequest {
        throw HTTPError.noRequest
    }
}

/// A `Restable` which will always complete with an `HTTPError.other(HTTPError.noData)` when submitted.
struct OtherErrorRestable: Restable {
    typealias ResponseType = Person
    
    func request() throws -> URLRequest {
        return try HTTPMethod.get.makeURLRequest(url: "\(baseURL)\(path)")
    }
}
