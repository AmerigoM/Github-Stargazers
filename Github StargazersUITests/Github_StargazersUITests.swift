//
//  Github_StargazersUITests.swift
//  Github StargazersUITests
//
//  Created by Amerigo Mancino on 29/10/2020.
//

import XCTest

class Github_StargazersUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGoToSecondScreen() throws {
        let app = XCUIApplication()
        app.launch()
        
        let ownerTextField = app.textFields["ownerTextField"]
        ownerTextField.tap()
        ownerTextField.typeText("AmerigoM")
        
        let repositoryTextField = app.textFields["repositoryTextField"]
        repositoryTextField.tap()
        repositoryTextField.typeText("Clima")
        
        app.buttons["SearchButton"].tap()
        sleep(5)
        
        XCTAssertFalse(app.buttons["SearchButton"].exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
