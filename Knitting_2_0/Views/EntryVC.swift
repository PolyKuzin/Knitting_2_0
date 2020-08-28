//
//  ViewController.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 27.08.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class EntryVC: UIViewController {
	
	var logoIcon = UIImageView()

	var viewModel : EntryVM! {
		didSet {
			self.logoIcon = viewModel.logoIconView
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		screenConfigure()
	}
	
	func screenConfigure() {
		viewModel = EntryVM()
		view.addSubview(logoIcon)
	}
}

