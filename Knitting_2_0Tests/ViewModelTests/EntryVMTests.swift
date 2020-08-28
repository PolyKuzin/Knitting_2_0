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
		XCTAssertEqual(sut.logoIconView.frame.width, 190.17)
		XCTAssertEqual(sut.logoIconView.frame.height, 227.65)
	}
	
	func testlogoIconImageViewTraingConstraint() {
		
	}
}
