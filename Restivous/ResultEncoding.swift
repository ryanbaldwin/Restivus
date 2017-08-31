//
//  ResultEncoding.swift
//  Restivous
//
//  Created by Ryan Baldwin on 2017-08-31.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Foundation

public enum ResultFormat {
    case json, raw
    
    public func decode<T: Decodable>(result: Data, `as` type: T.Type) throws -> T {
        switch self {
        case .json:
            return try JSONDecoder().decode(type, from: result)
        case .raw:
            return result as! T
        }
    }
}
