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

	//Icons structure Tests
    func testIconsStructureHasCorrectValues() {
        XCTAssertEqual(Icons.logoIcon,	UIImage(named: "logoIcon"))
    }
	
	//PlaceHolders structure Tests
	func testPlaceholdersnHasCorrectString() {
		XCTAssertEqual(Placeholder.nicknameRegistration,	"Enter your nickname")
		XCTAssertEqual(Placeholder.emailRegistration,		"Enter your e-mail")
		XCTAssertEqual(Placeholder.passwordRegistration,	"Enter your password")
		XCTAssertEqual(Placeholder.titleForSingUp,			"Sing up")
	}
	
	//BorderWidth structure tests
	func testBorderWidthHasCorrectValues() {
		XCTAssertEqual(BorderWidth.forButton,			CGFloat(1))
		XCTAssertEqual(BorderWidth.forTextField,		CGFloat(0.5))
	}
	
	//CornerRadius structure tests
	func testCornerRadiusStructHasCorrectValue() {
		
	}
	
	//Fonts structure tests
	func testFontsStructHasCorrectValues() {
		XCTAssertEqual(Fonts.placeHolders,				UIFont(name: "SFProDisplay-Medium",  size: 20))
		XCTAssertEqual(Fonts.titleButton,				UIFont(name: "SFProRounded-Regular", size: 24))
	}
	
	//Colors structure tests
	func testColorsStructHasCorrectValues() {
		XCTAssertEqual(Colors.normalTextField,			UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1))
		XCTAssertEqual(Colors.normalBorderTextField,	UIColor(red: 0.82, green: 0.82, blue: 0.839, alpha: 1))
		XCTAssertEqual(Colors.titleButton,				UIColor(red: 0.265, green: 0.102, blue: 0.613, alpha: 1))
		XCTAssertEqual(Colors.backgroundUpButton,		UIColor(red: 0.584, green: 0.475, blue: 0.820, alpha: 1))
		XCTAssertEqual(Colors.backgroundDownButton,		UIColor(red: 0.745, green: 0.616, blue: 0.875, alpha: 1))
		XCTAssertEqual(Colors.borderButton,				UIColor(red: 0.265, green: 0.102, blue: 0.613, alpha: 1))
	}
}
