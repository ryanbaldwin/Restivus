//
//  HelperProtocols.swift
//  RestEasy
//
//  Created by Ryan Baldwin on 2017-08-22.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Foundation
@testable import RestEasy


func jsonify(_ dict: [String: Any]) -> Data {
    return try! JSONSerialization.data(withJSONObject: dict, options: [])
}

/// Provides a Path for a structure. _DefaultPath_ always returns `"/some/test/path"`
protocol DefaultPath {
    var path: String { get }
}

extension DefaultPath {
    var path: String {
        return "/some/test/path"
    }
}

/// Provides an implementation of toJSON which always returns nil
protocol NilEncodable: JSONSerializable {}
extension NilEncodable {
    func toJSON() -> JSON? {
        return nil
    }
}

/// Provides an impelemntation of toJSON which always returns an empty JSON
protocol EmptyEncodable: JSONSerializable {}
extension EmptyEncodable {
    func toJSON() -> JSON? {
        return jsonify([])
    }
}

protocol DataEncodable: JSONSerializable {}
extension DataEncodable {
    func asJSON() -> JSON? {
        return jsonify(["firstName": "ryan",
                        "lastName": "baldwin"])
    }
}
