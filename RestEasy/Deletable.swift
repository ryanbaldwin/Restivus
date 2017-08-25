//
//  Deletable.swift
//  RestEasy
//
//  Created by Ryan Baldwin on 2017-08-21.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Foundation

public protocol Deletable: Restable {}

extension Deletable {
    /// Creates a DELETE request for the current instance and
    /// sets the body of the request to this instance's JSON representation
    ///
    /// - Returns: The URLRequest
    /// - Throws: An HTTPMethodError when the attempt to make the URLRequest failed.
    public func request() throws -> URLRequest {
        return try HTTPMethod.delete.makeURLRequest(url: "\(baseURL)\(path)")
    }
}

extension Deletable where Self: Encodable {
    /// Creates a DELETE request for the current instance and
    /// sets the body of the request to this instance's JSON representation
    ///
    /// - Returns: The URLRequest
    /// - Throws: An HTTPMethodError when the attempt to make the URLRequest failed.
    public func request() throws -> URLRequest {
        return try HTTPMethod.delete.makeURLRequest(url: "\(baseURL)\(path)", body: self)
    }
}
