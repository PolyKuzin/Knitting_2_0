//
//  CounterVC.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 26.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class CountersVC	: UIViewController {
	
	var currentProject						: MProject!
	
	let profileImageTaped					= Notification.Name(rawValue: profileImageInSectionNotificationKey)
	let newprojectViewTaped					= Notification.Name(rawValue: newprojectNotificationKey)
	
	//MARK:VARIABLES: Supporting Stuff
	
	private var collectionView				: UICollectionView!
	private var sections					: Array<MCounterSection> = []
	private var dataSourse					: UICollectionViewDiffableDataSource<MCounterSection, MCounter>?
	
	//MARK:VARIABLES: UI Elements

	//Animations stuff
	open var runningAnimations 				= [UIViewPropertyAnimator]()
	open var cardViewController      		: CardViewControllerProtocol!
	open var visualEffectView				: UIVisualEffectView!
	open var animationProgressWhenStopped	: CGFloat!
	open var cardHeight						: CGFloat!
	
	private var reloadMainVc				: Bool = false
	open var cardVisible					: Bool = false
	open var nextState						: CardState {
		return cardVisible 	? 	.collapsed	: .expanded
	}

	private var viewModel					: MainVM! {
		didSet {

		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		setupNormalNavBar()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		NotificationCenter.default.addObserver(self, selector: #selector(hideViewWithDeinit), name: Notification.Name(rawValue: "disconnectNewProjectVC"), object: nil)
		view.backgroundColor = .white
		viewModel = MainVM()
		setupVisualEffect	()
		setupSections		()
		self.setupCollectionView		()
		self.collectionView.reloadData	()
		self.view.sendSubviewToBack(self.collectionView)
		self.view.sendSubviewToBack(self.visualEffectView)
		self.reloadMainVc = true
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
}

//MARK: CollectionView Creating
extension CountersVC {
	
	func setupSections() {
		let currentUser		= Auth.auth().currentUser
		let user 			= MUser(user: currentUser!)
		guard let reference		= currentProject.ref?.child("counters") else { return }
		print(reference)
		self.sections.append(MCounterSection(type: "counters", title: "\(currentProject.name)", image: UIImageView(image: currentProject.image.toImage()!), buttom: UIButton(), counters: []))
		reference.observe(.value) { (snapshot) in
			self.sections[0].counters.removeAll()
			for item in snapshot.children {
				let counter = MCounter(snapshot: item as! DataSnapshot)
				if !self.sections[0].counters.contains(counter) {
					self.sections[0].counters.append(counter)
					self.sections[0].counters.sort(by: {
						return
								($0.date) > ($1.date)
					})
					var snapShot = NSDiffableDataSourceSnapshot<MCounterSection, MCounter>()
					snapShot.appendSections(self.sections)
					snapShot.appendItems(self.sections[0].counters)
					self.dataSourse?.apply(snapShot, animatingDifferences: true)
					self.collectionView.reloadData()
				}
			}
			self.collectionView.reloadData()
		}
	}
	
	func setupCollectionView() {
		collectionView						= UICollectionView(frame: view.bounds,
															   collectionViewLayout: createCompositionalLayout())
		collectionView.autoresizingMask		= [.flexibleWidth, .flexibleHeight]
		collectionView.backgroundColor		= .white
		collectionView.alwaysBounceVertical	= true
		
		collectionView.register(SectionHeader.self,
								forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
								withReuseIdentifier			: SectionHeader.reusedId)
		collectionView.register(CounterCell.self,
								forCellWithReuseIdentifier	: CounterCell.reuseId)
		createDataSourse()
		reloadData		()
		setUpLayout		()

	}
	
	func createCompositionalLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
			let section = self.sections[sectionIndex]
			switch section.type {
				default:
			return self.createProjectsSection()
			}
		}
		return layout
	}
	
	func createProjectsSection() -> NSCollectionLayoutSection {
		let itemSize				= NSCollectionLayoutSize			(widthDimension	:	.fractionalWidth(1.0),
																		 heightDimension:	.fractionalHeight(UIScreen.main.bounds.height / 6))
		let item					= NSCollectionLayoutItem			(layoutSize		:	itemSize)
		let groupSize				= NSCollectionLayoutSize			(widthDimension	:	.fractionalWidth(1.0),
																		 heightDimension:	.estimated(1.0))
		let group					= NSCollectionLayoutGroup.vertical	(layoutSize		: groupSize, subitems: [item])
		let section					= NSCollectionLayoutSection			(group: group)
		item.contentInsets			= NSDirectionalEdgeInsets.init		(top: 20,	leading: 0,		bottom: 20,	trailing: 0)
		section.contentInsets		= NSDirectionalEdgeInsets.init		(top: 20,	leading: 20,	bottom: 20,	trailing: 20)
		group.interItemSpacing		= .fixed(20)
		section.interGroupSpacing	= 15
		let header 					= createSectionHeader()
		section.boundarySupplementaryItems = [header]
		return section
	}
	
	func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
		let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension	:	.fractionalWidth(1),
															 heightDimension:	.estimated(1))
		let layoutSectionHeader		= NSCollectionLayoutBoundarySupplementaryItem(layoutSize	:	layoutSectionHeaderSize,
																				  elementKind	:	UICollectionView.elementKindSectionHeader,
																				  alignment		:	.top)
		return layoutSectionHeader
	}
}

//MARK: CollectionView DataSourse
extension CountersVC {
	
	func createDataSourse() {
		dataSourse = UICollectionViewDiffableDataSource<MCounterSection, MCounter>(collectionView: collectionView,
																			cellProvider: { (collectionView, indexPath, project) -> UICollectionViewCell? in
			switch self.sections[indexPath.section].type {
			default:
				let counter = self.sections[0].counters[indexPath.row]
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CounterCell.reuseId, for: indexPath) as! CounterCell
				cell.delegate = self
				cell.configurу(with: counter)

				cell.plusButton.tag = indexPath.row
				cell.minusButton.tag = indexPath.row
				cell.plusButton.addTarget(self, action: #selector(self.plusBtnTaped(_:)), for: .touchUpInside)
				cell.minusButton.addTarget(self, action: #selector(self.minusBtnTaped(_:)), for: .touchUpInside)
				cell.plusButton.isUserInteractionEnabled = true
				cell.minusButton.isUserInteractionEnabled = true
				cell.isSelected = false
				
				if project.name == "knitting-f824f" {
//					cell.isHidden = true
				} else {
					cell.isHidden = false
				}
				return cell
			}
		})
		dataSourse?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
			guard let sectionHeader		= collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reusedId, for: indexPath) as? SectionHeader
				else { return nil }
			guard let firstProject		= self?.dataSourse?.itemIdentifier(for: indexPath)
				else { return nil }
			guard let section			= self?.dataSourse?.snapshot().sectionIdentifier(containingItem: firstProject)
				else { return nil}
			if section.title.isEmpty { return nil}
			sectionHeader.title.text	= "\(self!.currentProject.name)"
			let image = self!.currentProject.image.toImage()!
			sectionHeader.profileImage.image = image
//			let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainVC.handleCardTap(recognizer:)))
//			sectionHeader.profileImage.addGestureRecognizer(tapGestureRecognizer)
			return sectionHeader
		}
	}
	
	@objc func plusBtnTaped (_ sender: UIButton) {
		let tag = sender.tag
		let indexPath = IndexPath(row: tag, section: 0)
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CounterCell.reuseId, for: indexPath) as! CounterCell
		let currentCounter = sections[0].counters[indexPath.row]
		cell.currentRows.text = String(currentCounter.rows + 1)
		currentCounter.ref?.updateChildValues(["rows": Int(cell.currentRows.text!)!])
//		if Int(cell.currentRows.text!)! == currentCounter.rowsMax && currentCounter.congratulations == false {
//			congatulatuionsIn()
//			currentCounter.ref?.updateChildValues(["congratulations" : true])
//		}
		collectionView.reloadData()
	}
	@objc func minusBtnTaped(_ sender: UIButton){
		let tag = sender.tag
		let indexPath = IndexPath(row: tag, section: 0)
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CounterCell.reuseId, for: indexPath) as! CounterCell
		let currentCounter = sections[0].counters[indexPath.row]
		cell.currentRows.text = String(currentCounter.rows - 1)
		currentCounter.ref?.updateChildValues(["rows": Int(cell.currentRows.text!)!])
		if currentCounter.rows <= 0 {
			currentCounter.ref?.updateChildValues(["rows": 0])
		}
		
		var snapShot = NSDiffableDataSourceSnapshot<MCounterSection, MCounter>()
		snapShot.reloadSections(sections)
		self.dataSourse?.apply(snapShot, animatingDifferences: true)
		self.collectionView.reloadData()
	}
	
	func reloadData() {
		if self.sections[0].counters.isEmpty {
			let counter = MCounter(name: "knitting-f824f", rows: 123, rowsMax: 123, date: "123")
			self.sections[0].counters.append(counter)
		}
		var snapShot = NSDiffableDataSourceSnapshot<MCounterSection, MCounter>()
		snapShot.appendSections(sections)
		for section in sections {
			snapShot.appendItems(section.counters, toSection: section)
		}
		dataSourse?.apply(snapShot, animatingDifferences: true)
	}
}

//MARK: Setting up cards
extension CountersVC {
	
	@objc
	func updateCardViewControllerWithProfileVC(notification: NSNotification) {
		cardHeight = 320
		setupCardViewController(ProfileCardVC())
	}
	
	@objc
	func updateCardViewControllerWithNewProjectVC(notification: NSNotification) {
		cardHeight = 500
		setupCardViewController(NewProjectVC())
	}
	
	func setupVisualEffect() {
		visualEffectView = UIVisualEffectView()
		visualEffectView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
		self.view.addSubview(visualEffectView)
		self.view.sendSubviewToBack(visualEffectView)
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainVC.visualEffectTaped(recognzier:)))
		tapGestureRecognizer.numberOfTapsRequired = 1
		visualEffectView.addGestureRecognizer(tapGestureRecognizer)
	}
	
	func setupCardViewController(_ cardVC: CardViewControllerProtocol) {
		cardViewController	= cardVC
		self.addChild(cardViewController)
		self.view.insertSubview(cardViewController.view, at: 3)
		cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.bounds.width, height: cardHeight)
		cardViewController.view.clipsToBounds = true
		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(MainVC.handleCardPan(recognizer:)))
		cardViewController.handle.addGestureRecognizer	(panGestureRecognizer)
	}
}

//MARK: Gesture Selectors
extension CountersVC {
	
	@objc
	func visualEffectTaped	(recognzier: UITapGestureRecognizer) {
		hideViewWithDeinit()
	}
	
	@objc
	func newProjectTaped	(recognizer: UITapGestureRecognizer) {
		NotificationCenter.default.addObserver(self, selector: #selector(MainVC.updateCardViewControllerWithNewProjectVC(notification:)), name: newprojectViewTaped, object: nil)
		let name = Notification.Name(rawValue: newprojectNotificationKey)
		NotificationCenter.default.post(name: name, object: nil)
		switch recognizer.state {
		case .ended		:
			animateTransitionIfNeeded(state: nextState, duration: 0.9)
		default			:
			break
		}
	}
	
	@objc
	func handleCardTap		(recognizer: UITapGestureRecognizer) {
		
		NotificationCenter.default.addObserver(self, selector: #selector(MainVC.updateCardViewControllerWithProfileVC(notification:)), name: profileImageTaped, object: nil)
		let name = Notification.Name(rawValue: profileImageInSectionNotificationKey)
		NotificationCenter.default.post(name: name, object: nil)
		switch recognizer.state {
		case .ended		:
			animateTransitionIfNeeded(state: nextState, duration: 0.9)
		default			:
			break
		}
	}
	
	@objc
	func handleCardPan		(recognizer: UIPanGestureRecognizer) {
		switch recognizer.state {
		case .began		:
			startInteractiveTransition(state: nextState, duration: 0.9)
		case .changed	:
			let translation			= recognizer.translation(in: self.cardViewController.handle)
			var fractionComplete	= translation.y / cardHeight
			fractionComplete		= cardVisible ? fractionComplete : -fractionComplete
			updateInteractiveTransition(fractionCompleted: fractionComplete)
		case .ended		:
			continueInteractiveTransition()
		default			:
			break
		}
	}
	
	@objc
	func hideViewWithDeinit() {
		let seconds = 0.3
		animateTransitionIfNeeded(state: nextState, duration: 0.3)
		DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
			NotificationCenter.default.removeObserver(self, name: self.profileImageTaped, object: nil)
			NotificationCenter.default.removeObserver(self, name: self.newprojectViewTaped, object: nil)
			self.teardownCardView()
		}
	}
}

//MARK: Swipeable Collection View Cell Delegate
extension CountersVC: SwipeableCollectionViewCellDelegate {
	
	func hiddenContainerViewTapped(inCell cell: UICollectionViewCell) {
		guard let indexPath = collectionView.indexPath(for: cell) else { return }
		let project = sections[0].counters[indexPath.row]
		project.ref?.removeValue()
		var snap = dataSourse?.snapshot()
		snap?.deleteItems([sections[0].counters[indexPath.row]])
		sections[0].counters.remove(at: indexPath.row)

		dataSourse?.apply(snap!, animatingDifferences: true)
		self.collectionView.reloadData()

	}
	
	func visibleContainerViewTapped(inCell cell: UICollectionViewCell) {
		
	}
}

//MARK: Layout
extension CountersVC {
	
	func setupNormalNavBar() {
		//Navigation Bar scould be invisible with back arrow
		let backIcon = Icons.backIcon
		guard let navigationController = navigationController else { return }
		navigationController.navigationBar.backIndicatorImage														= backIcon
		navigationController.navigationBar.backIndicatorTransitionMaskImage											= backIcon
		navigationController.navigationBar.topItem?.title 															= ""
		navigationController.navigationBar.tintColor 																= Colors.backIcon		
	}
	
	func setUpClearNavBar() {
		guard let navigationController = navigationController else { return }
		navigationController.navigationBar.alpha			= 0.7
		navigationController.navigationBar.shadowImage 		= UIImage()
		navigationController.navigationBar.isTranslucent	= true
		navigationController.view.backgroundColor			= .clear
		navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
	}
	
	func setUpLayout() {
		//Projects collection View Layout
		view.addSubview(collectionView)
		view.insertSubview(collectionView, at: 0)
		collectionView.translatesAutoresizingMaskIntoConstraints										= false
		collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive 				= true
		collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive 							= true
		collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive 					= true
		collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive					= true
	}
	
	func teardownCardView() {
		self.setupNormalNavBar()
		runningAnimations.removeAll()
		cardViewController.removeFromParent()
		cardViewController.view.removeFromSuperview()
		self.collectionView.reloadData()
		self.view.insertSubview(self.visualEffectView, at: 0)
	}
}
