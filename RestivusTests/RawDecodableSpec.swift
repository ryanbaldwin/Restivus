//
//  RawDecodableSpec.swift
//  Restivous
//
//  Created by Ryan Baldwin on 2017-08-31.
//Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Quick
import Nimble
@testable import Restivous

struct RawDelete: Deletable {
    typealias ResponseType = Raw
    var resultFormat: ResultFormat = .raw
    var path: String = "/204"
}

struct GetGoogle: Gettable {
    typealias ResponseType = Raw
    var resultFormat: ResultFormat = .raw
    var baseURL = "http://www.google.ca"
    var path = "/"
}

class RawDecodableSpec: QuickSpec {
    override func spec() {
        describe("A Restable using Raw for Decodable") {
            it("can handle empty response body") {
                var data: Data?
                
                _ = try? RawDelete().submit {
                    if case let .success(responseData) = $0 {
                        data = responseData
                    }
                }
                
                expect(data).toEventuallyNot(beNil())
            }
            
            it("can handle non-empty response body") {
                var data: Data?
                
                _ = try? GetGoogle().submit {
                    if case let .success(responseData) = $0 {
                        data = responseData
                    }
                }
                
                expect(data).toEventuallyNot(beNil(), timeout: 3)
            }
        }
    }
}
