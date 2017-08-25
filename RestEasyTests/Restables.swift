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
struct ThrowingPersonRequest: Restable {
    typealias ResponseType = Person
    
    var baseURL: String = ""
    var path: String = ""
    
    func request() throws -> URLRequest {
        throw HTTPError.noRequest
    }
}

/// A `Restable` which will always complete with an `HTTPError.other(HTTPError.noData)` when submitted.
struct PersonRequest: Restable {
    typealias ResponseType = Person
    
    var baseURL: String = "https://www.google.com"
    var path: String = "/"
    
    func request() throws -> URLRequest {
        return try HTTPMethod.get.makeURLRequest(url: "\(baseURL)\(path)")
    }
}
