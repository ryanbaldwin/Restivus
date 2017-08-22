//
//  HTTPURLResponse+Extensions.swift
//  RestEasy
//
//  Created by Ryan Baldwin on 2017-08-21.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    public func formatForLog(withData data: Data? = nil) -> String {
        var fields: [String] = ["\nResponse:", "==============="]
        fields.append("Response Code: \(self.statusCode)")
        
        
        if allHeaderFields.count > 0 {
            fields.append("Headers:")
            allHeaderFields.forEach { (key, val) in fields.append("\t\(key): \(val)") }
        }
        
        if let data = data {
            let dataString = String(data: data, encoding: String.Encoding.utf8) ?? "Data could not be printed"
            fields.append(contentsOf: ["Data", "\t\(dataString)"])
        }
        
        return fields.joined(separator: "\n")
    }
}
