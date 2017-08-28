//
//  PatchableSpec.swift
//  Restables
//
//  Created by Ryan Baldwin on 2017-08-28.
//Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Quick
import Nimble
@testable import Restables

struct PatchPersonRequest: Patchable {
    typealias ResponseType = Person
    var path = "/"
}

struct EncodablePatchPersonRequest: Encodable {
    var personId: String
}
extension EncodablePatchPersonRequest: Patchable {
    typealias ResponseType = Person
    var path: String { return "/" }
}

class PatchableSpec: QuickSpec {
    override func spec() {
        describe("A default Patchable") {
            var context: [String: Any]!
            
            beforeEach {
                context = ["method": HTTPMethod.patch,
                           "restable": AnyRestable<Person>(PatchPersonRequest()),
                           "encodable": AnyRestable<Person>(EncodablePatchPersonRequest(personId: "123"))]
            }
            
            itBehavesLike("a Restable") { context }
        }
    }
}
