//
//  EntryVMTests.swift
//  Knitting_2_0Tests
//
//  Created by Павел Кузин on 08.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import XCTest
@testable import Knitting_2_0

class EntryVMTests: XCTestCase {

    var sut		: EntryVM!
	var view	: UIView!
	
    override func setUpWithError() throws {
		super.setUp()
        sut		= EntryVM()
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
	
	//MARK: Buttons TESTS
	func testRegistrationVMContainsCorrectButtons() {
		XCTAssertNotNil(sut.signUp())
		XCTAssertNotNil(sut.logIn())
	}
	
	func testButtonsTypeIsCorrect() {
		XCTAssertEqual(sut.signUp().buttonType, 					.system)
		XCTAssertEqual(sut.logIn().buttonType,						.system)
	}
	
	func testButtonFontsHasCorrectValues() {
		XCTAssertEqual(sut.signUp().titleLabel?.font,				Fonts.displayMedium22)
		XCTAssertEqual(sut.logIn().titleLabel?.font, 				Fonts.displaySemibold22)
	}
	
	func testButtonsCornerRadiusHasCorrectValues() {
		XCTAssertEqual(sut.signUp().layer.cornerRadius, 			CornerRadius.forEntryBtn)
	}
	
	func testButtonsLayeerMaskToBoundsEquealTrue() {
		XCTAssertTrue(sut.logIn().layer.masksToBounds)
		XCTAssertTrue(sut.signUp().layer.masksToBounds)
	}
	
	func testButtonsTitlesHasCorrectValues() {
		XCTAssertEqual(sut.signUp().titleLabel?.text,				Placeholder.createNewAccount)
		XCTAssertEqual(sut.logIn().titleLabel?.text, 				Placeholder.logIn)
	}
	
	func testButtonsTitlesColorHasCorrectValues() {
		XCTAssertEqual(sut.signUp().titleColor(for: .normal),		Colors.whiteColor)
		XCTAssertEqual(sut.logIn().titleColor(for: .normal),		Colors.questionButton)
	}
	
	func testButtonsBackGroundColorsHasCorrectValues() {
		XCTAssertNotNil(sut.logIn().layer)
	}
}
