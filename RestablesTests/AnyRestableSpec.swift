//
//  AnyRestableSpec.swift
//  Restables
//
//  Created by Ryan Baldwin on 2017-08-28.
//Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Quick
import Nimble
@testable import Restables

struct RequestDidSubmitError: Error {}

struct SafeSubmittablePersonRequest {}
extension SafeSubmittablePersonRequest: Gettable {
    typealias ResponseType = Person
    
    func submit(callbackOnMain: Bool, session: URLSession, completion: ((Result<Person>) -> Void)?) throws -> URLSessionDataTask {
        throw HTTPError.other(RequestDidSubmitError())
    }
}

class AnyRestableSpec: QuickSpec {
    override func spec() {
        describe("An AnyRestable") {
            var restable: AnyRestable<Person>!
            var encodableRestable: AnyRestable<Person>!
            
            beforeEach {
                restable = AnyRestable<Person>(GetPersonRequest())
                encodableRestable = AnyRestable<Person>(EncodableGetPersonRequest(personId: "123"))
            }
            
            it("can submit the request") {
                let restableError = try? restable.submit()
                let encodableError = try? encodableRestable.submit()
                
                expect(restableError).toNot(beNil())
                expect(encodableError).toNot(beNil())
            }
        }
    }
}
