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

struct PostPersonRequest: Authenticating, Postable {
    typealias ResponseType = Person
    let path = "/"
}

struct EncodablePostPersonRequest: Encodable {
    var personId: String
}
extension EncodablePostPersonRequest: Postable {
    typealias ResponseType = Person
    var path: String { return "/" }
}

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
