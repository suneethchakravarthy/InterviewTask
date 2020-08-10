//
//  TransformersTests.swift
//  TransformersTests
//
//  Created by Suneeth on 8/6/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import XCTest
@testable import Transformers

class TransformersTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    // MARK - API Unit Testcases
    func testAppSpark() {
        let tokenExpectation = expectation(description: "Fetch token")
        TransformersHandler().getAllSpark { (token, error) in
            if error != nil { XCTFail("Error in all spark API") }
            if (token?.count ?? 0) > 0 { tokenExpectation.fulfill() }
        }
        waitForExpectations(timeout: 20)
    }
    func testGetTransformers() {
        let transformerListExpectation = expectation(description: "Fetch Transformer List")
        TransformersHandler().getTransformers(completion: { (value, error) in
            if error != nil { XCTFail("Error in get transformers API") }
            else if value != nil { transformerListExpectation.fulfill() }
        })
        waitForExpectations(timeout: 20)
    }
    func testCreateTransformer() {
        let createTransformerExpectation = expectation(description: "Create Transformer")
        let newObjectDictionary = [TechSpecs.name.rawValue:"name", TechSpecs.team.rawValue: Constants.TeamCode.autobot, TechSpecs.strength.rawValue: "1", TechSpecs.intelligence.rawValue: "2",
                                   TechSpecs.speed.rawValue:"3", TechSpecs.endurance.rawValue: "4",
                                   TechSpecs.rank.rawValue:"5", TechSpecs.courage.rawValue: "6",
                                   TechSpecs.firepower.rawValue:"7", TechSpecs.skill.rawValue:"8"]
        TransformersHandler().createTransformer(with: newObjectDictionary, completion: { (value, error) in
            if error != nil { XCTFail("Error in Create transformer API") }
            else if value != nil { createTransformerExpectation.fulfill() }
        })
        waitForExpectations(timeout: 20)
    }
    func testUpdateTransformer() {
        let updateTransformerExpectation = expectation(description: "Update Transformer")
        TransformersHandler().getTransformers(completion: { (value, error) in
            if error != nil { XCTFail("Error in get transformers API") }
            else if value != nil {
                if (value?.transformers?.count ?? 0) > 0 {
                    let firstTransformer = value?.transformers?[0]
                    let updateObjectDictionary = [TechSpecs.name.rawValue:"update", TechSpecs.team.rawValue: Constants.TeamCode.decepticon, TechSpecs.strength.rawValue: "2", TechSpecs.intelligence.rawValue: "3",
                                               TechSpecs.speed.rawValue:"3", TechSpecs.endurance.rawValue: "7",
                                               TechSpecs.rank.rawValue:"5", TechSpecs.courage.rawValue: "10",
                                               TechSpecs.firepower.rawValue:"7", TechSpecs.skill.rawValue:"6"]

                    TransformersHandler().updateTransformer(transformerId: firstTransformer?.id ?? "", dataDictionary: updateObjectDictionary, completion: { (value, error) in
                        if error != nil { XCTFail("Error in Update transformer API") }
                        else if value != nil { updateTransformerExpectation.fulfill() }
                    })
                } else {
                    XCTAssertEqual((value?.transformers?.count ?? 0), 0, "No records found to update")
                    updateTransformerExpectation.fulfill()
                }
            }
        })
        waitForExpectations(timeout: 20)
    }
    func testDeleteTransformer() {
        let deleteTransformerExpectation = expectation(description: "Delete Transformer")
        TransformersHandler().getTransformers(completion: { (value, error) in
            if error != nil { XCTFail("Error in get transformers API") }
            else if value != nil {
                if (value?.transformers?.count ?? 0) > 0 {
                    let firstTransformer = value?.transformers?[0]
                    
                    TransformersHandler().deleteTransformer(transformerId: firstTransformer?.id ?? "",
                                                            completion: { (value, error) in
                        if error != nil { XCTFail("Error in Delete transformer API") }
                        else if value != nil { deleteTransformerExpectation.fulfill() }
                    })
                } else {
                    XCTAssertEqual((value?.transformers?.count ?? 0), 0, "No records found to delete")
                    deleteTransformerExpectation.fulfill()
                }
            }
        })
        waitForExpectations(timeout: 20)
    }
}
