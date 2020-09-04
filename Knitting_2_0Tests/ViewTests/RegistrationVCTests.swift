//
//  EntryVCTests.swift
//  Knitting_2_0Tests
//
//  Created by Павел Кузин on 27.08.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import XCTest
@testable import Knitting_2_0

class RegistrationVCTests: XCTestCase {
	
	var sut : RegistrationVC!

    override func setUpWithError() throws {
		super.setUp()
		let storyboard	= UIStoryboard(name: "Entry", bundle: nil)
        let vc			= storyboard.instantiateViewController(withIdentifier: String(describing: RegistrationVC.self))
        sut				= vc as? RegistrationVC
        
        sut.loadViewIfNeeded()
	}

    override func tearDownWithError() throws {
		
		super.tearDown()
	}

	func testWhenViewIsLoadedLogoIconNotNil() {
		
	}

//	func testWhenViewIsLoadedNickNameTextFieldNotNil() {
//		XCTAssertNotNil(sut.nicknameTextField)
//	}
//
//	func testWhenViewIsLoadedEmailTextFieldNotNil() {
//		XCTAssertNotNil(sut.emailTextField)
//	}
//
//	func testWhenViewIsLoadedPasswordTextFieldNotNil() {
//		XCTAssertNotNil(sut.passwordTextField)
//	}
//
//	func testHasLogoIconImageView() {
//		XCTAssertTrue((sut.logoIcon.isDescendant(of: sut.view)))
//	}
}
