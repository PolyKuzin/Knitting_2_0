//
//  NewMainController.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 12.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit
import PanModal
import AppstoreTransition

class ProjectsController : BaseVC, CardsViewController {
	
	private var projects       = [Project]() {
		didSet {
			(projects.isEmpty) ? (self.makeErrorState(with: .noData)) : (self.makeLoadedState(with: projects))
		}
	}
	private var projectsView   = ProjectsView.loadFromNib()
	private var networkManager = NetworkManager.shared
	private var transition     : CardTransition?

	override func loadView() {
		super.loadView()
		projectsView.onProfile    = { [weak self] in
			guard let self = self else { return }
			self.openProfile()
		}
		projectsView.onNewProject = { [weak self] in
			guard let self = self else { return }
			self.openNewProject()
		}
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
				self.projects = projects
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
													 onVisibleProject : self.openProject(from:),
													 onEditProject    : self.openEditProject(from:),
													 onDeleteProject  : self.deleteProject(from:),
													 onDoubleProject  : self.doubleProject(from:))
		}
		projectsView.viewState = .loaded(loadState)
	}
	
	private func openProfile() {
		let vc = PanProfileVC(nibName: "PanProfileVC", bundle: nil)
		let vcModal : PanModalPresentable.LayoutType = PanelNavigation(vc)
		self.presentPanModal(vcModal)
	}
	
	private func openNewProject() {
		let vc = PanProject(nibName: "PanProject", bundle: nil)
		vc.onSave = { [weak self] project in
			guard let self = self else { return }
			self.projects.insert(project, at: 0)
		}
		let vcModal : PanModalPresentable.LayoutType = PanelNavigation(vc)
		self.presentPanModal(vcModal)
	}
	
	private func openProject(from cell: SwipeableProject) {
		cell.settings.cardContainerInsets = UIEdgeInsets(top: -75, left: 0, bottom: 0, right: 0)
		transition = CardTransition(cell: cell, settings: cell.settings)
		let detailController = CountersController(project: cell.project!)
		detailController.settings = cell.settings
		detailController.transitioningDelegate = transition
		detailController.modalPresentationStyle = .custom
		detailController.setLinkedCounters = { [weak self] counters in
			guard let self = self else { return }
			let i = self.projects.firstIndex(of: cell.project!)!
			self.projects[i].linkedCounters = counters
		}
		presentExpansion(detailController, cell: cell, animated: true)
	}
	
	private func openEditProject(from cell: SwipeableProject) {
		let vc = PanProject(nibName: "PanProject", bundle: nil)
		vc.currentProject = cell.project
		vc.onEdit = { [weak self] project in
			guard let self = self else { return }
			self.projects = self.projects.filter { $0 != cell.project}
			self.projects.insert(project, at: 0)
		}
		let vcModal : PanModalPresentable.LayoutType = PanelNavigation(vc)
		self.presentPanModal(vcModal)
		AnalyticsService.reportEvent(with: "Edit project")
	}
	
	private func deleteProject(from cell: SwipeableProject) {
		cell.project?.ref?.removeValue()
		self.projects = self.projects.filter { $0 != cell.project}
		AnalyticsService.reportEvent(with: "Delete project")
	}
	
	// TODO: Добавить дублирование счётчиков
	private func doubleProject(from cell: SwipeableProject) {
		guard let project = cell.project else { return }
		var projectCopy = project
		projectCopy.date = "\(Int(Date().timeIntervalSince1970))"
		projectCopy.name = project.name! + "-Copy".localized()
		self.networkManager.saveProject(project: projectCopy)
		self.projects.insert(projectCopy, at: 0)
		AnalyticsService.reportEvent(with: "Duplicate project")
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
}
