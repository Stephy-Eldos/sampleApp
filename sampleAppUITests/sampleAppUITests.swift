//
//  sampleAppUITests.swift
//  sampleAppUITests
//
//  Created by Eldos Thomas on 4/7/22.
//

import XCTest

class sampleAppUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()

        let element = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element
        XCTAssertTrue(element.exists)
        
        element.tap()
        element.tap()
        element.tap()
        element.tap()
        element.tap()
        element.tap()
        
        let cell = app.collectionViews.containing(.other, identifier:"Vertical scroll bar, 5 pages").children(matching: .cell).element
        XCTAssertTrue(cell.exists)
        
        cell.swipeRight()
        cell.swipeRight()
        cell.swipeLeft()

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
