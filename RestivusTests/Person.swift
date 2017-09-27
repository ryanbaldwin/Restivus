//
//  Person.swift
//  RestivusTests
//
//  Created by Ryan Baldwin on 2017-08-23.
//  Copyright © 2017 bunnyhug.me. All rights governed under the Apache 2 License Agreement
//

import Foundation

struct Person: Codable {
    let firstName: String
    let lastName: String
    let age: Int
}

extension Person: Equatable {
    static func ==(lhs: Person, rhs: Person) -> Bool {
        return lhs.firstName == rhs.firstName
            && lhs.lastName == rhs.lastName
            && lhs.age == rhs.age
    }
}
