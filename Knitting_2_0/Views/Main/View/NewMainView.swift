//
//  NewMainVC.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 11.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

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

class NewMainView : UIView {
	
	public var onAddButtonTap         : (()->())?
	public var onProjectTap           : (()->())?
	public var onDeleteProjectTap     : (()->())?
	public var onEditProjectTap       : (()->())?
	public var onDuplicateProjectTap  : (()->())?
	
	@IBOutlet weak var addButton      : MainButton!
	@IBOutlet weak var collectionView : UICollectionView!
	
	struct ViewState : _ViewState {
		
		var sections : [Section]
		
		enum State {
			case loading
			case error
			case loaded([ProjectItem])
		}
		
		struct ProjectItem {
			
		}
		
		static let initial = ViewState(sections: [])
	}
	
	public var viewState : ViewState.State = .loading {
		didSet {
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
	}
	
	override func awakeFromNib() {
//		self.collectionView.delegate   = self
//		self.collectionView.dataSource = self
//		self.collectionView.register(LoadingCell.nib, forCellWithReuseIdentifier: LoadingCell.reuseId)
//		self.collectionView.register(ProjectCell.self, 	forCellWithReuseIdentifier: ProjectCell.reuseId)
	}
}

// MARK: - Delegate
extension NewMainView : UICollectionViewDelegate {
	
}

// MARK: - DelegateFlowLayout
extension NewMainView : UICollectionViewDelegateFlowLayout {
	
	// TODO: Определиться с высотой ячейки
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		switch self.viewState {
		case .loaded(_):
			return CGSize(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height / 5.5)
		default:
			return CGSize(width: UIScreen.main.bounds.width - 40, height: 300)
		}
	}
}

// MARK: - DataSource
extension NewMainView : UICollectionViewDataSource {
	
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
		case .loading :
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseId, for: indexPath) as! LoadingCell
			return cell
		default:
			return UICollectionViewCell()
		}
	}
}
