//
//  RestableSpec.swift
//  RestEasy
//
//  Created by Ryan Baldwin on 2017-08-24.
//Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Quick
import Nimble
@testable import RestEasy

class RestableSpec: QuickSpec {
    override func spec() {
        describe("A Restable") {
            describe("its default implementation") {
                it("throws if it fails to create the request") {
                    expect { try NoRequestRestable().submit() }.to(throwError())
                }
            }
        }
    }
}
