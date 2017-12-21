//
//  HttpErrorSpec.swift
//  Restivus
//
//  Created by Ryan Baldwin on 2017-08-24.
//Copyright © 2017 bunnyhug.me. All rights governed under the Apache 2 License Agreement
//

import Quick
import Nimble
@testable import Restivus

class HttpErrorSpec: QuickSpec {
    override func spec() {
        describe("An HttpError") {
            describe("its equality") {
                it("is not equal if not the same errors") {
                    expect(HTTPError.other(HTTPError.noResponse, Data())).toNot(equal(HTTPError.noResponse))
                    expect(HTTPError.noResponse) == HTTPError.noResponse
                }
                
                it("considers URLResponse when comparing unexpectedResponse") {
                    let response1 = URLResponse()
                    let response2 = URLResponse()
                    let data1 = "{\"message\": \"data1\"}".data(using: .utf8)
                    let data2 = "{\"message\": \"data2\"}".data(using: .utf8)
                    expect(HTTPError.unexpectedResponse(response1, data1)).toNot(equal(HTTPError.unexpectedResponse(response2, data2)))
                    expect(HTTPError.unexpectedResponse(response1, data1)).to(equal(HTTPError.unexpectedResponse(response1, data1)))
                }
                
                it("considers HTTPURLResponses when comparing unsuccessfulResponses") {
                    let url = URL(string: "http://google.ca")
                    let response1 = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                    let response2 = HTTPURLResponse(url: url!, statusCode: 204, httpVersion: nil, headerFields: nil)!
                    let data1 = "{\"message\": \"data1\"}".data(using: .utf8)
                    let data2 = "{\"message\": \"data2\"}".data(using: .utf8)
                    expect(HTTPError.unsuccessfulResponse(response1, data1)).toNot(equal(HTTPError.unsuccessfulResponse(response2, data2)))
                    expect(HTTPError.unsuccessfulResponse(response1, data1)).to(equal(HTTPError.unsuccessfulResponse(response1, data1)))
                }
                
                it("does not consider internals when comparing unableTodeserializeJSON") {
                    let unable1 = HTTPError.unableToDeserializeJSON(error: HTTPError.other(HTTPError.noResponse, nil), data: nil)
                    let unable2 = HTTPError.unableToDeserializeJSON(error: HTTPError.noResponse, data: Data())
                    expect(unable1) == unable2
                }
                
                it("does not consider internal errors when comparing others") {
                    let data = Data()
                    let other1 = HTTPError.other(HTTPError.other(HTTPError.noResponse, nil), data)
                    let other2 = HTTPError.other(HTTPError.noResponse, data)
                    expect(other1) == other2
                }
            }
        }
    }
}
