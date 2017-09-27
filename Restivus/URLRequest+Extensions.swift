//
//  URLRequest+Extensions.swift
//  Restivus
//
//  Created by Ryan Baldwin on 2017-08-22.
//  Copyright © 2017 bunnyhug.me. All rights governed under the Apache 2 License Agreement
//

import Foundation

extension URLRequest {
    /// Returns a string containing formatted, detailed information about the URLRequest.
    ///
    /// - Returns: A detailed description of this request.
    var debugDescription: String {
        var fields: [String] = ["\nRequest:", "===============", "Method: \(self.httpMethod ?? "GET")"]
        
        if let url = self.url {
            fields.append("URL: \(url)")
        }
        
        
        if let headers = allHTTPHeaderFields, headers.count > 0 {
            fields.append("Headers:")
            headers.forEach { (key, val) in fields.append("\t\(key): \(val)") }
        }
        
        if let body = self.httpBody {
            fields.append("Body:")
            
            let renderedBody = String(data: body, encoding: String.Encoding.utf8) ?? "HTTPBody could not be rendered"
            fields.append(renderedBody)
        }
        fields.append("\n")
        return fields.joined(separator: "\n")
    }
}
