//
//  PuttableSpec.swift
//  Restables
//
//  Created by Ryan Baldwin on 2017-08-28.
//Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Quick
import Nimble
@testable import Restables

struct PutPersonRequest: Puttable {
    typealias ResponseType = Person
    var path = "/"
}

struct EncodablePutPersonRequest: Encodable {
    var personId: String
}
extension EncodablePutPersonRequest: Puttable {
    typealias ResponseType = Person
    var path: String { return "/" }
}

class PuttableSpec: QuickSpec {
    override func spec() {
        describe("A default Puttable") {
            var context: [String: Any]!
            
            beforeEach {
                context = ["method": HTTPMethod.put,
                           "restable": AnyRestable<Person>(PutPersonRequest()),
                           "encodable": AnyRestable<Person>(EncodablePutPersonRequest(personId: "123"))]
            }
            
            itBehavesLike("a Restable") { context }
        }
    }
}
