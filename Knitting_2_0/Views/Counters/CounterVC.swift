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

class CountersVC	: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
	
	var currentProject						: MProject!
	
	let creeateCounterTaped					= Notification.Name(rawValue: createCounterInSectionNotificationKey)
	let editCounterViewTaped				= Notification.Name(rawValue: editCounterNotificationKey)
	
	//MARK:VARIABLES: Supporting Stuff
	
	let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
	private var counters					: [MCounter] = []
	private var dataSourse					: UICollectionViewDiffableDataSource<MCounterSection, MCounter>?
	
	//MARK:VARIABLES: UI Elements

	open var runningAnimations 				= [UIViewPropertyAnimator]()
	open var cardViewController      		: CardViewControllerProtocol!
	open var visualEffectView				: UIVisualEffectView!
	open var animationProgressWhenStopped	: CGFloat!
	open var cardHeight						: CGFloat!
	
	open var cardVisible					: Bool = false
	open var nextState						: CardState {
		return cardVisible 	? 	.collapsed	: .expanded
	}
	
	var currentCounter : MCounter?
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		setupNormalNavBar()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		collectionView.reloadData()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		setupVisualEffect	()
		setupSections		()

		collectionView.delegate		= self
		collectionView.dataSource	= self
		setupCollectionConstraints()
		
		self.view.sendSubviewToBack(self.collectionView)
		self.view.sendSubviewToBack(self.visualEffectView)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(true)
		self.dismiss(animated: true, completion: nil)
	}
	
	let collectionView: UICollectionView = {
		let layout					= UICollectionViewFlowLayout()
		layout.scrollDirection		= .vertical
		layout.itemSize				= CGSize(width: UIScreen.main.bounds.width - 40,	height: UIScreen.main.bounds.height / 6)
		layout.headerReferenceSize	= CGSize(width: UIScreen.main.bounds.width, 		height: 200)
		
		let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: layout)
		cv.backgroundColor = .white
		cv.alwaysBounceVertical = true
		cv.register(CounterCell.self, 	forCellWithReuseIdentifier: CounterCell.reuseId)
		cv.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reusedId)
		
		return cv
		}()
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reusedId, for: indexPath) as! SectionHeader

		header.frame = CGRect(x: 0 , y: 0, width: self.view.frame.width, height: 200)
		header.profileImage.image = currentProject.image.toImage()
		header.title.text			= currentProject.name
		header.isUserInteractionEnabled = true
		let tap = UITapGestureRecognizer(target: self, action: #selector(CountersVC.creeateCounterTaped(recognizer:)))
		header.createCounter.addGestureRecognizer(tap)
		header.createCounter.isMultipleTouchEnabled = false
		return header
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return counters.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let counter 	= counters[indexPath.row]
		let cell		= collectionView.dequeueReusableCell(withReuseIdentifier: CounterCell.reuseId, for: indexPath) as! CounterCell
		
		cell.configurу(with: counter)
		cell.plusButton	.tag = indexPath.row
		cell.minusButton.tag = indexPath.row
		cell.plusButton	.addTarget(self, action: #selector(self.plusBtnTaped(_:)),	for: .touchUpInside)
		cell.minusButton.addTarget(self, action: #selector(self.minusBtnTaped(_:)), for: .touchUpInside)
		cell.plusButton	.isUserInteractionEnabled = true
		cell.minusButton.isUserInteractionEnabled = true
		cell.delegate 	= self
		cell.isSelected = false
		
		if counter.name == "knitting-f824f" {
			cell.isHidden = true
		} else {
			cell.isHidden = false
		}
		return cell
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: .alert)
}

//MARK: CollectionView Creating
extension CountersVC {
	
	func setupSections() {
		guard let reference		= currentProject.ref?.child("counters") else { return }
		reference.observe(.value) { (snapshot) in
			self.counters.removeAll()
			for item in snapshot.children {
				let counter = MCounter(snapshot: item as! DataSnapshot)
				if !self.counters.contains(counter) {
					self.counters.append(counter)
					self.counters.sort(by: {
						return
								($0.date) > ($1.date)
					})
					self.collectionView.reloadData()
				}
			}
			self.collectionView.reloadData()
		}
	}
}

//MARK: Setting up cards
extension CountersVC {
	
	@objc
	func updateCardViewControllerWithProfileVC(notification: NSNotification) {
		cardHeight = 400
		let vc = NewCounterVC()
		vc.currentProject = currentProject
		NotificationCenter.default.addObserver(self, selector: #selector(hideViewWithDeinit), name: Notification.Name(rawValue: "disconnectNewCounterVC"), object: nil)
		setupCardViewController(vc)
	}
	
	@objc
	func updateCardViewControllerWithEditCountertVC(notification: NSNotification) {
		cardHeight = 500
		let vc = EditCounterVC()
		vc.currentCounter = self.currentCounter
		NotificationCenter.default.addObserver(self, selector: #selector(hideViewWithDeinit), name: Notification.Name(rawValue: "disconnectEditCounterVC"), object: nil)
		setupCardViewController(vc)
	}
	
	func setupVisualEffect() {
		visualEffectView = UIVisualEffectView()
		visualEffectView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
		self.view.addSubview(visualEffectView)
		self.view.sendSubviewToBack(visualEffectView)
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CountersVC.visualEffectTaped(recognzier:)))
		tapGestureRecognizer.numberOfTapsRequired = 1
		visualEffectView.addGestureRecognizer(tapGestureRecognizer)
	}
	
	func setupCardViewController(_ cardVC: CardViewControllerProtocol) {
		cardViewController	= cardVC
		self.addChild(cardViewController)
		self.view.insertSubview(cardViewController.view, at: 3)
		cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.bounds.width, height: cardHeight)
		cardViewController.view.clipsToBounds = true
		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(CountersVC.handleCardPan(recognizer:)))
		cardViewController.handle.addGestureRecognizer	(panGestureRecognizer)
	}
}

//MARK: Gesture Selectors
extension CountersVC {
	
	@objc
	func plusBtnTaped (_ sender: UIButton) {
		let tag = sender.tag
		let indexPath = IndexPath(row: tag, section: 0)
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CounterCell.reuseId, for: indexPath) as! CounterCell
		let currentCounter = counters[indexPath.row]
		cell.currentRows.text = String(currentCounter.rows + 1)
		currentCounter.ref?.updateChildValues(["rows": Int(cell.currentRows.text!)!])
		collectionView.reloadData()
	}
	@objc
	func minusBtnTaped(_ sender: UIButton){
		let tag = sender.tag
		let indexPath = IndexPath(row: tag, section: 0)
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CounterCell.reuseId, for: indexPath) as! CounterCell
		let currentCounter = counters[indexPath.row]
		cell.currentRows.text = String(currentCounter.rows - 1)
		
		currentCounter.ref?.updateChildValues(["rows": Int(cell.currentRows.text!)!])
		if currentCounter.rows <= 0 {
			currentCounter.ref?.updateChildValues(["rows": 0])
		}
		collectionView.reloadData()
	}
	
	@objc
	func visualEffectTaped	(recognzier: UITapGestureRecognizer) {
		hideViewWithDeinit()
	}
	
	@objc
	func creeateCounterTaped(recognizer: UITapGestureRecognizer) {
		self.view.isUserInteractionEnabled = false
		NotificationCenter.default.addObserver(self, selector: #selector(CountersVC.updateCardViewControllerWithProfileVC(notification:)), name: creeateCounterTaped, object: nil)
		let name = Notification.Name(rawValue: createCounterInSectionNotificationKey)
		NotificationCenter.default.post(name: name, object: nil)
		switch recognizer.state {
		case .ended		:
			animateTransitionIfNeeded(state: nextState, duration: 0.9)
		default			:
			break
		}
		let seconds = 0.3
		DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
			self.view.isUserInteractionEnabled = true
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
			NotificationCenter.default.removeObserver(self, name: self.creeateCounterTaped, object: nil)
			NotificationCenter.default.removeObserver(self, name: self.editCounterViewTaped, object: nil)
			self.teardownCardView()
		}
	}
}

//MARK: Swipeable Collection View Cell Delegate
extension CountersVC: SwipeableCollectionViewCellDelegate {
	
	func editContainerViewTapped(inCell cell: SwipeableCollectionViewCell) {
		self.view.isUserInteractionEnabled = false
		guard let indexPath = collectionView.indexPath(for: cell) else { return }
		let counter = counters[indexPath.row]
		
		let recognizer = UITapGestureRecognizer()
		recognizer.state = .ended
		
		self.currentCounter = counter
		
		NotificationCenter.default.addObserver(self, selector: #selector(CountersVC.updateCardViewControllerWithEditCountertVC(notification:)), name: editCounterViewTaped, object: nil)
		let name = Notification.Name(rawValue: editCounterNotificationKey)
		NotificationCenter.default.post(name: name, object: nil)
		switch recognizer.state {
		case .ended		:
			animateTransitionIfNeeded(state: nextState, duration: 0.9)
		default			:
			break
		}
		let leftOffset = CGPoint(x: 0, y: 0)
		cell.scrollView.setContentOffset(leftOffset, animated: true)
		let seconds = 0.3
		DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
			self.view.isUserInteractionEnabled = true
		}
	}
	
	func deleteContainerViewTapped(inCell cell: SwipeableCollectionViewCell) {
		guard let indexPath = collectionView.indexPath(for: cell) else { return }
		let project = counters[indexPath.row]
		project.ref?.removeValue()
		self.collectionView.reloadData()
		let leftOffset = CGPoint(x: 0, y: 0)
		cell.scrollView.setContentOffset(leftOffset, animated: true)
	}
	
	func visibleContainerViewTapped(inCell cell: SwipeableCollectionViewCell) {
		
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
		navigationController.view.backgroundColor			= .white
		navigationController.navigationBar.isTranslucent	= false
	}
	
	func setUpClearNavBar() {
		guard let navigationController = navigationController else { return }
		navigationController.navigationBar.alpha			= 0.7
		navigationController.navigationBar.shadowImage 		= UIImage()
		navigationController.navigationBar.isTranslucent	= true
		navigationController.view.backgroundColor			= .clear
		navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
	}
	
	func setupCollectionConstraints() {
		view.addSubview(collectionView)
		view.insertSubview(collectionView, at: 0)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
	}
	
	func teardownCardView() {
		self.setupNormalNavBar()
		runningAnimations.removeAll()
		cardViewController.removeFromParent()
		cardViewController.view.removeFromSuperview()
		NotificationCenter.default.removeObserver(self)
		self.view.insertSubview(self.visualEffectView, at: 0)
	}
}
