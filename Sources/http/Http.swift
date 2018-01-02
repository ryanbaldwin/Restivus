//
//  HttpError.swift
//  Restivus
//
//  Created by Ryan Baldwin on 2017-08-21.
//  Copyright © 2017 bunnyhug.me. All rights governed under the Apache 2 License Agreement
//

import Foundation

/// Defines the various HttpErrors that can be received from an RestableCompletionHandler.
public enum HTTPError: Error {
    /// No response was returned from the server
    case noResponse,

    /// The URLResponse is not of the expected type
    unexpectedResponse(URLResponse, Data?),

    ///The HTTPURLResponse has a status code other than 2xx
    unsuccessfulResponse(HTTPURLResponse, Data?),

    /// The returned data cannot be deserialized into the expected type
    unableToDeserializeJSON(error: Error, data: Data?),

    /// Some other non-HttpError is raised.
    other(Error, Data?)
}

/// Determines if 2 HttpErrors are _roughly_ equal.
/// _Roughly equal_ because some enum values, such as `.unableToDeserializeJSON`,
/// cannot be accurately truely identified as "Equal" because of their underlying values.
/// As a result, the following enum values will always return true if they are the same at
/// superficial level:
/// - .unableToDeserializeJSON
/// - .other
///
/// - Parameters:
///   - lhs: The HttpError
///   - rhs: The other HttpError
/// - Returns: True if the 2 protocols are roughly equal; otherwise false.
extension HTTPError: Equatable {
    public static func ==(lhs: HTTPError, rhs: HTTPError) -> Bool {
        switch (lhs, rhs) {
        case (.noResponse, .noResponse): return true
            
        case (let .unexpectedResponse(response1, data1), let .unexpectedResponse(response2, data2)):
            return response1.isEqual(response2) && data1 == data2
            
        case (let .unsuccessfulResponse(response1, data1), let .unsuccessfulResponse(response2, data2)):
            return response1.statusCode == response2.statusCode && data1 == data2
            
        case(.unableToDeserializeJSON, .unableToDeserializeJSON):
            return true // nearly impossible to equate these 2 things accurately
            
        case (let .other(_, data1), let .other(_, data2)):
            return data1 == data2 // cannot accurately compare the underlying Error types as Error is a protocol
            
        default: return false
        }
    }
}

/// An error when HTTPMethodError fails to create a URLRequest
///
/// - invalidURL: An error in which the Requestable has a malformed URL
/// - jsonSerializationFailed: The JSONSerialization error that was raised during, you guessed it, JSON Serialization
enum HTTPMethodError: Error {
    case invalidURL(url: String)
    case jsonSerializationFailed(error: Error)
}

/// An enumeration of the supported methods
public enum HTTPMethod: String {
    /// Will generate POST requests for a given Restable
    case post = "POST"
    
    /// Will generate GET requests for a given Restable
    case get = "GET"
    
    /// Will gneerate a PUT request for a given Restable
    case put = "PUT"
    
    /// Will generate a PATCH request for a given Restable
    case patch = "PATCH"
    
    /// Will generate a DELETE request for a given restable
    case delete = "DELETE"
    
    /// Makes a URLRequest for a given `Restable`
    ///
    /// - Parameter restable: The `Restable` for which a `URLRequest` will be created
    /// - Returns: A URLRequest suitable for the given `Restable`
    /// - Throws: An `HTTPMethodError.invalidURL` if the `URLRequest` could not be created.
    private func _makeURLRequest<T>(`for` restable: T) throws -> URLRequest where T: Restable {
        guard let urlForRequest = restable.url ?? URL(string: restable.fullPath) else {
            throw HTTPMethodError.invalidURL(url: restable.fullPath)
        }
        
        var request = URLRequest(url: urlForRequest, cachePolicy: restable.cachePolicy,
                                 timeoutInterval: restable.timeoutInterval)
        request.httpMethod = rawValue
        return request
    }
    
    /// Creates a URLRequest appropriate for this instance
    ///
    /// - Parameter restable: The Restable for which a URLRequest is to be created
    /// - Returns: The URLRequest for this Restable
    /// - Throws: An `HTTPMethodError.invalidURL` if the `URLRequest` could not be created.
    public func makeURLRequest<T>(`for` restable: T) throws -> URLRequest where T: Restable {
        return try _makeURLRequest(for: restable)
    }
    
    /// Creates a URLRequest for this instance and uses the JSON Encoded data of this instance as the request's body.
    ///
    /// - Parameter restable: The Restable for which a URLRequest is to be created
    /// - Returns: The URLRequest for this Restable
    /// - Throws:
    ///     - An `HTTPMethodError.invalidURL` if the `URLRequest` could not be created.
    ///     - An `HTTPMethodError.jsonSerializationFailed(error: Error)` if the Restable fails to encode.
    public func makeURLRequest<T>(`for` restable: T) throws -> URLRequest where T: Restable & Encodable {
        var request = try _makeURLRequest(for: restable)
        
        do {
            request.httpBody = try encode(restable)
        } catch let error {
            throw HTTPMethodError.jsonSerializationFailed(error: error)
        }
        
        return request
    }
    
    /// Creates a URLRequest for this instance and uses this instance's `data` value as the request's body.
    ///
    /// - Parameter restable: The Restable for which a URLRequest is to be created
    /// - Returns: The URLRequest for this Restable
    /// - Throws: An `HTTPMethodError.invalidURL` if the `URLRequest` could not be created.
    public func makeURLRequest<T>(`for` restable: T) throws -> URLRequest where T: Restable & PreEncoded {
        var request = try _makeURLRequest(for: restable)
        request.httpBody = restable.data
        return request
    }
    
    /// JSON encodes the `Encodable` instance.
    ///
    /// - Parameter instance: The `Encodable` to be encoded
    /// - Returns: The encoded data of `instance`
    /// - Throws: throws an error based on the type of problem:
    ///     - The value fails to encode, or contains a nested value that fails to encode—this method throws the corresponding error.
    ///     - The value can't be encoded as a JSON array or JSON object—this method throws the invalidValue error.
    ///     - The value contains an exceptional floating-point number (such as infinity or nan) and you're using the default
    ///       JSONEncoder.NonConformingFloatEncodingStrategy—this method throws the invalidValue error.
    func encode<T>(_ instance: T) throws -> Data where T: Encodable {
        return try JSONEncoder().encode(instance)
    }
    
    /// JSON encodes the `Encodable` instance.
    ///
    /// - Parameter instance: The `Encodable` to be encoded
    /// - Returns: The encoded data of `instance`
    /// - Throws: throws an error based on the type of problem:
    ///     - The value fails to encode, or contains a nested value that fails to encode—this method throws the corresponding error.
    ///     - The value can't be encoded as a JSON array or JSON object—this method throws the invalidValue error.
    ///     - The value contains an exceptional floating-point number (such as infinity or nan) and you're using the default
    ///       JSONEncoder.NonConformingFloatEncodingStrategy—this method throws the invalidValue error.
    func encode<T>(_ instance: T) throws -> Data where T: Encodable & Restable {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = instance.dateEncodingStrategy
        return try encoder.encode(instance)
    }
}
