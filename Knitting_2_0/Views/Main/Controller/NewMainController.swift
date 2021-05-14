//
//  NewMainController.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 12.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit
import PanModal

class NewMainController : BaseVC {
	
	private var newMainView    = NewMainView.loadFromNib()
	private var networkManager = NetworkManager.shared

	override func loadView() {
		super.loadView()
		self.view = newMainView
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		setupNormalNavBar()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		networkManager.getProjects()
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
}

// MARK: -
extension NewMainController {
	
}
