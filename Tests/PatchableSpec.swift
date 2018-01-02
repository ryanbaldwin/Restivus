//
//  PatchableSpec.swift
//  Restivus
//
//  Created by Ryan Baldwin on 2017-08-28.
//Copyright © 2017 bunnyhug.me. All rights governed under the Apache 2 License Agreement
//

import Quick
import Nimble
@testable import Restivus

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
