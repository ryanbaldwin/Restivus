//
//  Interceptable.swift
//  Restivus
//
//  Created by Ryan Baldwin on 2017-08-28.
//  Copyright © 2017 bunnyhug.me. All rights governed under the Apache 2 License Agreement
//

import Foundation

/// Provides pre-submission hook which allows a Restable to mutate the HTTPURLRequest.
/// For example, adding a token in a header.
public protocol Interceptable {
    /// Intercepts a URLRequest and allows the handler to mutate it to its heart content
    ///
    /// In the following example we conform `SomeRequest` to be an `Interceptable`, such that
    /// SomeRequest will attach an authorization HTTP Header prior to the request being sent:
    ///
    ///     struct SomeRequest: Gettable {...}
    ///     extension SomeRequest: Interceptable {
    ///         func intercept(request: URLRequest) -> URLRequest {
    ///             var req = request
    ///             req.setValue("Token I_AM_KING", forHTTPHeaderField: "Authorization")
    ///             return req
    ///         }
    ///     }
    ///
    /// - Parameter request: The intercepted URLRequest
    /// - Returns: A (possibly) mutated version of the provided `request`
    func intercept(request: URLRequest) -> URLRequest
}
