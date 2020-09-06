//
//  ViewController.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 27.08.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class RegistrationVC	: UIViewController {
	
	private var logoIcon				= UIImageView()
	private var nicknameTextField		= UITextField()
	private var emailTextField			= UITextField()
	private var passwordTextField		= UITextField()
	private var registrationButton		= UIButton()
	private var questionToLogInButton	= UIButton()
	private var questionToLogInLabel	= UILabel()
	
	private var viewModel : RegistrationVM! {
		didSet {
			self.logoIcon				= viewModel.logoIcon()
			self.nicknameTextField		= viewModel.nickname()
			self.emailTextField			= viewModel.email()
			self.passwordTextField		= viewModel.password()
			self.registrationButton 	= viewModel.signUp()
			self.questionToLogInButton	= viewModel.questionBtn()
			self.questionToLogInLabel	= viewModel.questionLbl()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
//		view.backgroundColor			= .white
		viewModel 						= RegistrationVM()
		viewModel.setUpLayout(toView: view)
	}
}
