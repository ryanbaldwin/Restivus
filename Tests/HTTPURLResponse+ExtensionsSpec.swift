//
//  HTTPURLResponse+ExtensionsSpec.swift
//  Restivus
//
//  Created by Ryan Baldwin on 2017-10-01.
//Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Quick
import Nimble

class HTTPURLResponse_ExtensionsSpec: QuickSpec {
    override func spec() {
        describe("HTTPURLResponse") {
            it("isInformational when statusCode is 1xx") {
                let response = makeURLResponse(102)
                expect(response.isInformational) == true
                expect(response.isSuccess) == false
                expect(response.isRedirection) == false
                expect(response.isClientError) == false
                expect(response.isServerError) == false
            }
            
            it("isSuccess when statusCode is 2xx") {
                let response = makeURLResponse(204)
                expect(response.isInformational) == false
                expect(response.isSuccess) == true
                expect(response.isRedirection) == false
                expect(response.isClientError) == false
                expect(response.isServerError) == false
            }
            
            it("isRedirection when statusCode is 3xx") {
                let response = makeURLResponse(302)
                expect(response.isInformational) == false
                expect(response.isSuccess) == false
                expect(response.isRedirection) == true
                expect(response.isClientError) == false
                expect(response.isServerError) == false
            }
            
            it("isClientError when statusCode is 4xx") {
                let response = makeURLResponse(401)
                expect(response.isInformational) == false
                expect(response.isSuccess) == false
                expect(response.isRedirection) == false
                expect(response.isClientError) == true
                expect(response.isServerError) == false
            }
            
            it("isServerError when statusCode is 5xx") {
                let response = makeURLResponse(500)
                expect(response.isInformational) == false
                expect(response.isSuccess) == false
                expect(response.isRedirection) == false
                expect(response.isClientError) == false
                expect(response.isServerError) == true
            }
        }
    }
}
