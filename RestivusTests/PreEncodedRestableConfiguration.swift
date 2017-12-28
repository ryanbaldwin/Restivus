//
//  PreEncodedRestableConfiguration.swift
//  Restivus
//
//  Created by Ryan Baldwin on 2017-12-27.
//Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Quick
import Nimble
@testable import Restivus

class PreEncodedRestableConfiguration: QuickConfiguration {
    override class func configure(_ configuration: Configuration) {
        sharedExamples("a PreEncoded Restable") { (sharedExampleContext: @escaping SharedExampleContext) in
            var restable: AnyRestable<Raw>!
            var expectedData: Data!
            
            beforeEach {
                restable = sharedExampleContext()["restable"] as! (AnyRestable<Raw>)
                expectedData = sharedExampleContext()["expectedData"] as! Data
            }
            
            it("populates the body with whatever the request's data is") {
                let request = try? restable.request()
                expect(request?.httpBody) == expectedData
            }
        }
    }
}
