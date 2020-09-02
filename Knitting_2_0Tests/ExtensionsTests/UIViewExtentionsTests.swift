//
//  UIViewExtentionsTests.swift
//  Knitting_2_0Tests
//
//  Created by Павел Кузин on 01.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import XCTest
@testable import Knitting_2_0

class UIViewExtentionsTests: XCTestCase {
	
	var sut : UIView!

    override func setUpWithError() throws {
		super.setUp()
		sut = UIView()
	}

    override func tearDownWithError() throws {
		
		super.tearDown()
	}
	
	func testSetGradientBackGroundReturnsSomeLayer() {
		XCTAssertNotNil(sut.setGradientBackground(colorOne: .white, colorTwo: .red))
	}
}
