//
//  IconsTests.swift
//  Knitting_2_0Tests
//
//  Created by Павел Кузин on 27.08.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import XCTest
@testable import Knitting_2_0

class ConstantsTests: XCTestCase {
    
    override func setUpWithError() throws {
        super.setUp()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIconsStructureHasLogoIcon() {
        XCTAssertEqual(Icons.logoIcon, UIImage(named: "logoIcon"))
    }
	
	func testPlaceholdersForNicknameRegistrationHasCorrectString() {
		XCTAssertEqual(Placeholder.nicknameRegistration, "Enter your nickname")
	}
	
	func testPlaceholdersForEmailRegistrationHasCorrectString() {
		XCTAssertEqual(Placeholder.emailRegistration, "Enter your e-mail")
	}
	
	func testPlaceholdersForPasswordRegistrationHasCorrectString() {
		XCTAssertEqual(Placeholder.passwordRegistration, "Enter your password")
	}
	
	func testFontsStructureHasCorrectFontsName() {
		XCTAssertEqual(Fonts.placeHolders, UIFont(name: "SFProDisplay-Medium", size: 20))
	}
}
