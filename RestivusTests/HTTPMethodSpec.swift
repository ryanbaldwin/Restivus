//
//  HTTPMethodSpec.swift
//  Restivous
//
//  Created by Ryan Baldwin on 2017-08-23.
//Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Quick
import Nimble
@testable import Restivous

class HTTPMethodSpec: QuickSpec {
    override func spec() {
        describe("an HTTPMethod") {
            context("when .post") {
                itBehavesLike("an HTTPMethod"){ ["method": HTTPMethod.post] }
            }

            context("when .get") {
                itBehavesLike("an HTTPMethod"){ ["method": HTTPMethod.get] }
            }
            
            context("when .put") {
                itBehavesLike("an HTTPMethod"){ ["method": HTTPMethod.put] }
            }
            
            context("when .patch") {
                itBehavesLike("an HTTPMethod"){ ["method": HTTPMethod.patch] }
            }
            
            context("when .delete") {
                itBehavesLike("an HTTPMethod"){ ["method": HTTPMethod.delete] }
            }
            
            it("can determine its equality") {
                expect(HTTPMethod.get).toNot(equal(HTTPMethod.put))
                expect(HTTPMethod.get).to(equal(HTTPMethod.get))
            }
        }
    }
}
