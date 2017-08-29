//
//  HttpRequestable.swift
//  Restivous
//
//  Created by Ryan Baldwin on 2017-08-21.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Foundation

/// Represents the result of an asynchronous operation.
///
/// - success: The operation was a success, and contains the `Success` output from that operation.
/// - failure: The operation failed, and contains the `Error` from that operation.
public enum Result<Success> {
    case success(Success)
    case failure(HTTPError)
}

// The function used as a completion handler in all HttpSubmittables.
public typealias HttpSubmittableCompletionHandler<HttpResponse> = (Result<HttpResponse>) -> Void

public protocol Restable {
    associatedtype ResponseType: Decodable
    
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
    
    /// Creates a URLRequest object.
    ///
    /// - Returns: A URLRequest object, if one was successfully created
    func request() throws -> URLRequest

    /// Submits this request
    ///
    /// - Parameters:
    ///   - callbackOnMain: A flag indicating if the `completionHandler` should be dispatched to the main queue.
    ///   - session: The URLSession from which the URLSessionDataTask will be created.
    ///   - completion: The handler to be called upon completion or failure.
    /// - Returns: The URLSessionDataTask
    /// - Throws: If a URLSessionDataTask failed to create
    @discardableResult func submit(callbackOnMain: Bool, session: URLSession,
                                   completion: HttpSubmittableCompletionHandler<ResponseType>?) throws -> URLSessionDataTask
}

extension Restable {
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
                                          completion: HttpSubmittableCompletionHandler<ResponseType>? = nil) throws -> URLSessionDataTask {
        let task = session.dataTask(with: try request()) {
            data, response, error in
            
            if let res = response {
                print(res)
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
                                   completion: HttpSubmittableCompletionHandler<ResponseType>?) {
        guard error == nil else {
            completion?(Result.failure(.other(error!)))
            return
        }
        
        guard let response = response else {
            completion?(Result.failure(.noResponse))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            completion?(Result.failure(.unexpectedResponse(response)))
            return
        }
        
        guard httpResponse.responseCode.isSuccess else {
            completion?(Result.failure(HTTPError.unsuccessfulResponse(httpResponse)))
            return
        }
        
        let jsonData = data ?? Data()
        do {
            let result = try JSONDecoder().decode(ResponseType.self, from: jsonData)
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
/// result in a cpmiler error regarding associated types.
/// To get the full fledged story google `Swift Static Linking and Protocols with Associated Types`,
/// crack a bottle of whisky, and watch Game of Thrones.
public class AnyRestable<ExpectedResponseType: Decodable>: Restable {
    public typealias ResponseType = ExpectedResponseType
    
    public var baseURL: String
    public var path: String
    
    private var _request: () throws -> URLRequest
    private var _submit: (Bool, URLSession, ((Result<ExpectedResponseType>) -> Void)?) throws -> URLSessionDataTask
    
    init<R: Restable>(_ restable: R) where R.ResponseType == ExpectedResponseType {
        baseURL = restable.baseURL
        path = restable.path
        _request = { return try restable.request() }
        _submit = { return try restable.submit(callbackOnMain: $0, session: $1, completion: $2) }
    }
    
    public func request() throws -> URLRequest {
        return try _request()
    }
    
    public func submit(callbackOnMain: Bool = true,
                       session: URLSession = URLSession.shared,
                       completion: HttpSubmittableCompletionHandler<ResponseType>? = nil) throws -> URLSessionDataTask {
        return try _submit(callbackOnMain, session, completion)
    }
}
