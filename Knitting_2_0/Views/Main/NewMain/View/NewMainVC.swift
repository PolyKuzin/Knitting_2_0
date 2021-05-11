//
//  NewMainVC.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 11.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit
import PanModal
import FirebaseAuth
import FirebaseDatabase

let animationDuration = 0.7

class NewMainVC : BaseVC {
	
	private var user   : MUser!
	private var ref    : DatabaseReference!
	
	@IBOutlet weak var addButton      : MainButton!
	@IBOutlet weak var collectionView : UICollectionView!
	
	struct ViewState {
		
		enum State {
			case loading
			case error
			case loaded([ProjectItem])
		}
		
		struct ProjectItem {
			
		}
		
		static let initial = ViewState()
	}
	
	public var viewState : ViewState.State = .loading {
		didSet {
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		setupNormalNavBar()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let appDelegate = UIApplication.shared.delegate as? AppDelegate
		appDelegate?.scheduleNotification()
		guard let currentUser = Auth.auth().currentUser else { return }
		user	= MUser(user: currentUser)
		ref		= Database.database().reference(withPath: "users").child(String(user.uid))
		collectionView.delegate		= self
		collectionView.dataSource	= self
//		setupSections		()
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
}

// MARK: - Delegate
extension NewMainVC : UICollectionViewDelegate {
	
}

// MARK: - DelegateFlowLayout
extension NewMainVC : UICollectionViewDelegateFlowLayout {
	
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
extension NewMainVC : UICollectionViewDataSource {
	
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
		
		default:
			return UICollectionViewCell()
		}
	}
}
