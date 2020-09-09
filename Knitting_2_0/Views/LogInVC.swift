//
//  LogInVC.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 06.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class LogInVC: UIViewController {

	private var logoIcon				= UIImageView()
	private var emailTextField			= UITextField()
	private var passwordTextField		= UITextField()
	private var logInButton				= UIButton()
	private var questionToRegButton		= UIButton()
	private var questionToRegLabel		= UILabel()
	
	private var viewModel : LogInVM! {
		didSet {
			self.logoIcon				= viewModel.logoIcon()
			self.emailTextField			= viewModel.email()
			self.passwordTextField		= viewModel.password()
			self.logInButton		 	= viewModel.logIn()
			self.questionToRegButton	= viewModel.questionBtn()
			self.questionToRegLabel		= viewModel.questionLbl()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor			= .white
		viewModel 						= LogInVM()
		viewModel.setUpLayout(toView: view)
    }
}
