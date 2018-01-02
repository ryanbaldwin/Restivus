//
//  HTTPURLResponse+Extensions.swift
//  Restivus
//
//  Created by Ryan Baldwin on 2017-08-21.
//  Copyright © 2017 bunnyhug.me. All rights governed under the Apache 2 License Agreement
//

import Foundation

extension HTTPURLResponse {
    /// A textual representation of this instance, suitable for debugging.
    open override var debugDescription: String {
        var fields: [String] = ["\nResponse:", "==============="]
        fields.append("Response Code: \(self.statusCode)")
        
        
        if allHeaderFields.count > 0 {
            fields.append("Headers:")
            allHeaderFields.forEach { (key, val) in fields.append("\t\(key): \(val)") }
        }
        

        return fields.joined(separator: "\n")
    }
    
    /// True if this response code is a member of the 1xx Informational set of codes; otherwise false
    public var isInformational: Bool {
        return 100...199 ~= statusCode
    }
    
    /// True if this response code is a member of the 2xx Success response codes; otherwise false
    public var isSuccess: Bool {
        return 200...299 ~= statusCode
    }
    
    /// True if this response code is a member of the 3xx Redirection response codes; otherwise false
    public var isRedirection: Bool {
        return 300...399 ~= statusCode
    }
    
    /// True if this response code is a member of the 4xx Client Error response codes; otherwise false
    public var isClientError: Bool {
        return 400...499 ~= statusCode
    }
    
    /// True if this response code is a member of the 5xx Server Error response codes; otherwise false
    public var isServerError: Bool {
        return 500...599 ~= statusCode
    }
}
