//
//  HTTPMethodSpec.swift
//  Restivus
//
//  Created by Ryan Baldwin on 2017-08-23.
//Copyright © 2017 bunnyhug.me. All rights governed under the Apache 2 License Agreement
//

import Quick
import Nimble
@testable import Restivus

private class NonEncodableRestable: Restable {
    typealias ResponseType = Person
    func request() throws -> URLRequest {
        assert(false, "This should not be called as part of these tests.")
    }
}

private class EncodableRestable: NonEncodableRestable, Encodable {}

class HTTPMethodSpec: QuickSpec {
    override func spec() {
        describe("an HTTPMethod") {
            context("when dealing with non-encodable restable") {
                context("and URL is present") {
                    context("when .post") {
                        itBehavesLike("an HTTP request without data"){ [
                            "restable": AnyRestable<Person>(NonEncodableRestable()),
                            "method": HTTPMethod.post] }
                    }
                    context("when .get") {
                        itBehavesLike("an HTTP request without data"){ [
                            "restable": AnyRestable<Person>(NonEncodableRestable()),
                            "method": HTTPMethod.get] }
                    }
                    
                    context("when .put") {
                        itBehavesLike("an HTTP request without data"){ [
                            "restable": AnyRestable<Person>(NonEncodableRestable()),
                            "method": HTTPMethod.put] }
                    }
                    
                    context("when .patch") {
                        itBehavesLike("an HTTP request without data"){ [
                            "restable": AnyRestable<Person>(NonEncodableRestable()),
                            "method": HTTPMethod.patch] }
                    }
                    
                    context("when .delete") {
                        itBehavesLike("an HTTP request without data"){ [
                            "restable": AnyRestable<Person>(NonEncodableRestable()),
                            "method": HTTPMethod.delete] }
                    }
                }
            }
            
            it("can determine its equality") {
                expect(HTTPMethod.get).toNot(equal(HTTPMethod.put))
                expect(HTTPMethod.get).to(equal(HTTPMethod.get))
            }
        }
    }
}
