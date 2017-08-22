//
//  JSON.swift
//  RestEasy
//
//  Created by Ryan Baldwin on 2017-08-21.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Foundation

public typealias JSON = [String : Any]

/// Denotes that the conformer can create an instance of itself from JSON
public protocol JSONDeserializable {
    init?(json: JSON)
}

/// Denotes that the conformer can serialize itself to JSON
public protocol JSONSerializable {
    func toJSON() -> JSON?
}

/// Denotes that the conformer can both serialize and deserialize itself to/from JSON
public protocol JSONizable: JSONDeserializable, JSONSerializable {}
