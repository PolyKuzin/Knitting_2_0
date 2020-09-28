////
////  EntryVCTests.swift
////  Knitting_2_0Tests
////
////  Created by Павел Кузин on 08.09.2020.
////  Copyright © 2020 Павел Кузин. All rights reserved.
////
//
//import XCTest
//@testable import Knitting_2_0
//
//class EntryVCTests: XCTestCase {
//	
//	var sut : EntryVC!
//
//    override func setUpWithError() throws {
//        sut				= EntryVC()
//        
//        sut.loadViewIfNeeded()
//	}
//
//    override func tearDownWithError() throws {
//
//		super.tearDown()
//	}
//	//MARK: Background Color Is white
//	func testBackGroundColorIsWhite(){
//        sut.loadViewIfNeeded()
//
//		XCTAssertEqual(sut.view.backgroundColor, .white)
//	}
//	
////	//MARK: Constraints TESTS
////	func test() {
////
////	}
////
////	//MARK: Navigation TESTS
////	func testNextViewButton_WhenTapped_SecondViewControllerIsPushed2() throws {
////		let keyWindow = UIApplication.shared.connectedScenes
////        .filter({$0.activationState == .foregroundActive})
////        .map({$0 as? UIWindowScene})
////        .compactMap({$0})
////        .first?.windows
////        .filter({$0.isKeyWindow}).first
////
////		let mockNavigationCotroller		= MockNavigationController(rootViewController: sut)
////		keyWindow?.rootViewController	= mockNavigationCotroller
////
////		sut.loadViewIfNeeded()
////
////		guard let signUpVC = mockNavigationCotroller.pushedViewController as? RegistrationVC else {
////			XCTFail()
////			return
////		}
////
////		sut.signUpButton.sendActions(for: .touchUpInside)
////
////		signUpVC.loadViewIfNeeded()
////
////		XCTAssertNotNil(signUpVC.logoIcon)
////		XCTAssertEqual(signUpVC.logoIcon.image, Icons.logoIcon)
////	}
//}
////
////extension EntryVCTests {
////	
////	class MockNavigationController	: UINavigationController {
////		var pushedViewController	: UIViewController?
////		
////		override func pushViewController(_ viewController: UIViewController, animated: Bool) {
////			pushedViewController = viewController
////			super.pushViewController(viewController, animated: animated)
////		}
////	}
////}
