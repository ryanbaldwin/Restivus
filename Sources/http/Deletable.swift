//
//  Deletable.swift
//  Restivus
//
//  Created by Ryan Baldwin on 2017-08-21.
//  Copyright © 2017 bunnyhug.me. All rights governed under the Apache 2 License Agreement
//

import Foundation

/// Designates the conforming type as a DELETE HTTP Request.
public protocol Deletable: Restable {}

extension Deletable {
    /// Creates a DELETE request for the current instance
    ///
    /// - Returns: The URLRequest
    /// - Throws: An HTTPMethodError when the attempt to make the URLRequest failed.
    public func request() throws -> URLRequest {
        return try HTTPMethod.delete.makeURLRequest(for: self)
    }
}

extension Deletable where Self: PreEncoded {
    /// Creates a DELETE request for the current PreEncoded instance,
    /// and uses the `data` value as the body for the request.
    ///
    /// - Returns: The URLRequest
    /// - Throws: An HTTPMethodError when the attempt to make the URLRequest failed.
    public func request() throws -> URLRequest {
        return try HTTPMethod.delete.makeURLRequest(for: self)
    }
}

extension Deletable where Self: Encodable {
    /// Creates a DELETE request for the current Encodable instance,
    /// and encodes itself into the HTTP body of the request.
    ///
    /// - Returns: The URLRequest
    /// - Throws: An HTTPMethodError when the attempt to make the URLRequest failed.
    public func request() throws -> URLRequest {
        return try HTTPMethod.delete.makeURLRequest(for: self)
    }
}
