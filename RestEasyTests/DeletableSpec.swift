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
        describe("A default Deletable") {
            context("when encodable") {
                it("creates a DELETE request with itself as the body") {
                    let req = try? EncodableDeletePersonRequest(personId: "123").request()
                    expect(req).toNot(beNil())
                    expect(req?.httpMethod) == HTTPMethod.delete.rawValue
                    expect(String(data: req!.httpBody!, encoding: .utf8)) == "{\"personId\":\"123\"}"
                }
            }
            
            it("creates a DELETE request") {
                expect { try DeletePersonRequest().request().httpMethod }.to(equal(HTTPMethod.delete.rawValue))
            }
        }
    }
}
