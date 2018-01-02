//
//  PreEncodedSpec.swift
//  Restivus
//
//  Created by Ryan Baldwin on 2017-12-27.
//Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Quick
import Nimble
import Restivus

class PreEncodedRestablesSpec: QuickSpec {
    override func spec() {
        describe("A PreEncoded Postable") {
            let postable = PreEncodedPostable()
            itBehavesLike("a PreEncoded Restable"){["restable": AnyRestable<Raw>(postable),
                                                    "expectedData": postable.data]}
        }
        
        describe("A PreEncoded Puttable") {
            let puttable = PreEncodedPuttable()
            itBehavesLike("a PreEncoded Restable"){["restable": AnyRestable<Raw>(puttable),
                                                    "expectedData": puttable.data]}
        }
        
        describe("A PreEncoded Gettable") {
            let gettable = PreEncodedGettable()
            itBehavesLike("a PreEncoded Restable"){["restable": AnyRestable<Raw>(gettable),
                                                    "expectedData": gettable.data]}
        }
        
        describe("A PreEncoded Patchable") {
            let patchable = PreEncodedPatchable()
            itBehavesLike("a PreEncoded Restable"){["restable": AnyRestable<Raw>(patchable),
                                                    "expectedData": patchable.data]}
        }
        
        describe("A PreEncoded Deletable") {
            let deletable = PreEncodedDeletable()
            itBehavesLike("a PreEncoded Restable"){["restable": AnyRestable<Raw>(deletable),
                                                    "expectedData": deletable.data]}
        }
    }
}
