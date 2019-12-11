//
//  app_danceblueUITests.swift
//  app-danceblueUITests
//
//  Created by Blake Swaidner on 10/26/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import XCTest

class app_danceblueUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        setupSnapshot(XCUIApplication())
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFAQ() {
        
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Events"].tap()
        tabBarsQuery.buttons["Blog"].tap()
        tabBarsQuery.buttons["More"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["FAQs"]/*[[".cells.staticTexts[\"FAQs\"]",".staticTexts[\"FAQs\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
       
    }
    func testContact() {
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Events"].tap()
        tabBarsQuery.buttons["Blog"].tap()
        tabBarsQuery.buttons["More"].tap()
        app.tables.staticTexts["CONTACT"].tap()
    }
    
}
