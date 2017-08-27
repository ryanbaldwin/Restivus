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
                context("when submitted") {
                    var requestable: OtherErrorRestable!
                    
                    beforeEach {
                        requestable = OtherErrorRestable()
                    }
                    
                    it("throws if it fails to create the request") {
                        expect { try NoRequestRestable().submit() }.to(throwError())
                    }
                    
                    it("completes with an HTTPError.other if an error occured.") {
                        var error: HTTPError?
                        requestable.dataTaskCompletionHandler(data: nil, response: HTTPURLResponse(), error: HTTPError.noData) {
                            if case let Result.failure(err) = $0 { error = err }
                        }
                        expect(error).toEventually(equal(HTTPError.other(HTTPError.noData)))
                    }
                    
                    it("completes with HTTPError.noResponse when the server does not respond.") {
                        var error: HTTPError?
                        requestable.dataTaskCompletionHandler(data: Data(), response: nil, error: nil) {
                            if case let Result.failure(err) = $0 { error = err }
                        }
                        
                        expect(error).toEventually(equal(HTTPError.noResponse))
                    }
                    
                    it("completes with HTTPError.unexpectedResponse when the URLResponse is not an HTTPURLResponse") {
                        var error: HTTPError?
                        let response = URLResponse()
                        requestable.dataTaskCompletionHandler(data: Data(), response: response, error: nil) {
                            if case let Result.failure(err) = $0 { error = err }
                        }
                        
                        expect(error).toEventually(equal(HTTPError.unexpectedResponse(response)))
                    }
                    
                    it("completes with HTTPError.unsuccessfulResponse when the response code is not a 2xx") {
                        var error: HTTPError?
                        let response = HTTPURLResponse(url: URL(string: "google.ca")!, statusCode: 403, httpVersion: nil, headerFields: nil)!
                        requestable.dataTaskCompletionHandler(data: Data(), response: response, error: nil) {
                            if case let Result.failure(err) = $0 { error = err }
                        }
                        
                        expect(error).toEventually(equal(HTTPError.unsuccessfulResponse(response)))
                    }
                }
            }
        }
    }
}
