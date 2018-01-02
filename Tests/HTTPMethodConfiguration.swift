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

class NonEncodableHTTPMethodConfiguration: QuickConfiguration {
    override class func configure(_ configuration: Configuration) {
        sharedExamples("an HTTP request without data"){ (sharedExampleContext: @escaping SharedExampleContext) in
            var restable: NonEncodableRestable!
            var method: HTTPMethod!
            
            beforeEach {
                restable = NonEncodableRestable()
                method = sharedExampleContext()["method"] as! HTTPMethod
            }
            
            context("when URL is present") {
                it("uses the URL instead of a baseURL and path") {
                    let url = URL(string: "https://google.ca")!
                    restable.url = url
                    restable.baseURL = "http://foo.com"
                    restable.path = "/path"
                    
                    let request = try! method.makeURLRequest(for: restable)
                    expect(request.url?.absoluteString) == url.absoluteString
                    expect(request.httpMethod) == method.rawValue
                }
            }
            
            context("when no URL is present") {
                it("uses the baseURL and path") {
                    restable.baseURL = "http://httpstat.us"
                    restable.path = "/200"
                    let request = try! method.makeURLRequest(for: restable)
                    expect(request.url?.absoluteString) == restable.fullPath
                }
                
                it("raises an error when an incorrect URL is present") {
                    restable.baseURL = "as^^f://"
                    restable.path = "200"
                    expect { try method.makeURLRequest(for: restable) }.to(throwError())
                }
            }
            
            it("does not include anything in the http body") {
                let url = URL(string: "http://foo.com")!
                restable.url = url
                let request = try! method.makeURLRequest(for: restable)
                expect(request.httpBody).to(beNil())
            }
        }
    }
}

class EncodableHTTPMethodConfiguration: QuickConfiguration {
    override class func configure(_ configuration: Configuration) {
        sharedExamples("an HTTP request with data") { (sharedExampleContext: @escaping SharedExampleContext) in
            var restable: EncodableRestable!
            var method: HTTPMethod!
            
            beforeEach {
                restable = EncodableRestable()
                restable.url = URL(string: "https://www.google.ca")
                method = sharedExampleContext()["method"] as! HTTPMethod
            }
            
            it("submits data if provided") {
                let request = try! method.makeURLRequest(for: restable)
                expect(request.url?.absoluteString) == restable.url!.absoluteString
                expect(request.httpMethod) == method.rawValue
                expect(request.httpBody).toNot(beNil())
            }
        }
    }
}
