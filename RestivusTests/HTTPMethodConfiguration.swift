//
//  HTTPMethodConfiguration.swift
//  Restivous
//
//  Created by Ryan Baldwin on 2017-08-23.
//Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Quick
import Nimble
@testable import Restivous

class HTTPMethodConfiguration: QuickConfiguration {
    override class func configure(_ configuration: Configuration) {
        sharedExamples("an HTTPMethod"){ (sharedExampleContext: @escaping SharedExampleContext) in
            let url = "http://some.test.domain/some/path"
            let invalidUrl = "http://some`.test.c"
            var method: HTTPMethod!
            var request: URLRequest!
            
            beforeEach {
                method = sharedExampleContext()["method"] as! HTTPMethod
                request = try! method.makeURLRequest(url: url)
            }
            
            it("sets the correct HTTP method on the request") {
                expect(request.httpMethod) == method.rawValue
            }
            
            it("creates the URL correctly") {
                expect(request.url) == URL(string: url)
            }
            
            it("raises an error when an incorrect URL is present") {
                expect { try method.makeURLRequest(url: invalidUrl) }.to(throwError())
            }
            
            it("submits data  if provided") {
                let person = Person(firstName: "Ryan", lastName: "Baldwin", age: 38)
                let req = try! method.makeURLRequest(url: url, body: person)
                
                expect(req.httpBody).toNot(beNil())
                let decoded = try! JSONDecoder().decode(Person.self, from: req.httpBody!)
                expect(decoded) == person
            }
        }
    }
}
