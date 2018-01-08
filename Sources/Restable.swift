//
//  HttpRequestable.swift
//  Restivus
//
//  Created by Ryan Baldwin on 2017-08-21.
//  Copyright © 2017 bunnyhug.me. All rights governed under the Apache 2 License Agreement
//

import Foundation

extension Notification.Name {
    /// A Restivus Restable received a non-2xx response from the server.
    /// When sent, the `object` of the notification will be the original `Restable`
    /// request that produced the non-2xx response. The `userInfo["response"]` will
    /// contain the HTTPURLResponse received from the server.
    public static let RestivusReceivedNon200 = Notification.Name("RestivusReceivedNon200")
}

/// When applied to a conforming `Restable`, and the response from the server
/// results in any Non-2xx HTTP Response, Restivus will publish a Notification Center
/// notification, containing the original request and response.
public protocol NotificationCenterPublishable {
    /// Determines if Restivus should publish a `RestivusReceivedNon200` notification
    /// for this instance.
    ///
    /// - Parameter _: The `HTTPURLResponse` from the server
    /// - Returns: Return `true` if Restivus should publish a `RestivusReceivedNon200` notification;
    ///            otherwise `false`.
    func shouldPublish(_: HTTPURLResponse) -> Bool
}

/// When present, Restivus will populate the body of the HTTPURLRequest with
/// the data found in the `data` property of the Restable request.
/// If a Restable conforms to both `PreEncoded` and `Encodable`, Restivus will ignore the `Encodable`
public protocol PreEncoded {
    /// The data to put into the body of the HTTPURLRequest
    var data: Data { get }
}

/// The type to be used when no custom Decodable result is required.
/// Useful for when you don't know, or care, what the response is (or if one is even provided),
/// such as a `Deletable` with no response body, or a `Gettable` which returns HTML.
public typealias Raw = Data

/// Represents the result of an asynchronous operation.
public enum Result<Success> {
    /// The operation was a success, and contains the `Success` output from that operation.
    case success(Success)
    
    /// The operation failed, and contains the `Error` from that operation.
    case failure(HTTPError)
}

/// A wrapper which will contain the decoded `T` instance, if one was successfully decoded; otherwise `nil`.
/// `OptionalResponseType` is useful for when you have a request which may or may not return the expected
/// JSON structure. For example, fetching a mythical `UserDetails` JSON for a user who does not exist,
/// but for reason - unbeknownst to us - the server return no JSON instead of a 404.
///
/// Example:
/// ---
///
///     struct UserDetails {
///         var mothersMaidenName: String
///         var lovesTheDentist: Bool
///     }
///
///     struct UserDetailsRequest: Codable {
///         var userId: Int
///     }
///
///     extension UserDetailsRequest: Interceptable, Gettable {
///         typealias ResponseType = OptionalResponseType<UserDetails>
///         var path: String = "/some/api/path"
///     }
///
///     UserDetailsRequest(userId: 42).submit() { result in
///         if case let Result.success(optionalUserDetails) = result {
///             let userDetails = optionalUserDetails.instance
///
///         }
///     }
/// ---
public struct OptionalResponseType<T>: Decodable where T: Decodable {
    /// Gets the optional inflated instance of `T` that may or may not have been returned in an `HTTPURLResponse`
    public private(set) var instance: T? = nil
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.instance = try? container.decode(T.self)
    }
}


// The function used as a completion handler in all Restables.
public typealias RestableCompletionHandler<ResponseType> = (Result<ResponseType>) -> ()

/// The base protocol for method-specific protocols.
public protocol Restable {
    associatedtype ResponseType: Decodable
    
    /// Defines the `JSONDecoder.DateDecodingStrategy` to use when decoding from JSON into the conforming instance.
    /// Defaults to `.deferredToDate`
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get }
    
    /// Defines the `JSONEncoder.DateEncodingStrategy` to use when JSON encoding a conforming instance.
    /// Defaults to `.deferredToDate`
    var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy { get }
    
    /// The base url against which the request will be made.
    /// Example: 
    ///
    ///     "https://www.google.com"
    var baseURL: String { get }
    
    /// The Path to the endpoint.
    /// Example:
    ///
    ///    "/some/path"
    var path: String { get }
    
    /// An optional URL to use for the request instead of `baseURL` and `path`.
    /// When preset `baseURL` and `path` will be ignored.
    /// Defaults to nil.
    var url: URL? { get }
    
    /// The cache policy to use for this `Restable`. Defaults to .useProtocolCachePolicy
    var cachePolicy: URLRequest.CachePolicy { get }
    
    /// The timeout interval for the request. Defaults to 60.0
    var timeoutInterval: TimeInterval { get }
    
    /// Creates a URLRequest object.
    ///
    /// - Returns: A URLRequest object, if one was successfully created
    func request() throws -> URLRequest

    /// Defines the expected format of the response
    var resultFormat: ResultFormat { get }
    
    /// Submits this request
    ///
    /// - Parameters:
    ///   - callbackOnMain: A flag indicating if the `completionHandler` should be dispatched to the main queue.
    ///   - session: The URLSession from which the URLSessionDataTask will be created.
    ///   - completion: The handler to be called upon completion or failure.
    /// - Returns: The URLSessionDataTask
    /// - Throws: If a URLSessionDataTask failed to create
    @discardableResult func submit(callbackOnMain: Bool, session: URLSession, completion: RestableCompletionHandler<ResponseType>?) throws -> URLSessionDataTask
}

extension Restable {
    /// Defines the `JSONDecoder.DateDecodingStrategy` to use when decoding from JSON into the conforming type.
    /// Defaults to `.deferredToDate`
    public var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        return .deferredToDate
    }
    
    /// Defines the `JSONEncoder.DateEncodingStrategy` to use when JSON encoding a conforming instance.
    /// Defaults to `.deferredToDate`
    public var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy {
        return .deferredToDate
    }
    
    /// The base url against which the request will be made.
    /// Example:
    ///
    ///     "https://www.google.com"
    public var baseURL: String { return "" }
    
    /// The Path to the endpoint.
    /// Example:
    ///
    ///    "/some/path"
    public var path: String { return "" }
    
    /// Returns a dumb concatenation of `baseURL` + `path`.
    public var fullPath: String {
        return "\(baseURL)\(path)"
    }
    
    /// An optional URL to use for the request instead of `baseURL` and `path`.
    /// When preset `baseURL` and `path` will be ignored.
    /// Defaults to nil.
    public var url: URL? { return nil }
    
    /// The cache policy to use for this `Restable`. Defaults to .useProtocolCachePolicy
    public var cachePolicy: URLRequest.CachePolicy { return .useProtocolCachePolicy }
    
    /// The timeout interval for the request. Defaults to 60.0
    public var timeoutInterval: TimeInterval { return 60.0 }
    
    /// Defines the expected format of the response
    /// Defaults to `.json`
    public var resultFormat: ResultFormat { return .json }
    
    /// Submits this request
    ///
    /// - Parameters:
    ///   - callbackOnMain: When `true`, will dispatch the `completion` on the main queue. Otherwise `completion` will
    ///                     be dispatched on whichever dispatch queue the task was original submitted.
    ///                     Defaults to `true`.
    ///   - session: The URLSession from which the URLSessionDataTask will be created. Defaults to `URLSession.shared`
    ///   - completion: The handler to be called upon completion or failure. Defaults to `nil`
    /// - Returns: The URLSessionDataTask
    /// - Throws: If a URLSessionDataTask failed to create
    @discardableResult public func submit(callbackOnMain: Bool = true,
                                          session: URLSession = URLSession.shared,
                                          completion: RestableCompletionHandler<ResponseType>? = nil) throws -> URLSessionDataTask {
        var request = resultFormat.headers(for: try self.request())
        if let interceptable = self as? Interceptable {
            request = interceptable.intercept(request: request)
        }
        
        print(request.debugDescription)
        
        let task = session.dataTask(with: request) {
            data, response, error in
            
            if let res = response {
                print(res.debugDescription)
                if let json = data {
                    print("Data: \n")
                    print(String(data: json, encoding: .utf8) ?? "")
                }
            }
            
            let callback = { self.dataTaskCompletionHandler(data: data, response: response, error: error,
                                                            completion: completion) }
            if callbackOnMain {
                DispatchQueue.main.async {
                    callback()
                }
            } else {
                callback()
            }
        }
        
        task.resume()
        return task
    }
    
    /// Actually handles the callback from the dataTask.
    ///
    /// - Parameters:
    ///   - data: Data returned from the dataTask, if any.
    ///   - response: The HTTPURLResponse
    ///   - error: Any error that may have occured
    ///   - completionHandler: The original completionHandler passed to `submit:`
    func dataTaskCompletionHandler(data: Data?, response: URLResponse?, error: Error?,
                                   completion: RestableCompletionHandler<ResponseType>?) {
        guard error == nil else {
            completion?(Result.failure(.other(error!, data)))
            return
        }
        
        guard let response = response else {
            completion?(Result.failure(.noResponse))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            completion?(Result.failure(.unexpectedResponse(response, data)))
            return
        }
        
        guard httpResponse.isSuccess else {
            if (self as? NotificationCenterPublishable)?.shouldPublish(httpResponse) == true {
                NotificationCenter.default.post(Notification(name: .RestivusReceivedNon200, object: self,
                                                             userInfo: ["response": httpResponse]))
            }
            
            completion?(Result.failure(HTTPError.unsuccessfulResponse(httpResponse, data)))
            return
        }
        
        do {
            if ResponseType.self == Raw.self {
                completion?(Result.success((data ?? Raw()) as! ResponseType))
                return
            }
            
            let jsonData = data ?? "{}".data(using: .utf8)!
            let result = try resultFormat.decode(result: jsonData, as: ResponseType.self)
            completion?(Result.success(result))
        } catch let error {
            print(error)
            completion?(Result.failure(.unableToDeserializeJSON(error: error, data: data)))
        }
    }
}

/// A Type-erased container which can hold any Restable for a given response type.
/// Use this for variables and/or function parameters instead of raw `Restable`.
/// Attemping to use a raw `Restable` or any of its children (`Gettable`, `Postable`, etc.) will
/// result in a compiler error regarding associated types.
/// To get the full fledged story google `Swift Static Linking and Protocols with Associated Types`,
/// crack a bottle of whisky, and watch Game of Thrones.
public class AnyRestable<ExpectedResponseType: Decodable>: Restable {
    public typealias ResponseType = ExpectedResponseType
    
    public var baseURL: String
    public var path: String
    
    private var _request: () throws -> URLRequest
    private var _submit: (Bool, URLSession, RestableCompletionHandler<ResponseType>?) throws -> URLSessionDataTask
    
    /// Wraps the provided `restable` into a type-erased enclosure,
    /// allowing it to be passed around to other functions, used as a stored property, etc.
    ///
    /// - Parameters:
    ///     - restable: The restable to be type-erased.
    public init<R: Restable>(_ restable: R) where R.ResponseType == ExpectedResponseType {
        baseURL = restable.baseURL
        path = restable.path
        _request = { return try restable.request() }
        _submit = { return try restable.submit(callbackOnMain: $0, session: $1, completion: $2) }
    }
    
    public func request() throws -> URLRequest {
        return try _request()
    }
    
    @discardableResult public func submit(callbackOnMain: Bool = true,
                       session: URLSession = URLSession.shared,
                       completion: RestableCompletionHandler<ResponseType>? = nil) throws -> URLSessionDataTask {
        return try _submit(callbackOnMain, session, completion)
    }
}
