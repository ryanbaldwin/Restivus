//
//  AnyRestivuspec.swift
//  Restivus
//
//  Created by Ryan Baldwin on 2017-08-28.
//Copyright © 2017 bunnyhug.me. All rights governed under the Apache 2 License Agreement
//

import Quick
import Nimble
@testable import Restivus

class AnyRestableSpec: QuickSpec {
    override func spec() {
        describe("An AnyRestable") {
            var restable: AnyRestable<Person>!
            var encodableRestable: AnyRestable<Person>!
            
            beforeEach {
                restable = AnyRestable<Person>(GetPersonRequest())
                encodableRestable = AnyRestable<Person>(EncodableGetPersonRequest(personId: "123"))
            }
            
            it("can submit the request") {
                let restableError = try? restable.submit()
                let encodableError = try? encodableRestable.submit()
                
                expect(restableError).toNot(beNil())
                expect(encodableError).toNot(beNil())
            }
        }
    }
}
