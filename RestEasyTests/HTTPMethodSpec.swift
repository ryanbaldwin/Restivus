//
//  HTTPMethodSpec.swift
//  RestEasy
//
//  Created by Ryan Baldwin on 2017-08-23.
//Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Quick
import Nimble
@testable import RestEasy

fileprivate let url = "http://some.domain.com/some/path"

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
        }
    }
}
