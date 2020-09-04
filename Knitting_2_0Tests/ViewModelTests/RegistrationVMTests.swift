//
//  Knitting_2_0Tests.swift
//  Knitting_2_0Tests
//
//  Created by Павел Кузин on 27.08.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import XCTest
@testable import Knitting_2_0

class RegistrationVMTests: XCTestCase {

    var sut		: RegistrationVM!
	var view	: UIView!
    
    override func setUpWithError() throws {
        super.setUp()
        sut		= RegistrationVM()
		view	= UIView()
    }

    override func tearDownWithError() throws {
        
        super.tearDown()
    }

//MARK: Logo Icon Tests
    func testEntryVMContainsLogoIconView() {
        XCTAssertNotNil(sut.logoIcon)
    }
    
    func testLogoIconViewImageIsLogoIcon() {
        XCTAssertTrue(sut.logoIcon().image 				=== Icons.logoIcon)
    }

	func testLogoIconViewFrameIsCorrect() {
		XCTAssertEqual(sut.logoIcon().frame.width,		129.39)
		XCTAssertEqual(sut.logoIcon().frame.height,		154.89)
	}
	
//MARK: Nickname TextField Tests
	func testEntryVMContainsNickNameTextField() {
        XCTAssertNotNil(sut.nickname())
		XCTAssertNotNil(sut.email())
        XCTAssertNotNil(sut.password())
		XCTAssertNotNil(sut.signUp())
	}
	
	func testNicknameTextFieldFrameIsCorrect() {
		XCTAssertEqual(sut.nickname().frame.width,	382)
		XCTAssertEqual(sut.nickname().frame.height,	62)
		
		XCTAssertEqual(sut.email().frame.width,		382)
		XCTAssertEqual(sut.email().frame.height,	62)
		
		XCTAssertEqual(sut.password().frame.width,	382)
		XCTAssertEqual(sut.password().frame.height,	62)
		
		XCTAssertEqual(sut.signUp().frame.width, 265)
		XCTAssertEqual(sut.signUp().frame.height, 50)
	}
	
	func testNicknameTextFieldHasCorrectCornerRadius() {
		XCTAssertEqual(sut.nickname().layer.cornerRadius,	14)
		XCTAssertEqual(sut.email().layer.cornerRadius,		14)
		XCTAssertEqual(sut.password().layer.cornerRadius,	14)
		XCTAssertEqual(sut.signUp().layer.cornerRadius, 	18)
	}
	
	func testNicknameTextFieldBackGroundHasCorrectColor() {
		XCTAssertEqual(sut.nickname().backgroundColor,	UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1))
		XCTAssertEqual(sut.email().backgroundColor,		UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1))
		XCTAssertEqual(sut.password().backgroundColor,	UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1))
//		XCTAssertEqual(sut.signUp().layer, setGradientBackground(colorOne: Colors.backgroundUpButton, colorTwo: Colors.backgroundDownButton)	)
	}
	
	func testFontInNicknameTextFieldHasCorrectFont() {
		XCTAssertEqual(sut.nickname().font,	UIFont(name: "SFProDisplay-Medium",	size: 20))
		XCTAssertEqual(sut.email().font,		UIFont(name: "SFProDisplay-Medium",	size: 20))
		XCTAssertEqual(sut.password().font,	UIFont(name: "SFProDisplay-Medium",	size: 20))
	}
	
	func testNicknameTextFieldBorderWidthIsCorrect() {
		XCTAssertEqual(sut.nickname().layer.borderWidth,	0.5)
		XCTAssertEqual(sut.email().layer.borderWidth,	0.5)
		XCTAssertEqual(sut.password().layer.borderWidth,	0.5)
	}
	
	func testNicknameTextFieldBorderColorIsCorrect() {
		XCTAssertEqual(sut.nickname().layer.borderColor,	UIColor(red: 0.82, green: 0.82, blue: 0.839, alpha: 1).cgColor)
		XCTAssertEqual(sut.email().layer.borderColor,		UIColor(red: 0.82, green: 0.82, blue: 0.839, alpha: 1).cgColor)
		XCTAssertEqual(sut.password().layer.borderColor,	UIColor(red: 0.82, green: 0.82, blue: 0.839, alpha: 1).cgColor)
	}
	
	func testNicknameTextFieldAutoCorrectionTypeIsNo() {
		XCTAssertTrue(sut.nickname().autocorrectionType		== .no)
		XCTAssertTrue(sut.email().autocorrectionType		== .no)
		XCTAssertTrue(sut.password().autocorrectionType		== .no)
	}
	
	func testNicknameTextFieldKeyboardTypeIsDefault() {
		XCTAssertTrue(sut.nickname().returnKeyType			== .done)
		XCTAssertTrue(sut.email().returnKeyType				== .done)
		XCTAssertTrue(sut.password().returnKeyType			== .done)
	}
	
	func testNicknameTextFieldReturnKeyTypeIsDone() {
		XCTAssertTrue(sut.nickname().returnKeyType			== .done)
		XCTAssertTrue(sut.email().returnKeyType				== .done)
		XCTAssertTrue(sut.password().returnKeyType			== .done)
	}
	
	func testNicknameTextFieldClearButtonModeIsWhileEditing() {
		XCTAssertTrue(sut.nickname().clearButtonMode		== .whileEditing)
		XCTAssertTrue(sut.email().clearButtonMode			== .whileEditing)
		XCTAssertTrue(sut.password().clearButtonMode		== .whileEditing)

	}
	
	func testNicknameTextFieldLeftViewIsCorrect() {
		XCTAssertEqual(sut.nickname().leftViewRect(			forBounds: CGRect(x: 0, y: 0, width: 16, height: 62)),	CGRect(x: 0, y: 0, width: 16, height: 62))
		XCTAssertEqual(sut.email().leftViewRect(			forBounds: CGRect(x: 0, y: 0, width: 16, height: 62)),	CGRect(x: 0, y: 0, width: 16, height: 62))
		XCTAssertEqual(sut.password().leftViewRect(			forBounds: CGRect(x: 0, y: 0, width: 16, height: 62)),	CGRect(x: 0, y: 0, width: 16, height: 62))
	}
	
	func testNicknameTextFieldLeftViewModeIsAlways() {
		XCTAssertEqual(sut.nickname().leftViewMode,			.always)
		XCTAssertEqual(sut.email().leftViewMode,			.always)
		XCTAssertEqual(sut.password().leftViewMode,			.always)
	}
}
