//
//  Knitting_2_0Tests.swift
//  Knitting_2_0Tests
//
//  Created by Павел Кузин on 27.08.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import XCTest
@testable import Knitting_2_0

class Knitting_2_0Tests: XCTestCase {

    var sut : EntryVM!
    
    override func setUpWithError() throws {
        super.setUp()
        sut = EntryVM()
    }

    override func tearDownWithError() throws {
        
        super.tearDown()
    }

    func testEntryVMContainsLogoIconView() {
        XCTAssertNotNil(sut.logoIconView)
    }
    
    func testLogoIconViewImageIsLogoIcon() {
        XCTAssertTrue(sut.logoIconView.image === Icons.logoIcon)
    }

	func testLogoIconViewFrameIsCorrect() {
		XCTAssertEqual(sut.logoIconView.frame.width, 129.39)
		XCTAssertEqual(sut.logoIconView.frame.height, 154.89)
	}
	
	func testEntryVMContainsNickNameTextField() {
        XCTAssertNotNil(sut.nicknameTextField)
	}
	
	func testNicknameTextFieldFrameIsCorrect() {
		XCTAssertEqual(sut.nicknameTextField.frame.width, 382)
		XCTAssertEqual(sut.nicknameTextField.frame.height, 62)
	}
	
	func testNicknameTextFieldBackGroundHasCorrectColor() {
		XCTAssertEqual(sut.nicknameTextField.backgroundColor, UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1))
	}
	
	func testFontInNicknameTextFieldHasCorrectFont() {
		XCTAssertEqual(sut.nicknameTextField.font, UIFont(name: "SFProDisplay-Medium", size: 20))
	}
	
	func testNicknameTextFieldHasCorrectCornerRadius() {
		XCTAssertEqual(sut.nicknameTextField.layer.cornerRadius, 14)
	}
	
	func testEntryVMContainsEmailTextField() {
        XCTAssertNotNil(sut.emailTextField)
	}
	
	func testEmailTextFieldBackGroundHasCorrectColor() {
		XCTAssertEqual(sut.emailTextField.backgroundColor, UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1))
	}
	
	func testEmailTextFieldFrameIsCorrect() {
		XCTAssertEqual(sut.emailTextField.frame.width, 382)
		XCTAssertEqual(sut.emailTextField.frame.height, 62)
	}
	
	func testFontInEmailTextFieldHasCorrectFont() {
		XCTAssertEqual(sut.emailTextField.font, UIFont(name: "SFProDisplay-Medium", size: 20))
	}
	
	func testEmailTextFieldHasCorrectCornerRadius() {
		XCTAssertEqual(sut.emailTextField.layer.cornerRadius, 14)
	}
	
	func testEntryVMContainsPasswordTextField() {
        XCTAssertNotNil(sut.passwordTextField)
	}
	
	func testPasswordTextFieldBackGroundHasCorrectColor() {
		XCTAssertEqual(sut.passwordTextField.backgroundColor, UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1))
	}
	
	func testPasswordTextFieldFrameIsCorrect() {
		XCTAssertEqual(sut.passwordTextField.frame.width, 382)
		XCTAssertEqual(sut.passwordTextField.frame.height, 62)
	}
	
	func testFontInPasswordTextFieldHasCorrectFont() {
		XCTAssertEqual(sut.passwordTextField.font, UIFont(name: "SFProDisplay-Medium", size: 20))
	}
	
	func testPasswordTextFieldHasCorrectCornerRadius() {
		XCTAssertEqual(sut.passwordTextField.layer.cornerRadius, 14)
	}
}
