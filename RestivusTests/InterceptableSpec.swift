//
//  InterceptableSpec.swift
//  Restivus
//
//  Created by Ryan Baldwin on 2017-12-16.
//Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Quick
import Nimble

class InterceptableSpec: QuickSpec {
    override func spec() {
        describe("An Interceptable request") {
            it("Can overwrite the Accept header") {
                let request = InterceptableRequest()
                var task: URLSessionDataTask!
                
                expect { task = try request.submit() }.toNot(throwError())
                task.cancel()
                expect(task.currentRequest).toNot(beNil())
                expect(task.currentRequest?.allHTTPHeaderFields?["Accept"]) == "ANYTHING-YOU-WANT"
            }
        }
    }
}
