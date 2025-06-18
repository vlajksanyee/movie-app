//
//  MainTabView+UI.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 06. 17..
//

import XCTest

final class MainTabViewUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testBasicUsage() throws {
        // UI tests must launch the application that they test.
        
        app.images["search"].tap()
        app.images["favorites"].tap()
        app.images["settings"].tap()
        app.images["genre"].tap()
        
    }
}
