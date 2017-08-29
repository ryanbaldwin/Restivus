//
//  GettableSpec.swift
//  Restivous
//
//  Created by Ryan Baldwin on 2017-08-28.
//Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Quick
import Nimble
@testable import Restivous

struct GetPersonRequest: Gettable {
    typealias ResponseType = Person
    var path = "/"
}

struct EncodableGetPersonRequest: Encodable {
    var personId: String
}
extension EncodableGetPersonRequest: Gettable {
    typealias ResponseType = Person
    var path: String { return "/" }
}

class GettableSpec: QuickSpec {
    override func spec() {
        describe("A default Gettable") {
            var context: [String: Any]!
            
            beforeEach {
                context = ["method": HTTPMethod.get,
                           "restable": AnyRestable<Person>(GetPersonRequest()),
                           "encodable": AnyRestable<Person>(EncodableGetPersonRequest(personId: "123"))]
            }
            
            itBehavesLike("a Restable") { context }
        }
    }
}
