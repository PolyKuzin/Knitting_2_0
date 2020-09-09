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
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor			= .white
		viewModel 						= EntryVM()
		viewModel.setUpLayout(toView: view)
    }
}
