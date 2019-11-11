//
//  FrisqStopwatchTests.swift
//  FrisqStopwatchTests
//
//  Created by joakim lundberg on 2019-11-10.
//  Copyright © 2019 joakim lundberg. All rights reserved.
//

import XCTest
@testable import FrisqStopwatch

class FrisqStopwatchTests: XCTestCase {
    var app: XCUIApplication!
    var sut: ViewController!
    
    override func setUp() {
        super.setUp()
        sut = ViewController()
        sut.startTimer()
    }

    override func tearDown() {
        sut = nil
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.launch()
        app.buttons["startButton"].tap()
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
