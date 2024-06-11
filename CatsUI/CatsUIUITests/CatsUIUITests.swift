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

    @MainActor func testExample() throws {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        
        snapshot("KaterynaVerkhohliad_MainScreen")

        let alertCaption = "Allow crashlitic reports?"
        if (app.alerts[alertCaption].exists) {
            app.alerts[alertCaption].scrollViews.otherElements.buttons["Allow"].tap()
        }
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons.element(boundBy: 1).tap()
        
        snapshot("KaterynaVerkhohliad_DetailsScreen")
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
