//
//  HttpErrorSpec.swift
//  RestEasy
//
//  Created by Ryan Baldwin on 2017-08-24.
//Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Quick
import Nimble
@testable import RestEasy

class HttpErrorSpec: QuickSpec {
    override func spec() {
        describe("An HttpError") {
            describe("its equality") {
                it("is not equal if not the same errors") {
                    expect(HttpError.noRequest).toNot(equal(HttpError.noResponse))
                    expect(HttpError.noResponse) == HttpError.noResponse
                    expect(HttpError.noRequest) == HttpError.noRequest
                }
                
                it("considers URLResponse when comparing unexpectedResponse") {
                    let response1 = URLResponse()
                    let response2 = URLResponse()
                    expect(HttpError.unexpectedResponse(response1)).toNot(equal(HttpError.unexpectedResponse(response2)))
                    expect(HttpError.unexpectedResponse(response1)).to(equal(HttpError.unexpectedResponse(response1)))
                }
                
                it("considers HTTPURLResponses when comparing unsuccessfulResponses") {
                    let url = URL(string: "http://google.ca")
                    let response1 = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                    let response2 = HTTPURLResponse(url: url!, statusCode: 204, httpVersion: nil, headerFields: nil)!
                    expect(HttpError.unsuccessfulResponse(response1)).toNot(equal(HttpError.unsuccessfulResponse(response2)))
                    expect(HttpError.unsuccessfulResponse(response1)).to(equal(HttpError.unsuccessfulResponse(response1)))
                }
                
                it("does not consider internals when comparing unableTodeserializeJSON") {
                    let unable1 = HttpError.unableToDeserializeJSON(error: HttpError.noRequest, data: nil)
                    let unable2 = HttpError.unableToDeserializeJSON(error: HttpError.noResponse, data: Data())
                    expect(unable1) == unable2
                }
                
                it("does not consider internals when comparing others") {
                    let other1 = HttpError.other(HttpError.noRequest)
                    let other2 = HttpError.other(HttpError.noResponse)
                    expect(other1) == other2
                }
            }
        }
    }
}
