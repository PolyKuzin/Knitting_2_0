//
//  IconsTests.swift
//  Knitting_2_0Tests
//
//  Created by Павел Кузин on 27.08.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import XCTest
@testable import Knitting_2_0

class IconsTests: XCTestCase {
    
    override func setUpWithError() throws {
        super.setUp()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIconsStructureHasLogoIcon() {
        XCTAssertEqual(Icons.logoIcon, UIImage(named: "logoIcon"))
    }
}
