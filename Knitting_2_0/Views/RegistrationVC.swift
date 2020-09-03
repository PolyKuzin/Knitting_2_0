//
//  ViewController.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 27.08.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class RegistrationVC	: UIViewController {
	
	private var logoIcon			= UIImageView()
	private var nicknameTextField	= UITextField()
	private var emailTextField		= UITextField()
	private var passwordTextField	= UITextField()
	private var registrationButton	= UIButton()
	
	private var viewModel : RegistrationVM! {
		didSet {
			self.logoIcon			= viewModel.logoIcon()
			self.nicknameTextField	= viewModel.nickname()
			self.emailTextField		= viewModel.email()
			self.passwordTextField	= viewModel.password()
			self.registrationButton = viewModel.signUp()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		viewModel 					= RegistrationVM()
		viewModel.setUpLayout(toView: view)
	}
}
