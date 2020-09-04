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
        XCTAssertTrue(sut.logoIcon().image 						=== Icons.logoIcon)
    }

	func testLogoIconViewFrameIsCorrect() {
		XCTAssertEqual(sut.logoIcon().frame.width,				129.39)
		XCTAssertEqual(sut.logoIcon().frame.height,				154.89)
	}
	
//MARK: Nickname TextField Tests
	func testRegistrtionVMContainsCorrectTextFields() {
        XCTAssertNotNil(sut.nickname())
		XCTAssertNotNil(sut.email())
        XCTAssertNotNil(sut.password())
	}
	
	func testTextFieldFramesHasCorrectValues() {
		XCTAssertEqual(sut.nickname().frame.width,					382)
		XCTAssertEqual(sut.nickname().frame.height,					62)
		
		XCTAssertEqual(sut.email().frame.width,						382)
		XCTAssertEqual(sut.email().frame.height,					62)
		
		XCTAssertEqual(sut.password().frame.width,					382)
		XCTAssertEqual(sut.password().frame.height,					62)
	}
	
	func testNTextFieldCornerRadiusHasCorrectValues() {
		XCTAssertEqual(sut.nickname().layer.cornerRadius,			14)
		XCTAssertEqual(sut.email().layer.cornerRadius,				14)
		XCTAssertEqual(sut.password().layer.cornerRadius,			14)
	}
	
	func testTextFieldBackGroundColorsHasCorrectValues() {
		XCTAssertEqual(sut.nickname().backgroundColor,				UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1))
		XCTAssertEqual(sut.email().backgroundColor,					UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1))
		XCTAssertEqual(sut.password().backgroundColor,				UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1))
	}
	
	func testTextFieldFontsHasCorrectValues() {
		XCTAssertEqual(sut.nickname().font,							UIFont(name: "SFProDisplay-Medium",	size: 20))
		XCTAssertEqual(sut.email().font,							UIFont(name: "SFProDisplay-Medium",	size: 20))
		XCTAssertEqual(sut.password().font,							UIFont(name: "SFProDisplay-Medium",	size: 20))
	}
	
	func testTextFieldBorderWidthsHasCorrectValues() {
		XCTAssertEqual(sut.nickname().layer.borderWidth,			0.5)
		XCTAssertEqual(sut.email().layer.borderWidth,				0.5)
		XCTAssertEqual(sut.password().layer.borderWidth,			0.5)
	}
	
	func testTextFieldBorderColorsHasCorrectValues() {
		XCTAssertEqual(sut.nickname().layer.borderColor,			UIColor(red: 0.82, green: 0.82, blue: 0.839, alpha: 1).cgColor)
		XCTAssertEqual(sut.email().layer.borderColor,				UIColor(red: 0.82, green: 0.82, blue: 0.839, alpha: 1).cgColor)
		XCTAssertEqual(sut.password().layer.borderColor,			UIColor(red: 0.82, green: 0.82, blue: 0.839, alpha: 1).cgColor)
	}
	
	func testTextFieldAutoCorrectionTypesHasCorrectValues() {
		XCTAssertTrue(sut.nickname().autocorrectionType				== .no)
		XCTAssertTrue(sut.email().autocorrectionType				== .no)
		XCTAssertTrue(sut.password().autocorrectionType				== .no)
	}
	
	func testTextFieldKeyboardTypesHasCorrectValues() {
		XCTAssertTrue(sut.nickname().returnKeyType					== .done)
		XCTAssertTrue(sut.email().returnKeyType						== .done)
		XCTAssertTrue(sut.password().returnKeyType					== .done)
	}
	
	func testTextFieldReturnKeyTypesHasCorrectValues() {
		XCTAssertTrue(sut.nickname().returnKeyType					== .done)
		XCTAssertTrue(sut.email().returnKeyType						== .done)
		XCTAssertTrue(sut.password().returnKeyType					== .done)
	}
	
	func testTextFieldClearButtonModesHasCorrectValues() {
		XCTAssertTrue(sut.nickname().clearButtonMode				== .whileEditing)
		XCTAssertTrue(sut.email().clearButtonMode					== .whileEditing)
		XCTAssertTrue(sut.password().clearButtonMode				== .whileEditing)

	}
	
	func testTextFieldLeftViewsHasCorrectValues() {
		XCTAssertEqual(sut.nickname().leftViewRect(					forBounds: CGRect(x: 0, y: 0, width: 16, height: 62)),	CGRect(x: 0, y: 0, width: 16, height: 62))
		XCTAssertEqual(sut.email().leftViewRect(					forBounds: CGRect(x: 0, y: 0, width: 16, height: 62)),	CGRect(x: 0, y: 0, width: 16, height: 62))
		XCTAssertEqual(sut.password().leftViewRect(					forBounds: CGRect(x: 0, y: 0, width: 16, height: 62)),	CGRect(x: 0, y: 0, width: 16, height: 62))
	}
	
	func testTextFieldLeftViewModesHasCorrectValues() {
		XCTAssertEqual(sut.nickname().leftViewMode,					.always)
		XCTAssertEqual(sut.email().leftViewMode,					.always)
		XCTAssertEqual(sut.password().leftViewMode,					.always)
	}
	
//MARK: Buttons Tests
	func testRegistrationVMContainsCorrectButtons() {
		XCTAssertNotNil(sut.signUp())
	}
	
	func testButtonsTypeIsCorrect() {
		XCTAssertEqual(sut.signUp().buttonType,						.system)
		XCTAssertEqual(sut.questionBtn().buttonType, 				.system)
	}
	
	func testButtonFontsHasCorrectValues() {
		XCTAssertEqual(sut.signUp().titleLabel?.font, 				Fonts.titleButton)
		XCTAssertEqual(sut.questionBtn().titleLabel?.font,			Fonts.question)
	}
	
	func testButtonsCornerRadiusHasCorrectValues() {
		XCTAssertEqual(sut.signUp().layer.cornerRadius, 			CornerRadius.forButton)
		XCTAssertEqual(sut.questionBtn().layer.cornerRadius,		0)
	}
	
	func testButtonsLayeerMaskToBoundsEquealTrue() {
		XCTAssertTrue(sut.signUp().layer.masksToBounds)
		XCTAssertTrue(sut.questionBtn().layer.masksToBounds)
	}
	
	func testButtonsTitlesHasCorrectValues() {
		XCTAssertEqual(sut.signUp().titleLabel?.text, 				Placeholder.titleForSingUp)
		XCTAssertEqual(sut.questionBtn().titleLabel?.text,			Placeholder.questionToLogInBtn)
	}
	
	func testButtonsTitlesColorHasCorrectValues() {
		XCTAssertEqual(sut.signUp().titleColor(for: .normal),		Colors.titleForButton)
		XCTAssertEqual(sut.questionBtn().titleColor(for: .normal),	Colors.questionToLogIn)
	}
	
	func testButtonsBackGroundColorsHasCorrectValues() {
		XCTAssertNotNil(sut.signUp().layer)
	}
	
//MARK: Label Tests
	func test() {
		
	}
}
