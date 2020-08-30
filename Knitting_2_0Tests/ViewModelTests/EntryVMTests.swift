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

//MARK: Logo Icon Tests
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
	
//MARK: Nickname TextField Tests
	func testEntryVMContainsNickNameTextField() {
        XCTAssertNotNil(sut.nicknameTextField)
	}
	
	func testNicknameTextFieldFrameIsCorrect() {
		XCTAssertEqual(sut.nicknameTextField.frame.width, 382)
		XCTAssertEqual(sut.nicknameTextField.frame.height, 62)
	}
	
	func testNicknameTextFieldHasCorrectCornerRadius() {
		XCTAssertEqual(sut.nicknameTextField.layer.cornerRadius, 14)
	}
	
	func testNicknameTextFieldBackGroundHasCorrectColor() {
		XCTAssertEqual(sut.nicknameTextField.backgroundColor, UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1))
	}
	
	func testFontInNicknameTextFieldHasCorrectFont() {
		XCTAssertEqual(sut.nicknameTextField.font, UIFont(name: "SFProDisplay-Medium", size: 20))
	}
	
	func testNicknameTextFieldBorderWidthIsCorrect() {
		XCTAssertEqual(sut.nicknameTextField.layer.borderWidth, 0.5)
	}
	
	func testNicknameTextFieldBorderColorIsCorrect() {
		XCTAssertEqual(sut.nicknameTextField.layer.borderColor, UIColor(red: 0.82, green: 0.82, blue: 0.839, alpha: 1).cgColor)
	}
	
	func testNicknameTextFieldAutoCorrectionTypeIsNo() {
		XCTAssertTrue(sut.nicknameTextField.autocorrectionType == .no)
	}
	
	func testNicknameTextFieldKeyboardTypeIsDefault() {
		XCTAssertTrue(sut.nicknameTextField.returnKeyType == .done)
	}
	
	func testNicknameTextFieldReturnKeyTypeIsDone() {
		XCTAssertTrue(sut.nicknameTextField.returnKeyType == .done)
	}
	
	func testNicknameTextFieldClearButtonModeIsWhileEditing() {
		XCTAssertTrue(sut.nicknameTextField.clearButtonMode == .whileEditing )
	}
	
//MARK: Email TextField Tests
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
	
	func testEmailTextFieldBorderWidthIsCorrect() {
		XCTAssertEqual(sut.emailTextField.layer.borderWidth, 0.5)
	}
	
	func testEmailTextFieldBorderColorIsCorrect() {
		XCTAssertEqual(sut.emailTextField.layer.borderColor, UIColor(red: 0.82, green: 0.82, blue: 0.839, alpha: 1).cgColor)
	}
	
	func testEmailTextFieldAutoCorrectionTypeIsNo() {
		XCTAssertTrue(sut.emailTextField.autocorrectionType == .no)
	}
	
	func testEmailTextFieldKeyboardTypeIsDefault() {
		XCTAssertTrue(sut.emailTextField.returnKeyType == .done)
	}
	
	func testEmailTextFieldReturnKeyTypeIsDone() {
		XCTAssertTrue(sut.emailTextField.returnKeyType == .done)
	}
	
	func testEmailTextFieldClearButtonModeIsWhileEditing() {
		XCTAssertTrue(sut.emailTextField.clearButtonMode == .whileEditing )
	}
	
//MARK: Password TextField Tests
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
	
	func testPasswordTextFieldBorderWidthIsCorrect() {
		XCTAssertEqual(sut.passwordTextField.layer.borderWidth, 0.5)
	}
	
	func testPasswordTextFieldBorderColorIsCorrect() {
		XCTAssertEqual(sut.passwordTextField.layer.borderColor, UIColor(red: 0.82, green: 0.82, blue: 0.839, alpha: 1).cgColor)
	}
	
	func testPasswordTextFieldAutoCorrectionTypeIsNo() {
		XCTAssertTrue(sut.passwordTextField.autocorrectionType == .no)
	}
	
	func testPasswordTextFieldKeyboardTypeIsDefault() {
		XCTAssertTrue(sut.passwordTextField.returnKeyType == .done)
	}
	
	func testPasswordTextFieldReturnKeyTypeIsDone() {
		XCTAssertTrue(sut.passwordTextField.returnKeyType == .done)
	}
	
	func testPasswordTextFieldClearButtonModeIsWhileEditing() {
		XCTAssertTrue(sut.passwordTextField.clearButtonMode == .whileEditing )
	}
}
