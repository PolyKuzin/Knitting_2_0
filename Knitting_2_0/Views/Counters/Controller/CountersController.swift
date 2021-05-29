//
//  CountersController.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 17.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit
import PanModal
import AppstoreTransition

extension CountersController : CardDetailViewController {
	
	var scrollView: UIScrollView {
		return self.countersView.collectionView
	}
	
	var cardContentView: UIView {
		return self.countersView.viewState.header
	}
}

class CountersController : BaseVC {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		dismissHandler.scrollViewDidScroll(scrollView)
	}
	
	public var project         : Project?
	public var counters        = [Counter]() {
		didSet {
			(counters.isEmpty) ? (self.makeErrorState(with: .noData)) : (self.makeLoadedState(with: counters))
		}
	}
	private var countersView   = CountersView.loadFromNib()
	private var networkManager = NetworkManager.shared
	public var setLinkedCounters : (([Counter])->())?

	init(project: Project) {
		self.project = project
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		super.loadView()
		countersView.onAddCounter = { [weak self] in
			guard let self = self else { return }
			self.openAddCounter()
		}
		countersView.project = self.project
		countersView.onDismiss = { [weak self] in
			guard let self = self else { return }
			self.dismiss(animated: true, completion: nil)
		}
		self.view = countersView
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		setupNormalNavBar()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if let counters = self.project?.linkedCounters {
			self.counters = counters
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
				self.counters = counters
				self.setLinkedCounters?(counters)
			}
		}
	}
	
	private func makeErrorState(with data: KnitError) {
		let errState = CountersView.ViewState.Error(title: "БЛЯ ОШИБКА", image: UIImage(named: "_0"), onSelect: {})
		countersView.state = .error(errState)
	}
	
	private func makeLoadedState(with data: [Counter]) {
		let loadState : [CountersView.ViewState.CounterItem] = data.map {
			
			return CountersView.ViewState.CounterItem(counter          : $0,
													  onPlusRow        : self.addRowToCounter(from:),
													  onMinusRow       : self.removeRowToCounter(from:),
													  onVisibleCounter : self.doStuff(counter:),
													  onEditCounter    : self.openEditCounter(from: ),
													  onDeleteCounter  : self.deleteCounter(from:),
													  onDoubleCounter  : self.doubleCounter(from:))
		}
		countersView.state = .loaded(loadState)
	}
	
	private func openAddCounter() {
		let vc = PanCounter(nibName: "PanCounter", bundle: nil)
		vc.currentProject = self.project
		vc.onSave = { [weak self] counter in
			guard let self = self else { return }
			self.counters.insert(counter, at: 0)
		}
		let vcModal : PanModalPresentable.LayoutType = PanelNavigation(vc)
		self.presentPanModal(vcModal)
	}
	
	private func addRowToCounter(from cell: SwipeableCounter) {
		let rows = (cell.counter?.rows!)! + 1
		cell.counter?.ref?.updateChildValues(["rows": rows])
		let i = self.counters.firstIndex(of: cell.counter!)!
		self.counters[i].rows = rows
		if rows == cell.counter?.rowsMax {
			let alert = UIAlertController(title: "Congratulations!", message: "The Counter is done!", preferredStyle: UIAlertController.Style.alert)
			alert.addAction(UIAlertAction(title: "Hooray)", style: UIAlertAction.Style.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
		self.setLinkedCounters?(counters)
		self.countersView.collectionView.reloadData()
		AnalyticsService.reportEvent(with: "Add row")
	}
	
	private func removeRowToCounter(from cell: SwipeableCounter) {
		var rows = (cell.counter?.rows!)! - 1
		if rows <= 0 { rows = 0 }
		cell.counter?.ref?.updateChildValues(["rows": rows])
		let i = self.counters.firstIndex(of: cell.counter!)!
		self.counters[i].rows = rows
		if rows == cell.counter?.rowsMax {
			let alert = UIAlertController(title: "Congratulations!", message: "The Counter is done!", preferredStyle: UIAlertController.Style.alert)
			alert.addAction(UIAlertAction(title: "Hooray)", style: UIAlertAction.Style.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
		self.setLinkedCounters?(counters)
		self.countersView.collectionView.reloadData()
		AnalyticsService.reportEvent(with: "Add row")
	}
	
	private func openEditCounter(from cell: SwipeableCounter) {
		let vc = PanCounter(nibName: "PanCounter", bundle: nil)
		vc.currentProject = project
		vc.currentCounter = cell.counter
		vc.onEdit = { [weak self] counter in
			guard let self = self else { return }
			self.counters = self.counters.filter { $0 != cell.counter }
			self.counters.insert(counter, at: 0)
		}
		let vcModal : PanModalPresentable.LayoutType = PanelNavigation(vc)
		self.presentPanModal(vcModal)
		AnalyticsService.reportEvent(with: "Edit project")
	}
	
	private func deleteCounter(from cell: SwipeableCounter) {
		cell.counter?.ref?.removeValue()
		self.counters = self.counters.filter { $0 != cell.counter}
		AnalyticsService.reportEvent(with: "Delete project")
	}
	
	private func doubleCounter(from cell: SwipeableCounter) {
		guard let counter = cell.counter, let project = self.project else { return }
		var counterCopy = counter
		counterCopy.date = "\(Int(Date().timeIntervalSince1970))"
		counterCopy.name = counter.name! + "-Copy".localized()
		self.networkManager.saveCounter(project: project, counter: counterCopy)
		self.counters.insert(counterCopy, at: 0)
		self.setLinkedCounters?(counters)
		AnalyticsService.reportEvent(with: "Duplicate counter")
	}
	
	private func doStuff(counter: SwipeableCounter) {}
}
