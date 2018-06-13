//
//  ResultFormatSpec.swift
//  Restivus
//
//  Created by Ryan Baldwin on 2018-04-25.
//Copyright © 2018 bunnyhug.me. All rights reserved.
//

import Quick
import Nimble
@testable import Restivus

class ResultFormatSpec: QuickSpec {
    override func spec() {
        describe("A JSON ResultFormat") {
            it("defaults to using deferredToDate for all JSON Date Decoding") {
                let currentDate = Date()
                
                do {
                    let data = try JSONEncoder().encode(["date": currentDate])
                    
                    let deserializedData = try ResultFormat.json.decode(result: data, as: [String: Date].self)
                    expect(deserializedData["date"]) == currentDate
                } catch let error {
                    fail("\(error)")
                }
            }
            
            it("uses the provided DateDecodingStrategy") {
                let currentDate = Date()
                
                do {
                    let encoder = JSONEncoder()
                    encoder.dateEncodingStrategy = .millisecondsSince1970
                    let data = try encoder.encode(["date": currentDate])
                    
                    let deserializedData = try ResultFormat.json.decode(result: data, as: [String: Date].self,
                                                                        dateDecodingStrategy: .millisecondsSince1970)
                    let currentComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                                            from: currentDate)
                    let actualComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                                           from: deserializedData["date"]!)
                    expect(currentComponents) == actualComponents
                } catch let error {
                    fail("\(error)")
                }
            }
            
            it("uses the custom date formatters") {
                let currentDateString = "2018-06-12T20:00:00.000-04:00"
                
                let formatter = DateFormatter()                
                formatter.calendar = Calendar(identifier: .iso8601)
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
                
                let currentDate = formatter.date(from: currentDateString)!
                
                do {
                    let encoder = JSONEncoder()
                    encoder.dateEncodingStrategy = .formatted(formatter)
                    let data = try encoder.encode(["date": currentDateString])
                    
                    let deserializedData = try ResultFormat.json.decode(result: data, as: [String: Date].self,
                                                                        dateDecodingStrategy: .formatted(formatter))
                    let currentComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                                            from: currentDate)
                    let actualComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                                           from: deserializedData["date"]!)
                    expect(currentComponents) == actualComponents
                } catch let error {
                    fail("\(error)")
                }
            }
        }
    }
}
