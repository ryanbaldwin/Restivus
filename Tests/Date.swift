//
//  Date.swift
//  Restivus-iOSTests
//
//  Created by Adrian de Almeida on 2018-06-14.
//  Copyright © 2018 bunnyhug.me. All rights reserved.
//

import Foundation
@testable import Restivus

struct DateResponse: Decodable {
    var date: Date
}

struct DateRequest: Gettable {
    public typealias ResponseType = DateResponse
    public var path: String { return "/test" }
    public var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        return .formatted(dateFormatter())
    }
}

extension DateRequest {
    func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }
}

