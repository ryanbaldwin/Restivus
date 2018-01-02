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
    /// - Parameter request: The intercepted URLRequest
    /// - Returns: A (possibly) mutated version of the provided `request`
    func intercept(request: URLRequest) -> URLRequest
}
