//
//  Patchable.swift
//  Restivous
//
//  Created by Ryan Baldwin on 2017-08-21.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Foundation

public protocol Patchable: Restable {}
extension Patchable {
    /// Creates a PATCH request for the current instance and
    /// sets the body of the request to this instance's JSON representation
    ///
    /// - Returns: The URLRequest
    /// - Throws: An HTTPMethodError when the attempt to make the URLRequest failed.
    public func request() throws -> URLRequest {
        return try HTTPMethod.patch.makeURLRequest(url: "\(baseURL)\(path)")
    }
}

extension Patchable where Self: Encodable {
    /// Creates a PATCH request for the current instance and
    /// sets the body of the request to this instance's JSON representation
    ///
    /// - Returns: The URLRequest
    /// - Throws: An HTTPMethodError when the attempt to make the URLRequest failed.
    public func request() throws -> URLRequest {
        return try HTTPMethod.patch.makeURLRequest(url: "\(baseURL)\(path)", body: self)
    }
}
