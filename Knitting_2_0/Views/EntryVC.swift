//
//  ViewController.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 27.08.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class EntryVC: UIViewController {
	
	var logoIcon					= UIImageView()
	var nicknameTextField			= UITextField()
	var emailTextField				= UITextField()
	var passwordTextField			= UITextField()
	
	var viewModel : EntryVM! {
		didSet {
			self.logoIcon			= viewModel.logoIconView
			self.nicknameTextField	= viewModel.nicknameTextField
			self.emailTextField		= viewModel.emailTextField
			self.passwordTextField	= viewModel.passwordTextField
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		viewModel = EntryVM()
		screenConfigure()
	}
	
	func screenConfigure() {
		view.addSubview(logoIcon)
		view.addSubview(nicknameTextField)
		view.addSubview(emailTextField)
		view.addSubview(passwordTextField)
	}
}

