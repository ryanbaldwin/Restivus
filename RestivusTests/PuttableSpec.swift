//
//  PuttableSpec.swift
//  Restivus
//
//  Created by Ryan Baldwin on 2017-08-28.
//Copyright © 2017 bunnyhug.me. All rights governed under the Apache 2 License Agreement
//

import Quick
import Nimble
@testable import Restivus

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
