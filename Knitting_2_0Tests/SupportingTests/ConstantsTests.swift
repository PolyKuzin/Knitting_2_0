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
        
		super.tearDown()
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
	
	func testNormalTextFieldColorIsCorrect() {
		XCTAssertEqual(Colors.normalTextField, UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1))
	}
	
	func testNormalTextFieldBorderColorIsCorrect() {
		XCTAssertEqual(Colors.normalTextFieldBorder, UIColor(red: 0.82, green: 0.82, blue: 0.839, alpha: 1))
	}
}
