//
//  HTTPURLResponse+Extensions.swift
//  Restables
//
//  Created by Ryan Baldwin on 2017-08-21.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    open override var debugDescription: String {
        var fields: [String] = ["\nResponse:", "==============="]
        fields.append("Response Code: \(self.statusCode)")
        
        
        if allHeaderFields.count > 0 {
            fields.append("Headers:")
            allHeaderFields.forEach { (key, val) in fields.append("\t\(key): \(val)") }
        }
        

        return fields.joined(separator: "\n")
    }
}
