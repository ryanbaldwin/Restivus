//
//  DeletableSpec.swift
//  Restivous
//
//  Created by Ryan Baldwin on 2017-08-25.
//Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Quick
import Nimble
@testable import Restivous

struct DeletePersonRequest: Deletable {
    typealias ResponseType = Person
    var path = "/"
}

struct EncodableDeletePersonRequest: Encodable {
    var personId: String
}
extension EncodableDeletePersonRequest: Deletable {
    typealias ResponseType = Person
    var path: String { return "/" }
}

class DeletableSpec: QuickSpec {
    override func spec() {
        describe("A default Deletable") {
            var context: [String: Any]!
            
            beforeEach {
                context = ["method": HTTPMethod.delete,
                           "restable": AnyRestable<Person>(DeletePersonRequest()),
                           "encodable": AnyRestable<Person>(EncodableDeletePersonRequest(personId: "123"))]
            }
            
            itBehavesLike("a Restable") { context }
        }
    }
}
