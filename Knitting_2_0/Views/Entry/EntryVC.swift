//
//  EntryVC.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 06.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit
import FirebaseAuth

class EntryVC: UIViewController {
	
	private var logoIcon				= UIImageView		()
	private var signUpButton			= UIButton			()
	private var logInButton				= UIButton			()

	private var viewModel				: EntryVM! {
		didSet {
			self.logoIcon				= viewModel.logoIcon()
			self.signUpButton			= viewModel.signUp	()
			self.logInButton		 	= viewModel.logIn	()
			logInButton.addTarget (self, action: #selector(pushLogInVC),  for: .touchUpInside)
			signUpButton.addTarget(self, action: #selector(pushSignUpVC), for: .touchUpInside)
		}
	}
	
	override func viewWillAppear(_ animated: Bool)	 {
		super.viewWillAppear(animated)
		Auth.auth().addStateDidChangeListener { (auth, user) in
			if user != nil {
				self.pushMainVC()
			}
		}
	}
	
	override func viewDidAppear(_ animated: Bool)	 {
		super.viewDidAppear(animated)
		UIView.animate(withDuration: 0.5) {
			self.signUpButton.alpha		= 1.0
			self.logInButton.alpha		= 1.0
		}
	}
	
    override func viewDidLoad() 					{
        super.viewDidLoad()
		view.backgroundColor			= .white
		viewModel 						= EntryVM()
		setUpLayout()
    }
	
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
		guard let navigationController = navigationController else { return }
        navigationController.viewControllers.removeAll(where: { self === $0 })
    }
}

//MARK: Navigation
extension EntryVC {
	
	@objc
	func pushLogInVC() {
		let vc = LogInVC()
		guard let navigationController = navigationController else { return }
		navigationController.pushViewController(vc, animated: true)
	}
	
	@objc
	func pushSignUpVC() {
		let vc = RegistrationVC()
		guard let navigationController = navigationController else { return }
		navigationController.pushViewController(vc, animated: true)
	}
	
	func pushMainVC() {
		let vc = MainVC()
		guard let navigationController = navigationController else { return }
		navigationController.pushViewController(vc, animated: true)
	}
}

//MARK: Layout
extension EntryVC {
	
	func setUpLayout() {
		//Navigation Bar scould be invisible
		guard let navigationController = navigationController else { return }
		navigationController.navigationBar.barTintColor		= .white
		navigationController.navigationBar.isTranslucent	= false
		navigationController.navigationBar.shadowImage		= UIImage()
		navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
		
		//Image or Gif constraints in a cell
		view.addSubview(logoIcon)
		logoIcon.translatesAutoresizingMaskIntoConstraints													= false
		logoIcon.centerXAnchor		.constraint(equalTo: view.centerXAnchor)					.isActive	= true
		logoIcon.heightAnchor		.constraint(equalToConstant: 219)							.isActive	= true
		logoIcon.widthAnchor		.constraint(equalToConstant: 202)							.isActive	= true
		
		//A place for registration buttom
		view.addSubview(logInButton)
		logInButton.translatesAutoresizingMaskIntoConstraints												= false
		logInButton.centerXAnchor	.constraint(equalTo: view.centerXAnchor)					.isActive	= true
		logInButton.heightAnchor	.constraint(equalToConstant: 21)							.isActive	= true
		logInButton.trailingAnchor	.constraint(equalTo: view.trailingAnchor,	constant: -120)	.isActive	= true
		logInButton.bottomAnchor	.constraint(equalTo: view.bottomAnchor,		constant: -48)	.isActive	= true
		
		//A place for registration buttom
		view.addSubview(signUpButton)
		signUpButton.translatesAutoresizingMaskIntoConstraints												= false
		signUpButton.topAnchor		.constraint(equalTo: logoIcon.bottomAnchor,	constant: 163)	.isActive	= true
		signUpButton.centerXAnchor	.constraint(equalTo: view.centerXAnchor)					.isActive	= true
		signUpButton.bottomAnchor	.constraint(equalTo: logInButton.topAnchor, constant: -24)	.isActive	= true
		signUpButton.heightAnchor	.constraint(equalToConstant: 53)							.isActive	= true
		signUpButton.widthAnchor	.constraint(equalToConstant: 152)							.isActive	= true
	}
}
