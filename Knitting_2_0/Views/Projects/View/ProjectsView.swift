//
//  NewMainVC.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 11.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit
import PanModal
import AppstoreTransition

enum SectionType {
	case counters
	case projects
	case title
	case none
}

struct Section {
	var type     : SectionType?
	var rows     : [Any]
	var title    : String?
	var onSelect : (()->())?
}

protocol _ViewState {
	var sections : [Section] { get set }
}

class ProjectsView : UIView {
	
	public var onProfile    : (()->())?
	public var onNewProject : (()->())?
	
	@IBOutlet weak var addButton      : MainButton!
	@IBOutlet weak var collectionView : UICollectionView!
	
	struct ViewState             : _ViewState         {
		
		var sections             : [Section]
		
		enum State                                    {
			case loading (Loading)
			case error   (Error)
			case loaded  ([ProjectItem])
		}
		
		struct Loading            : _Loading          {
			var title            : String
		}
		
		struct Error              : _Error            {
			var title            : String
			var image            : UIImage?
			var onSelect         : (() -> ())
		}
		
		struct ProjectItem        : _SwipeableProject {
			var project          : Project
			var onVisibleProject : ((SwipeableProject)->())
			var onEditProject    : ((SwipeableProject)->())
			var onDeleteProject  : ((SwipeableProject)->())
			var onDoubleProject  : ((SwipeableProject)->())
		}
		
		static let initial = ViewState(sections: [])
	}
	
	public var viewState : ViewState.State = .loading(getRandomLoading()) {
		didSet {
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
	}
	
	static private func getRandomLoading() -> ViewState.Loading {
		let resp = ViewState.Loading(title: "Loading...")
		return resp
	}
	
	override func awakeFromNib() {
		self.addButton.setTitle("+ Create project".localized())
		self.addButton.addTarget(self, action: #selector(self.newProjectTaped), for: .touchUpInside)
		self.collectionView.delegate   = self
		self.collectionView.dataSource = self
		self.collectionView.register(ErrorCell.nib,          forCellWithReuseIdentifier: ErrorCell.reuseId)
		self.collectionView.register(LoadingCell.nib,        forCellWithReuseIdentifier: LoadingCell.reuseId)
		self.collectionView.register(SwipeableProject.nib,   forCellWithReuseIdentifier: SwipeableProject.reuseId)
		self.collectionView.register(ProjectsHeaderView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProjectsHeaderView.reuseId)
	}
	
	@objc
	func newProjectTaped() {
		self.onNewProject?()
	}
}

// MARK: - Delegate
extension ProjectsView : UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProjectsHeaderView.reuseId, for: indexPath) as? ProjectsHeaderView
		else { return UICollectionReusableView() }
		header.configure(title: "Working on this?".localized(), action: onProfile!)
		return header
	}
}

// MARK: - DelegateFlowLayout
extension ProjectsView : UICollectionViewDelegateFlowLayout {
	
	// TODO: Определиться с высотой ячейки
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		switch self.viewState {
		case .loaded(_):
			return CGSize(width: UIScreen.main.bounds.width - 40, height: 130)
		default:
			return CGSize(width: UIScreen.main.bounds.width - 40, height: 300)
		}
	}
}

// MARK: - DataSource
extension ProjectsView : UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch self.viewState {
		case .loaded(let items):
			return items.count
		default:
			return 1
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		switch self.viewState {
		case .loading          :
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseId, for: indexPath) as! LoadingCell
			return cell
		case .error(let err)   :
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ErrorCell.reuseId, for: indexPath) as! ErrorCell
			cell.configure(with: err)
			return cell
		case .loaded(let rows) :
			switch rows[indexPath.row] {
			case is ViewState.ProjectItem:
				let row = rows[indexPath.row]
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SwipeableProject.reuseId, for: indexPath) as! SwipeableProject
				cell.configure(with: row)
				return cell
			default:
				return UICollectionViewCell()
			}
		}
	}
}
