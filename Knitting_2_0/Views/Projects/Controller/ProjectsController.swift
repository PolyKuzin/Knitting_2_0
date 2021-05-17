//
//  NewMainController.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 12.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit
import PanModal

class ProjectsController : BaseVC {
	
	private var newMainView    = ProjectsView.loadFromNib()
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
				self.makeLoadedState(with: projects)
			}
		}
	}
	
	private func makeErrorState(with data: KnitError) {
		let errState = ProjectsView.ViewState.Error(title: "БЛЯ ОШИБКА", image: UIImage(named: "_0"), onSelect: {})
		newMainView.viewState = .error(errState)
	}
	
	private func makeLoadedState(with data: [Project]) {
		let loadState : [ProjectsView.ViewState.ProjectItem] = data.map {
			
			return ProjectsView.ViewState.ProjectItem(project          : $0,
													 onVisibleProject : self.doStuf(data:),
													 onEditProject    : self.doStuf(data:),
													 onDeleteProject  : self.deleteProject(project:),
													 onDoubleProject  : self.doStuf(data:))
		}
		newMainView.viewState = .loaded(loadState)
	}
	
	private func deleteProject(project: Project) {
//		project.ref?.removeValue()
//		var snap = dataSourse?.snapshot()
//		snap?.deleteItems([projects[indexPath.row]])
//		projects.remove(at: indexPath.row)
//		dataSourse?.apply(snap!, animatingDifferences: true)
//		self.collectionView.reloadData()
//
//		let leftOffset = CGPoint(x: 0, y: 0)
//		cell.scrollView.setContentOffset(leftOffset, animated: true)
//		DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
//			self.view.isUserInteractionEnabled = true
//		}
//		AnalyticsService.reportEvent(with: "Delete project")
	}
	
	private func doStuf(data: Project) {
		print(data.name)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
}
