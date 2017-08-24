//
//  RestableConfiguration.swift
//  RestEasy
//
//  Created by Ryan Baldwin on 2017-08-22.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Quick
import Nimble

class RestableConfiguration: QuickConfiguration {
    override class func configure(_ configuration: Configuration) {
        sharedExamples("a Restable"){ (sharedExampleContext: @escaping SharedExampleContext) in
            var request: URLRequest!
            
            beforeEach {
                request = sharedExampleContext()["request"] as! URLRequest
            }
            
            it("accepts json") {
                expect(request.value(forHTTPHeaderField: "Accept")) == "application/json"
            }
            
            it("uses json for its content type") {
                expect(request.value(forHTTPHeaderField: "Content-Type")) == "application/json"
            }
        }
    }
}
