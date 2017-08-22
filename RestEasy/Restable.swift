//
//  HttpRequestable.swift
//  RestEasy
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
    case failure(Error)
}

// The function used as a completion handler in all HttpSubmittables.
public typealias HttpSubmittableCompletionHandler<HttpResponse> = (Result<HttpResponse>) -> Void

public protocol Restable {
    associatedtype ResponseType: JSONDeserializable
    
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
    /// - Returns: A URLRequest object, if one was successfully created; otherwise nil
    func request() throws -> URLRequest

    /// Submits this request
    ///
    /// - Parameters:
    ///   - callbackOnMain: A flag indicating if the `completionHandler` should be dispatched to the main queue.
    ///                     Defaults to true
    ///   - completionHandler: The handler to be called upon completion or failure.
    func submit(callbackOnMain: Bool, completion: HttpSubmittableCompletionHandler<ResponseType>?)
}

extension Restable {
    public func submit(callbackOnMain: Bool = true,
                       completion: HttpSubmittableCompletionHandler<ResponseType>?) throws -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: try request()) {
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
            completion?(Result.failure(HttpError.other(error!)))
            return
        }
        
        guard let response = response else {
            completion?(Result.failure(HttpError.noResponse))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            completion?(Result.failure(HttpError.unexpectedResponse(response)))
            return
        }
        
        guard httpResponse.responseCode.isSuccess else {
            
            // It's not unreasonable for an application to have a centralized place for catching
            // server 500 errors. So lets be a good citizen and post an app wide notification stating the
            // server is puking it guts out. It had too much to drink. It's not feeling very well. Poor little guy.
            /*
            if self is NotificationCenterPublishable && httpResponse.responseCode.isServerError {
                NotificationCenter.default.post(Notification(name: .BAServerDidRaise5xx))
                /* ,
                 object: nil,
                 userInfo: [String(describing: HttpRequestable.self): self,
                 String(describing: HTTPURLResponse.self): httpResponse]*/
            }
            */
            // TODO - if there's a 403 here we may want to broadcast it to the app so we can
            //        get the user to login via a modal or something.
            //                if httpResponse.responseCode == .unauthorized {
            //                    // NOTIFY!
            //                }
            
            completion?(Result.failure(HttpError.unsuccessfulResponse(httpResponse)))
            return
        }
        
        var json = JSON()
        
        if httpResponse.responseCode != .noContent204 {
            do {
                json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as! JSON
            } catch let error {
                completion?(Result.failure(HttpError.unableToDeserializeJSON(error: error, data: data)))
                return
            }
        }
        
        guard let result = ResponseType(json: json) else {
            completion?(Result.failure(HttpError.couldNotInflateResultType(json: json, resultType: ResponseType.self)))
            return
        }
        
        completion?(Result.success(result))
    }
}
