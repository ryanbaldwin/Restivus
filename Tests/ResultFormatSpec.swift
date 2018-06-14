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
        }
    }
}
