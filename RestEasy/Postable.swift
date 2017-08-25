//
//  Postable.swift
//  RestEasy
//
//  Created by Ryan Baldwin on 2017-08-21.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Foundation

public protocol Postable: Restable {}
extension Postable {
    /// Creates a POST request for the current instance and
    /// sets the body of the request to this instance's JSON representation
    ///
    /// - Returns: The URLRequest
    /// - Throws: An HTTPMethodError when the attempt to make the URLRequest failed.
    public func request() throws -> URLRequest {
        return try HTTPMethod.post.makeURLRequest(url: "\(baseURL)\(path)")
    }
}

extension Postable where Self: Encodable {
    /// Creates a POST request for the current instance and
    /// sets the body of the request to this instance's JSON representation
    ///
    /// - Returns: The URLRequest
    /// - Throws: An HTTPMethodError when the attempt to make the URLRequest failed.
    public func request() throws -> URLRequest {
        return try HTTPMethod.post.makeURLRequest(url: "\(baseURL)\(path)", body: self)
    }
}
