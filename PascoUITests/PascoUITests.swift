//
//  PascoUITests.swift
//  PascoUITests
//
//  Created by Denis on 3/8/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import XCTest

class PascoUITests: XCTestCase {
    let app = XCUIApplication()

//    override func setUp() {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//
//        // In UI tests it is usually best to stop immediately when a failure occurs.
//        continueAfterFailure = false
//
//        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
//    }
//
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sleep(5)
        app.navigationBars["Account"].buttons["Sign out"].twoFingerTap()
    }


    func testSignIn() {
        // UI tests must launch the application that they test.
        func fill(fieldName: String, value: String, secure: Bool) {
            let field = secure ? app.secureTextFields[fieldName] : app.textFields[fieldName]
            field.tap()
            field.typeText(value)
        }
        let app = XCUIApplication()
        app.launch()
        
        app.tabBars["Tab Bar"].buttons["Account"].tap()
        app.buttons["SIGN IN"].tap()

        fill(fieldName: "Email", value: "snizzer0001@yahoo.com", secure: false)
        fill(fieldName: "Password", value: "SuperPassword!1", secure: true)

        let button = app.buttons["SIGN IN"]
        button.tap()
        
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.


        
        
    }

//    func testLaunchPerformance() {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
