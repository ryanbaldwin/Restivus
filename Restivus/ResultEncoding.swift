//
//  ResultEncoding.swift
//  Restivus
//
//  Created by Ryan Baldwin on 2017-08-31.
//  Copyright © 2017 bunnyhug.me. All rights governed under the Apache 2 License Agreement
//

import Foundation

public enum ResultFormat {
    case json, raw
    
    /// Decodes and the provided data into an instance of the provided type,
    /// for the current format. If the current format is `.raw`, the raw
    /// `Raw` (`Data`) will be returned.
    ///
    /// - Parameters:
    ///   - result: The HTTPURLResponse data to decode
    ///   - type: The instance to inflate from the decoded data
    /// - Returns: An inflated instance of T
    /// - Throws: Error if unable to deocde the data based on the current format.
    public func decode<T: Decodable>(result: Data, `as` type: T.Type) throws -> T {
        switch self {
        case .json:
            return try JSONDecoder().decode(type, from: result)
        case .raw:
            return result as! T
        }
    }
    
    /// Returns a new URLRequest with the appropriately applied headers base on this ResultFormat
    /// For example, for `.raw`, no headers are applied,
    /// for `.json`, `application/json` headers are set for `Accept` and `Content-Type`, etc.
    /// - Parameter request: The request upon which the HTTPHeaders are to be set.
    /// - Returns: A new URLRequest with the set headers.
    public func headers(for request: URLRequest) -> URLRequest {
        if self == .raw { return request }
        
        var req = request
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return req
    }
}
