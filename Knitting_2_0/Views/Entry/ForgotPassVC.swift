//
//  ForgotPassVC.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 12.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class ForgotPassVC			: UIViewController {

	private var logoImage	= UIImageView()
	private var email		= UITextField()
	private var info 		= UILabel()
	private var resetBtn	= UIButton()
	
	private var viewModel	: ForgotPassVM! {
		didSet {
			self.logoImage	= viewModel.logo	()
			self.email		= viewModel.email	()
			self.info		= viewModel.info	()
			self.resetBtn	= viewModel.reset	()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white
		viewModel = ForgotPassVM()
	}
}
