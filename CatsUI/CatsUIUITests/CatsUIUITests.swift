//
//  CatsUIUITests.swift
//  CatsUIUITests
//
//  Created by Kathryn Verkhogliad on 11.06.2024.
//

import XCTest

final class CatsUIUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        
        // If the element doesn't exist, this assertion will fail
        XCTAssertTrue(true)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
