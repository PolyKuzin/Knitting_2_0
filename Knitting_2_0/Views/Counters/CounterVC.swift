//
//  CounterVC.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 26.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit
import PanModal
import FirebaseAuth
import FirebaseDatabase

class CountersVC	: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
	
	var activityView: UIActivityIndicatorView?
	
	var currentProject						: MProject!
	private var ref             	: DatabaseReference!
	
	let creeateCounterTaped					= Notification.Name(rawValue: createCounterInSectionNotificationKey)
	let editCounterViewTaped				= Notification.Name(rawValue: editCounterNotificationKey)
	
	//MARK:VARIABLES: Supporting Stuff
	
	let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
	private var counters					: [MCounter] = []
	private var dataSourse					: UICollectionViewDiffableDataSource<MCounterSection, MCounter>?
	
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
		ref		= currentProject.ref?.child("counters")
		setupSections		()

		collectionView.delegate		= self
		collectionView.dataSource	= self
		setupCollectionConstraints()
		
		self.view.sendSubviewToBack(self.collectionView)
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
			AnalyticsService.reportEvent(with: "Number of Counters", parameters: ["Number" : self.collectionView.numberOfSections])
		}
	}

	let collectionView: UICollectionView = {
		let layout					= UICollectionViewFlowLayout()
		layout.scrollDirection		= .vertical
		layout.itemSize				= CGSize(width: UIScreen.main.bounds.width - 40,	height: UIScreen.main.bounds.height / 5.5)
		layout.headerReferenceSize	= CGSize(width: UIScreen.main.bounds.width, 		height: 240)
		
		let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3), collectionViewLayout: layout)
		cv.backgroundColor = .white
		cv.alwaysBounceVertical = true
		
		cv.register(CounterCell.self, 	forCellWithReuseIdentifier: CounterCell.reuseId)
		cv.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reusedId)
		
		return cv
		}()
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reusedId, for: indexPath) as! SectionHeader
		header.frame = CGRect(x: 0 , y: 0, width: self.view.frame.width, height: 240)
		header.profileImage.image = currentProject.image.toImage()
		header.profileImage.layer.cornerRadius  = 20
		header.profileImage.layer.masksToBounds = true
		header.title.text         = currentProject.name
		header.isUserInteractionEnabled = true
		let tap = UITapGestureRecognizer(target: self, action: #selector(CountersVC.createCounterTaped(recognizer:)))
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
		self.showActivityIndicator()
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
			self.hideActivityIndicator()
		}
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
		if Int(cell.currentRows.text!) == currentCounter.rowsMax {
			let alert = UIAlertController(title: "Congratulations!", message: "The Counter is done!", preferredStyle: UIAlertController.Style.alert)
			alert.addAction(UIAlertAction(title: "Hooray)", style: UIAlertAction.Style.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
		collectionView.reloadData()
		AnalyticsService.reportEvent(with: "Add row")
	}
	
	@objc
	func minusBtnTaped(_ sender: UIButton) {
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
		AnalyticsService.reportEvent(with: "Remove row")
	}
	
	@objc
	func createCounterTaped(recognizer: UITapGestureRecognizer) {
		let new = NewCounterVC()
		new.currentProject = currentProject
		let vc : PanModalPresentable.LayoutType = NavigationController(rootViewController: new)
		self.presentPanModal(vc)
	}
}

//MARK: Swipeable Collection View Cell Delegate
extension CountersVC: SwipeableCollectionViewCellDelegate {
	
	func duplicateContainerViewTapped(inCell cell: SwipeableCollectionViewCell) {
		self.view.isUserInteractionEnabled = false
		guard let indexPath = collectionView.indexPath(for: cell) else { return }
		let counter = counters[indexPath.row]
		
		let date = Int(Date().timeIntervalSince1970)
		let name = counter.name
		
		let rowsMax = counter.rowsMax
		
		let counterToSave = MCounter(name: name, rows: 0, rowsMax: rowsMax, date: "\(date)")
		ref.child("\(date)").setValue(counterToSave.counterToDictionary())
		let leftOffset = CGPoint(x: 0, y: 0)
		cell.scrollView.setContentOffset(leftOffset, animated: true)
		collectionView.reloadData()
		DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
			self.view.isUserInteractionEnabled = true
		}
		AnalyticsService.reportEvent(with: "Duplicate counter")
	}
	
	func editContainerViewTapped(inCell cell: SwipeableCollectionViewCell) {
		self.view.isUserInteractionEnabled = false
		guard let indexPath = collectionView.indexPath(for: cell) else { return }
		let counter = counters[indexPath.row]

		self.currentCounter = counter
		let edit = EditCounterVC()
		edit.currentCounter = counter
		let vc : PanModalPresentable.LayoutType = NavigationController(rootViewController: edit)
		self.presentPanModal(vc)
		let leftOffset = CGPoint(x: 0, y: 0)
		cell.scrollView.setContentOffset(leftOffset, animated: true)
		DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
			self.view.isUserInteractionEnabled = true
		}
		AnalyticsService.reportEvent(with: "Edit counter")
	}
	
	func deleteContainerViewTapped(inCell cell: SwipeableCollectionViewCell) {
		guard let indexPath = collectionView.indexPath(for: cell) else { return }
		let project = counters[indexPath.row]
		project.ref?.removeValue()
		self.collectionView.reloadData()
		let leftOffset = CGPoint(x: 0, y: 0)
		cell.scrollView.setContentOffset(leftOffset, animated: true)
		AnalyticsService.reportEvent(with: "Delete counter")
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
		navigationController.navigationBar.backIndicatorImage				= backIcon
		navigationController.navigationBar.backIndicatorTransitionMaskImage	= backIcon
		navigationController.navigationBar.topItem?.title 					= ""
		navigationController.navigationBar.tintColor 						= Colors.backIcon
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
	
	func showActivityIndicator() {
		activityView = UIActivityIndicatorView(style: .large)
		activityView?.center = self.view.center
		self.view.addSubview(activityView!)
		activityView?.startAnimating()
	}

	func hideActivityIndicator(){
		if (activityView != nil){
			activityView?.stopAnimating()
		}
	}
}
