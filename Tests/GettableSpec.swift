//
//  GettableSpec.swift
//  Restivus
//
//  Created by Ryan Baldwin on 2017-08-28.
//Copyright © 2017 bunnyhug.me. All rights governed under the Apache 2 License Agreement
//

import Quick
import Nimble
@testable import Restivus

extension Gettable {
    var baseURL: String {
        return "http://google.ca"
    }
}

class GettableSpec: QuickSpec {
    override func spec() {
        describe("A default Gettable") {
            var context: [String: Any]!
            
            beforeEach {
                context = ["method": HTTPMethod.get,
                           "restable": AnyRestable<Person>(GetPersonRequest()),
                           "encodable": AnyRestable<Person>(EncodableGetPersonRequest(personId: "123"))]
            }
            
            itBehavesLike("a Restable") { context }
        }
        
        describe("A gettable with a dateDecodingStrategy") {            
            it("It decodes the response data according to the dateDecodingStrategy") {
                let gettable = DateRequest()
                let currentDateString = "2018-06-12T20:00:00.000-04:00"
                let currentDate = gettable.dateFormatter().date(from: currentDateString)!
                
                let data = """
                { "date": "\(currentDateString)" }
                """.data(using: .utf8)!
                
                var dateResponse: DateResponse? = nil
                
                // NOTE: We use a dummy url response here as the `dataTaskCompletionHandler` needs it.
                // As long as this method gets a success statusCode (ie. 200) from an HTTPURLResponse, it will proceed to decode the data passed in.
                // We want to verify that it is decoding it according to the `dateDecodingStrategy` of the `DateRequest`
                let response = HTTPURLResponse(url: URL(string: "http://google.ca")!, statusCode: 200, httpVersion: nil, headerFields: nil)
                gettable.dataTaskCompletionHandler(data: data, response: response, error: nil) { response in
                    if case let .success(tempDateResponse) = response {
                        dateResponse = tempDateResponse
                    }
                }
                
                expect(dateResponse).toNot(beNil())
                
                // compare the dates
                let currentComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)
                let actualComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateResponse!.date)
                
                expect(currentComponents).toNot(beNil())
                expect(currentComponents) == actualComponents
            }
        }
    }
}
