//
//  DeletableSpec.swift
//  RestEasy
//
//  Created by Ryan Baldwin on 2017-08-25.
//Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Quick
import Nimble
@testable import RestEasy

class DeletableSpec: QuickSpec {
    override func spec() {
        xdescribe("A default Deletable") {
            itBehavesLike("a Restable") { ["restable": AnyRestable<Person>(DeletePersonRequest()),
                                           "encodable": AnyRestable<Person>(EncodableDeletePersonRequest(personId: "123")),
                                           "method": "Delete"] }
        }
    }
}
