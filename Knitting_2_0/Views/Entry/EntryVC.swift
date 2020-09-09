//
//  EntryVC.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 06.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class EntryVC: UIViewController {
	
	private var logoIcon				= UIImageView()
	private var signUpButton			= UIButton()
	private var logInButton				= UIButton()

	private var viewModel : EntryVM! {
		didSet {
			self.logoIcon				= viewModel.logoIcon()
			self.signUpButton			= viewModel.signUp()
			self.logInButton		 	= viewModel.logIn()
			logInButton.addTarget (self, action: #selector(pushLogInVC),  for: .touchUpInside)
			signUpButton.addTarget(self, action: #selector(pushSignUpVC), for: .touchUpInside)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		view.backgroundColor			= .white
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		viewModel 						= EntryVM()
		setUpLayout()
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
}

//MARK: Layout
extension EntryVC {
	
	func setUpLayout() {
		//Navigation Bar scould be invisible
		self.navigationController?.navigationBar.isHidden = true
		
		//A place of view, where the image is
		let topImageConteinerView = UIView()
		view.addSubview(topImageConteinerView)
		topImageConteinerView.translatesAutoresizingMaskIntoConstraints												= false
		topImageConteinerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive						= true
		topImageConteinerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive						= true
		topImageConteinerView.topAnchor.constraint(equalTo: view.topAnchor).isActive								= true
		topImageConteinerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive			= true
		
		//Image or Gif constraints in a cell
		topImageConteinerView.addSubview(logoIcon)
		logoIcon.translatesAutoresizingMaskIntoConstraints															= false
		logoIcon.centerXAnchor.constraint(equalTo: topImageConteinerView.centerXAnchor, constant: -10).isActive		= true
		logoIcon.centerYAnchor.constraint(equalTo: topImageConteinerView.centerYAnchor).isActive					= true
		logoIcon.heightAnchor.constraint(lessThanOrEqualToConstant: 227.65).isActive								= true
		logoIcon.widthAnchor.constraint(lessThanOrEqualToConstant: 190.17).isActive									= true
		
		//A place for registration buttom
		view.addSubview(signUpButton)
		signUpButton.translatesAutoresizingMaskIntoConstraints														= false
		signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive									= true
		signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44).isActive				= true
		signUpButton.topAnchor.constraint(equalTo: topImageConteinerView.bottomAnchor, constant: 20).isActive		= true
		signUpButton.heightAnchor.constraint(equalToConstant: 64).isActive											= true

		//A place for registration buttom
		view.addSubview(logInButton)
		logInButton.translatesAutoresizingMaskIntoConstraints														= false
		logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive									= true
		logInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -135).isActive				= true
		logInButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 20).isActive					= true
		logInButton.heightAnchor.constraint(equalToConstant: 50).isActive											= true
	}
}
