//
//  Authenticating.swift
//  Restivus
//
//  Created by Ryan Baldwin on 2017-08-28.
//  Copyright © 2017 bunnyhug.me. All rights governed under the Apache 2 License Agreement
//

import Foundation

/// Provides pre-submission hook which allows a Restable to mutate the HTTPURLRequest
/// such that the request will pass authentication with a secured endpoint.
/// For example, adding a token in a header.
public protocol Interceptable {
    /// Signs the provided URLRequest by whatever means is required for authenticating
    /// the request against its destination.
    ///
    /// - Parameter request: The URLRequest requiring authentication
    /// - Returns: A signed version of the provided `request`
    func intercept(request: URLRequest) -> URLRequest
}
