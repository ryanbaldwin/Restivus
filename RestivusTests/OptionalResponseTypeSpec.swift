//
//  OptionalResponseTypeSpec.swift
//  Restivus
//
//  Created by Ryan Baldwin on 2017-09-29.
//Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Quick
import Nimble
@testable import Restivus

struct OptionalResponseRequest: Gettable {
    typealias ResponseType = OptionalResponseType<Person>
    let baseURL = "https://www.google.ca"
    let path = ""
}

class OptionalResponseTypeSpec: QuickSpec {
    override func spec() {
        describe("A request which uses an OptionalResponseType") {
            it("Returns a container without response if the response didn't contain the resource.") {
                let request = OptionalResponseRequest()
                let urlResponse = HTTPURLResponse(url: URL(string: request.baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
                var typedResponse: OptionalResponseType<Person>?
                
                OptionalResponseRequest().dataTaskCompletionHandler(data: nil, response: urlResponse, error: nil) {
                    result in
                    if case let Result.success(optionalResponse) = result {
                        typedResponse = optionalResponse
                    }
                }
                
                expect(typedResponse).toEventuallyNot(beNil())
                expect(typedResponse?.response).toEventually(beNil())
            }
        }
    }
}
