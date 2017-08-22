//
//  HttpError.swift
//  RestEasy
//
//  Created by Ryan Baldwin on 2017-08-21.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Foundation

/// Defines the various HttpErrors that can be received in ann HttpSubmittable completion handler.
///
/// - noResponse: Used when no response was returned from the server
/// - noRequest: Used when no request was provided by a HttpRequestable
/// - unexpectedResponse: Used when the URLResponse is not of the expected type
/// - unsuccessfulResponse: Used when the HTTPURLResponse has a status code other than 2xx
/// - unableToDeserializeJSON: Used when the returned data cannot be deserialized into a JSON object
/// - noData: Used when the server response does not contain any data.
/// - couldNotInflateResultType: Used when unable to deserialize JSON into ResultType
/// - other: Called when some other non-HttpError is raised.
public enum HttpError: Error {
    case noResponse,
    noRequest,
    unexpectedResponse(URLResponse),
    unsuccessfulResponse(HTTPURLResponse),
    unableToDeserializeJSON(error: Error, data: Data?),
    noData,
    couldNotInflateResultType(json: JSON, resultType: JSONDeserializable.Type),
    other(Error)
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
extension HttpError: Equatable {
    public static func ==(lhs: HttpError, rhs: HttpError) -> Bool {
        switch (lhs, rhs) {
        case (.noResponse, .noResponse): return true
            
        case (.noRequest, .noRequest): return true
            
        case (let .unexpectedResponse(response1), let .unexpectedResponse(response2)):
            return response1.isEqual(response2)
            
        case (let .unsuccessfulResponse(response1), let .unsuccessfulResponse(response2)):
            return response1.responseCode == response2.responseCode
            
        case(.unableToDeserializeJSON, .unableToDeserializeJSON):
            return true // nearly impossible to equate these 2 things accurately
            
        case (let .couldNotInflateResultType(_, type1), let .couldNotInflateResultType(_, type2)):
            return type1.self == type2.self // JSON is a [String: Any], and thus isn't equatable.
            
        case (.other, .other):
            return true // cannot accurately compare the underlying Error types as Error is a protocol
            
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
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    
    /// Creates a URLRequest appropriate for this instance
    ///
    /// - Parameter url: The full URL for the URLRequest
    /// - Returns: A URLRequest ready for submission
    /// - Throws: An `InvalidURLError` if the `url` is malformed
    func makeURLRequest(url: String) throws -> URLRequest {
        return try makeURLRequest(url: url, object: nil)
    }
    
    /// Creates a URLRequest appropriate for this instance
    ///
    /// - Parameters
    ///   - url: The full URL for the URLRequest
    ///   - object: The JSONSerializable which, when provided, will be serialized and attached to the `URLRequest`s body
    /// - Returns: A URLRequest ready for submission
    /// - Throws: An `InvalidURLError` if the `url` is malformed, or another `Error` occuring during
    ///           the JSONSerialization of the `object`.
    func makeURLRequest(url: String, object: JSONSerializable?) throws -> URLRequest {
        guard let urlForRequest = URL(string: url) else {
            throw HTTPMethodError.invalidURL(url: url)
        }
        
        var request = URLRequest(url: urlForRequest)
        request.httpMethod = rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let object = object {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: object.asJSON() ?? [], options: [])
            } catch let error {
                throw HTTPMethodError.jsonSerializationFailed(error: error)
            }
        }
        
        return request
    }
}
