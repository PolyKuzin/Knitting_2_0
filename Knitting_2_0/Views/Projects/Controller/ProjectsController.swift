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
	
	private var projects       = [Project]()
	private var projectsView   = ProjectsView.loadFromNib()
	private var networkManager = NetworkManager.shared

	override func loadView() {
		super.loadView()
		self.view = projectsView
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
		projectsView.viewState = .error(errState)
	}
	
	private func makeLoadedState(with data: [Project]) {
		let loadState : [ProjectsView.ViewState.ProjectItem] = data.map {
			
			return ProjectsView.ViewState.ProjectItem(project          : $0,
													 onVisibleProject : self.showCounters(for:),
													 onEditProject    : self.doStuf(data:),
													 onDeleteProject  : self.deleteProject(project:),
													 onDoubleProject  : self.doStuf(data:))
		}
		projectsView.viewState = .loaded(loadState)
	}
	
	private func showCounters(for project: Project) {
		let vc = CountersController(project: project)
		guard let navigationController = navigationController else { return }
		navigationController.pushViewController(vc, animated: true)
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
