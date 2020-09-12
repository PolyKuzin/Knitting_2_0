//
//  LogInVMTests.swift
//  Knitting_2_0Tests
//
//  Created by Павел Кузин on 06.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import XCTest
@testable import Knitting_2_0

class LogInVMTests: XCTestCase {

    var sut		: LogInVM!
	var view	: UIView!
	
    override func setUpWithError() throws {
		super.setUp()
        sut		= LogInVM()
		view	= UIView()
    }

    override func tearDownWithError() throws {
		
		super.tearDown()
    }
	
	//MARK: Logo Icon TESTS
    func testEntryVMContainsLogoIconView() {
        XCTAssertNotNil(sut.logoIcon)
    }
    
    func testLogoIconViewImageIsLogoIcon() {
        XCTAssertTrue(sut.logoIcon().image 							=== Icons.logoIcon)
    }

	func testLogoIconViewFrameIsCorrect() {
		XCTAssertEqual(sut.logoIcon().frame.width,					129.39)
		XCTAssertEqual(sut.logoIcon().frame.height,					154.89)
	}
	
	//MARK: TextFields TESTS
	func testRegistrtionVMContainsCorrectTextFields() {
		XCTAssertNotNil(sut.email())
		XCTAssertNotNil(sut.password())
	}
	
	func testTextFieldFramesHasCorrectValues() {
		XCTAssertEqual(sut.email().frame.width,						382)
		XCTAssertEqual(sut.email().frame.height,					62)
		
		XCTAssertEqual(sut.password().frame.width,					382)
		XCTAssertEqual(sut.password().frame.height,					62)
	}
	
	func testNTextFieldCornerRadiusHasCorrectValues() {
		XCTAssertEqual(sut.email().layer.cornerRadius,				14)
		XCTAssertEqual(sut.password().layer.cornerRadius,			14)
	}
	
	func testTextFieldBackGroundColorsHasCorrectValues() {
		XCTAssertEqual(sut.email().backgroundColor,					UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1))
		XCTAssertEqual(sut.password().backgroundColor,				UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1))
	}
	
	func testTextFieldFontsHasCorrectValues() {
		XCTAssertEqual(sut.email().font,							UIFont(name: "SFProDisplay-Medium",	size: 20))
		XCTAssertEqual(sut.password().font,							UIFont(name: "SFProDisplay-Medium",	size: 20))
	}
		
	func testTextFieldBorderWidthsHasCorrectValues() {
		XCTAssertEqual(sut.email().layer.borderWidth,				0.5)
		XCTAssertEqual(sut.password().layer.borderWidth,			0.5)
	}
	
	func testTextFieldBorderColorsHasCorrectValues() {
		XCTAssertEqual(sut.email().layer.borderColor,				UIColor(red: 0.82, green: 0.82, blue: 0.839, alpha:1).cgColor)
		XCTAssertEqual(sut.password().layer.borderColor,			UIColor(red: 0.82, green: 0.82, blue: 0.839, alpha:1).cgColor)
	}
	
	func testTextFieldAutoCorrectionTypesHasCorrectValues() {
		XCTAssertTrue(sut.email().autocorrectionType				== .no)
		XCTAssertTrue(sut.password().autocorrectionType				== .no)
	}
	
	func testTextFieldKeyboardTypesHasCorrectValues() {
		XCTAssertTrue(sut.email().returnKeyType						== .done)
		XCTAssertTrue(sut.password().returnKeyType					== .done)
	}
	
	func testTextFieldReturnKeyTypesHasCorrectValues() {
		XCTAssertTrue(sut.email().returnKeyType						== .done)
		XCTAssertTrue(sut.password().returnKeyType					== .done)
	}
	
	func testTextFieldClearButtonModesHasCorrectValues() {
		XCTAssertTrue(sut.email().clearButtonMode					== .whileEditing)
		XCTAssertTrue(sut.password().clearButtonMode				== .whileEditing)
	}
	
	func testTextFieldLeftViewsHasCorrectValues() {
		XCTAssertEqual(sut.email().leftViewRect(					forBounds: CGRect(x: 0, y: 0, width: 16, height:62)),	CGRect(x: 0, y: 0, width: 16, height: 62))
		XCTAssertEqual(sut.password().leftViewRect(					forBounds: CGRect(x: 0, y: 0, width: 16, height:62)),	CGRect(x: 0, y: 0, width: 16, height: 62))
	}
	
	func testTextFieldLeftViewModesHasCorrectValues() {
		XCTAssertEqual(sut.email().leftViewMode,					.always)
		XCTAssertEqual(sut.password().leftViewMode,					.always)
	}
		
	//MARK: Buttons TESTS
	func testRegistrationVMContainsCorrectButtons() {
		XCTAssertNotNil(sut.logIn())
	}
	
	func testButtonsTypeIsCorrect() {
		XCTAssertEqual(sut.logIn().buttonType,						.system)
		XCTAssertEqual(sut.questionBtn().buttonType, 				.system)
	}
	
	func testButtonFontsHasCorrectValues() {
		XCTAssertEqual(sut.logIn().titleLabel?.font, 				Fonts.textSemibold17)
		XCTAssertEqual(sut.questionBtn().titleLabel?.font,			Fonts.textRegular17)
	}
	
	func testButtonsCornerRadiusHasCorrectValues() {
		XCTAssertEqual(sut.logIn().layer.cornerRadius, 				CornerRadius.forButton)
		XCTAssertEqual(sut.questionBtn().layer.cornerRadius,		0)
	}
	
	func testButtonsLayeerMaskToBoundsEquealTrue() {
		XCTAssertTrue(sut.logIn().layer.masksToBounds)
		XCTAssertTrue(sut.questionBtn().layer.masksToBounds)
	}
	
	func testButtonsTitlesHasCorrectValues() {
		XCTAssertEqual(sut.logIn().titleLabel?.text, 				Placeholder.titleForLogIn)
		XCTAssertEqual(sut.questionBtn().titleLabel?.text,			Placeholder.questionToRegistrBtn)
	}
	
	func testButtonsTitlesColorHasCorrectValues() {
		XCTAssertEqual(sut.logIn().titleColor(for: .normal),		Colors.titleForButton)
		XCTAssertEqual(sut.questionBtn().titleColor(for: .normal),	Colors.questionButton)
	}
	
	func testButtonsBackGroundColorsHasCorrectValues() {
		XCTAssertNotNil(sut.logIn().layer)
	}
		
	//MARK: Label TESTS
	func testRegistrationVMContainsCorrectLabels() {
		XCTAssertNotNil(sut.questionLbl())
	}
	
	func testLabelsFramesHasCorrectValues() {
		XCTAssertEqual(sut.questionLbl().frame.width,				180)
		XCTAssertEqual(sut.questionLbl().frame.height,				20)
	}
	
	func testLabelsTextHasCorrectValues() {
		XCTAssertEqual(sut.questionLbl().text,						Placeholder.questionToRegistrLbl)
	}
	
	func testLabelsFontsHasCorrectValues() {
		XCTAssertEqual(sut.questionLbl().font,						Fonts.textRegular17)
	}
	
	func testLabelColorsHasCorrectValues() {
		XCTAssertEqual(sut.questionLbl().textColor,					Colors.questionText)
	}
	
	func testLabelTextAlignmentHasCorrectValues() {
		XCTAssertEqual(sut.questionLbl().textAlignment,				.right)
	}
}