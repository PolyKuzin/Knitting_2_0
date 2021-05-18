//
//  CountersController.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 17.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

class CountersController: BaseVC {
	
	public var project         : Project?
	private var countersView   = CountersView.loadFromNib()
	private var networkManager = NetworkManager.shared

	init(project: Project) {
		self.project = project
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		super.loadView()
		self.view = countersView
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		setupNormalNavBar()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if let counters = self.project?.linkedCounters {
			self.makeLoadedState(with: counters)
		} else {
			self.dowloadAllData()
		}
	}
	
	private func dowloadAllData() {
		guard let project = self.project else { return }
		self.networkManager.getLinkedCounters(for: project) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .failure(let err)      :
				self.makeErrorState(with: err)
			case .success(let counters) :
				if counters.isEmpty {
					self.makeErrorState(with: .noData)
				} else {
					self.makeLoadedState(with: counters)
				}
			}
		}
	}
	
	private func makeErrorState(with data: KnitError) {
		let errState = CountersView.ViewState.Error(title: "БЛЯ ОШИБКА", image: UIImage(named: "_0"), onSelect: {})
		countersView.viewState = .error(errState)
	}
	
	private func makeLoadedState(with data: [Counter]) {
		let loadState : [CountersView.ViewState.CounterItem] = data.map {
			
			return CountersView.ViewState.CounterItem(counter          : $0,
													  onPlusRow        : self.doStuff(counter:),
													  onMinusRow       : self.doStuff(counter:),
													  onVisibleCounter : self.doStuff(counter:),
													  onEditCounter    : self.doStuff(counter:),
													  onDeleteCounter  : self.doStuff(counter:),
													  onDoubleCounter  : self.doStuff(counter:))
		}
		countersView.viewState = .loaded(loadState)
	}
	
	private func doStuff(counter: Counter) {}
}
