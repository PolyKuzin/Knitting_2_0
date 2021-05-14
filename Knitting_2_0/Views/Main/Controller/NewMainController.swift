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
		self.dowloadAllData()
	}
	
	private func dowloadAllData() {
		self.networkManager.getProjects { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .failure(let err)      :
				self.makeErrorState(with: err)
			case .success(let projects) :
				self.makeErrorState(with: .error)
			}
		}
	}
	
	private func makeErrorState(with data: KnitError) {
		let errState = NewMainView.ViewState.Error(title: "БЛЯ ОШИБКА", image: UIImage(named: "_0"), onSelect: {})
		newMainView.viewState = .error(errState)
	}
	
	private func makeState(with data: [Project]) {
		
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
}

// MARK: -
extension NewMainController {
	
}
