//
//  EntryVCTests.swift
//  Knitting_2_0Tests
//
//  Created by Павел Кузин on 27.08.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import XCTest
@testable import Knitting_2_0

class EntryVCTests: XCTestCase {
	
	var sut : EntryVC!

    override func setUpWithError() throws {
		super.setUp()
		let storyboard	= UIStoryboard(name: "Entry", bundle: nil)
        let vc			= storyboard.instantiateViewController(withIdentifier: String(describing: EntryVC.self))
        sut				= vc as? EntryVC
        
        sut.loadViewIfNeeded()
	}

    override func tearDownWithError() throws {
		
		super.tearDown()
	}

	func testEntryVCContainsViewModel() {
		XCTAssertNotNil(sut.logoIcon)
	}
}
