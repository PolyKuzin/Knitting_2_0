//
//  CountersView.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 17.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

class CountersView : UIView {
	
	public var project      : Project?
	public var onDismiss    : (()->())?
	public var onAddCounter : (()->())?

	@IBOutlet weak var collectionView : UICollectionView!
	
	struct ViewState : _ViewState                     {
		
		var header   : ProjectsView
		var sections : [Section]
		
		enum State                                    {
			case loading (Loading)
			case error   (Error)
			case loaded  ([CounterItem])
		}
		
		struct Loading            : _Loading          {
			var title            : String
		}
		
		struct Error              : _Error            {
			var title            : String
			var image            : UIImage?
			var onSelect         : (() -> ())
		}
		
		struct CounterItem        : _SwipeableCounter {
			var counter          : Counter
			var onPlusRow        : ((SwipeableCounter)->())
			var onMinusRow       : ((SwipeableCounter)->())
			var onVisibleCounter : ((SwipeableCounter)->())
			var onEditCounter    : ((SwipeableCounter)->())
			var onDeleteCounter  : ((SwipeableCounter)->())
			var onDoubleCounter  : ((SwipeableCounter)->())
		}
		
		static let initial = ViewState(header: ProjectsView.loadFromNib(), sections: [])
	}
	
	public var viewState : ViewState = .initial {
		didSet {
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
	}
	
	public var state : ViewState.State = .loading(getRandomLoading()) {
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
		self.collectionView.delegate   = self
		self.collectionView.dataSource = self
		self.collectionView.register(ErrorCell.nib,        forCellWithReuseIdentifier: ErrorCell.reuseId)
		self.collectionView.register(LoadingCell.nib,      forCellWithReuseIdentifier: LoadingCell.reuseId)
		self.collectionView.register(SwipeableCounter.nib, forCellWithReuseIdentifier: SwipeableCounter.reuseId)
		self.collectionView.register(CountersHeader.nib,   forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CountersHeader.reuseId)
	}
}

// MARK: - Delegate
extension CountersView : UICollectionViewDelegate {
	
	private func back() {
		self.onDismiss?()
	}
	
	private func addCounter() {
		self.onAddCounter?()
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CountersHeader.reuseId, for: indexPath) as? CountersHeader
		else { return UICollectionReusableView() }
		header.configure(with: (self.project!, self.back, self.addCounter))
		return header
	}
}

// MARK: - DelegateFlowLayout
extension CountersView : UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		switch self.state {
		case .loaded(_):
			return CGSize(width: UIScreen.main.bounds.width - 40, height: 130)
		default:
			return CGSize(width: UIScreen.main.bounds.width - 40, height: 300)
		}
	}
}

// MARK: - DataSource
extension CountersView : UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch self.state {
		case .loaded(let items):
			return items.count
		default:
			return 1
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		switch self.state {
		case .loading          :
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseId, for: indexPath) as! LoadingCell
			return cell
		case .error(let err)   :
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ErrorCell.reuseId, for: indexPath) as! ErrorCell
			cell.configure(with: err)
			return cell
		case .loaded(let rows) :
			switch rows[indexPath.row] {
			case is ViewState.CounterItem:
				let row = rows[indexPath.row] as! ViewState.CounterItem
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SwipeableCounter.reuseId, for: indexPath) as! SwipeableCounter
				cell.configure(with: row)
				return cell
			default:
				return UICollectionViewCell()
			}
		}
	}
}
