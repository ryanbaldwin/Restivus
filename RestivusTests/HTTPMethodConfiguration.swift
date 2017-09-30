//
//  HTTPMethodConfiguration.swift
//  Restivus
//
//  Created by Ryan Baldwin on 2017-08-23.
//Copyright © 2017 bunnyhug.me. All rights governed under the Apache 2 License Agreement
//

import Quick
import Nimble
@testable import Restivus

class HTTPMethodConfiguration: QuickConfiguration {
    override class func configure(_ configuration: Configuration) {
        sharedExamples("an HTTP request without data"){ (sharedExampleContext: @escaping SharedExampleContext) in
            var restable: AnyRestable<Person>!
            var method: HTTPMethod!
            var request: URLRequest!
            
            beforeEach {
                restable = sharedExampleContext()["restable"] as! AnyRestable<Person>
                method = sharedExampleContext()["method"] as! HTTPMethod
                request = try! method.makeURLRequest(for: restable)
            }
            
            it("sets the correct HTTP method on the request") {
                expect(request.httpMethod) == method.rawValue
            }
            
//            it("creates the URL correctly") {
//                expect(request.url) == URL(string: url)
//            }
//
//            it("raises an error when an incorrect URL is present") {
//                expect { try method.makeURLRequest(url: invalidUrl) }.to(throwError())
//            }
//
//            it("submits data if provided") {
//                let person = Person(firstName: "Ryan", lastName: "Baldwin", age: 38)
//                let req = try! method.makeURLRequest(url: url, body: person)
//
//                expect(req.httpBody).toNot(beNil())
//                let decoded = try! JSONDecoder().decode(Person.self, from: req.httpBody!)
//                expect(decoded) == person
//            }
        }
    }
}
