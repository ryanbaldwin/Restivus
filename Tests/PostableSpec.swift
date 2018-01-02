//
//  PostableSpec.swift
//  Restivus
//
//  Created by Ryan Baldwin on 2017-08-28.
//Copyright © 2017 bunnyhug.me. All rights governed under the Apache 2 License Agreement
//

import Quick
import Nimble
@testable import Restivus

class PostableSpec: QuickSpec {
    override func spec() {
        describe("A default Postable") {
            var context: [String: Any]!
            
            beforeEach {
                context = ["method": HTTPMethod.post,
                           "restable": AnyRestable<Person>(PostPersonRequest()),
                           "encodable": AnyRestable<Person>(EncodablePostPersonRequest(personId: "123"))]
            }
            
            itBehavesLike("a Restable") { context }
        }
    }
}
