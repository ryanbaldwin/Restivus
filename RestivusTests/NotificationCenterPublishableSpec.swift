//
//  NotificationCenterPublishableSpec.swift
//  Restivus
//
//  Created by Ryan Baldwin on 2017-09-30.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Quick
import Nimble
@testable import Restivus

/// A NotificationCenterPublishable Restable, suitable for testing, which always return true for `shouldPublish`
private struct PublishingRestable: Gettable, NotificationCenterPublishable {
    typealias ResponseType = Person
    func shouldPublish(_: HTTPURLResponse) -> Bool {
        return true
    }
}

/// A NotificationCenterPublishable Restable, suitable for testing, which always return false for `shouldPublish`
private struct NonPublishingRestable: Gettable, NotificationCenterPublishable {
    typealias ResponseType = Person
    func shouldPublish(_: HTTPURLResponse) -> Bool {
        return false
    }
}

private func makeURLResponse(_ statusCode: Int) -> HTTPURLResponse {
    return HTTPURLResponse(url: URL(string: "https://some.com")!, statusCode: statusCode,
                           httpVersion: nil, headerFields: nil)!
}

class NotificationCenterPublishableSpec: QuickSpec {
    override func spec() {
        describe("A NotificationCenterPublishable Restable") {
            var observer: NSObjectProtocol!
            var data: Data!
            var receivedNotification = false
            
            beforeEach {
                receivedNotification = false
                observer = NotificationCenter.default.addObserver(forName: .RestivusReceivedNon200,
                                                                  object: nil, queue: nil) { _ in
                    receivedNotification = true
                }
                data = try? JSONEncoder().encode(Person(firstName: "Ryan", lastName: "Baldwin", age: 38))
            }
            
            afterEach {
                NotificationCenter.default.removeObserver(observer)
                receivedNotification = false
            }
            
            context("when its shouldPublish returns true") {
                let request = PublishingRestable()
                
                it("publishes a notification for 1xx responses") {
                    request.dataTaskCompletionHandler(data: data, response: makeURLResponse(100), error: nil, completion: nil)
                    expect(receivedNotification).toEventually(beTrue())
                }
                
                it("does not publish a notification for 2xx responses") {
                    request.dataTaskCompletionHandler(data: data, response: makeURLResponse(204), error: nil, completion: nil)
                    expect(receivedNotification).toEventually(beFalse())
                }
                
                it("publishes a notification for 3xx responses") {
                    request.dataTaskCompletionHandler(data: data, response: makeURLResponse(302), error: nil, completion: nil)
                    expect(receivedNotification).toEventually(beTrue())
                }
                
                it("publishes a notification for 4xx responses") {
                    request.dataTaskCompletionHandler(data: data, response: makeURLResponse(404), error: nil, completion: nil)
                    expect(receivedNotification).toEventually(beTrue())
                }
                
                it("publishes a notification for 5xx responses") {
                    request.dataTaskCompletionHandler(data: data, response: makeURLResponse(500), error: nil, completion: nil)
                    expect(receivedNotification).toEventually(beTrue())
                }
            }
            
            context("when its shouldPublish returns false") {
                let request = NonPublishingRestable()
                
                it("does not publish a notification for 1xx responses") {
                    request.dataTaskCompletionHandler(data: data, response: makeURLResponse(100), error: nil, completion: nil)
                    expect(receivedNotification).toEventually(beFalse(), timeout: 1)
                }
                
                it("does not publish a notification for 2xx responses") {
                    request.dataTaskCompletionHandler(data: data, response: makeURLResponse(204), error: nil, completion: nil)
                    expect(receivedNotification).toEventually(beFalse(), timeout: 1)
                }
                
                it("does not publish a notification for 3xx responses") {
                    request.dataTaskCompletionHandler(data: data, response: makeURLResponse(302), error: nil, completion: nil)
                    expect(receivedNotification).toEventually(beFalse(), timeout: 1)
                }
                
                it("does not publish a notification for 4xx responses") {
                    request.dataTaskCompletionHandler(data: data, response: makeURLResponse(404), error: nil, completion: nil)
                    expect(receivedNotification).toEventually(beFalse(), timeout: 1)
                }
                
                it("does not publish a notification for 5xx responses") {
                    request.dataTaskCompletionHandler(data: data, response: makeURLResponse(500), error: nil, completion: nil)
                    expect(receivedNotification).toEventually(beFalse(), timeout: 1)
                }
            }
        }
    }
}
