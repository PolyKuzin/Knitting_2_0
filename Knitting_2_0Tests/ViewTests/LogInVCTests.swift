//
//  LogInVCTests.swift
//  Knitting_2_0Tests
//
//  Created by Павел Кузин on 06.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import XCTest
@testable import Knitting_2_0

class LogInVCTests: XCTestCase {
	
	var sut : LogInVC!

    override func setUpWithError() throws {
		let storyboard	= UIStoryboard(name: "Entry", bundle: nil)
        let vc			= storyboard.instantiateViewController(withIdentifier: String(describing: RegistrationVC.self))
        sut				= vc as? LogInVC
        
        sut.loadViewIfNeeded()    }

    override func tearDownWithError() throws {

		super.tearDown()
	}
}
