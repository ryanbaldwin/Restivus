//
//  GettableSpec.swift
//  Restivus
//
//  Created by Ryan Baldwin on 2017-08-28.
//Copyright © 2017 bunnyhug.me. All rights governed under the Apache 2 License Agreement
//

import Quick
import Nimble
@testable import Restivus

extension Gettable {
    var baseURL: String {
        return "http://google.ca"
    }
}

struct GetPersonRequest: Authenticating, Gettable {
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
