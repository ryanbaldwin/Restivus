//
//  PostableSpec.swift
//  Restables
//
//  Created by Ryan Baldwin on 2017-08-28.
//Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Quick
import Nimble
@testable import Restables

struct PostPersonRequest: Postable {
    typealias ResponseType = Person
    var path = "/"
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
