////
////  MainVC.swift
////  Knitting_2_0
////
////  Created by Павел Кузин on 11.09.2020.
////  Copyright © 2020 Павел Кузин. All rights reserved.
////
//
//import UIKit
//import PanModal
//import FirebaseAuth
//import FirebaseDatabase
//
//class MainVC : BaseVC {
//	
//	let appDelegate = UIApplication.shared.delegate as? AppDelegate
//	
//	var activityView						: UIActivityIndicatorView?
//	
//	//MARK:VARIABLES: Supporting Stuff
//	private var projects					: [MProject] = [
//		MProject(userID: "1", name: "", image: "", date: ""),
//		MProject(userID: "1", name: "", image: "", date: ""),
//		MProject(userID: "1", name: "", image: "", date: ""),
//		MProject(userID: "1", name: "", image: "", date: ""),
//		MProject(userID: "1", name: "", image: "", date: ""),
//		MProject(userID: "1", name: "", image: "", date: ""),
//		MProject(userID: "1", name: "", image: "", date: ""),
//		MProject(userID: "1", name: "", image: "", date: ""),
//		MProject(userID: "1", name: "", image: "", date: ""),
//		MProject(userID: "1", name: "", image: "", date: ""),
//		MProject(userID: "1", name: "", image: "", date: ""),
//		MProject(userID: "1", name: "", image: "", date: "")
//	]
//	private var dataSourse					: UICollectionViewDiffableDataSource<MSection, MProject>?
//	
//	//MARK:VARIABLES: UI Elements
//	private var addView						= UIView()
//	private var addImage					= UIImageView()
//    
//	private var user   : MUser!
//	private var ref    : DatabaseReference!
//	var currentProject : MProject?
//
//	private var viewModel : MainVM! {
//		didSet {
//			self.addImage	= viewModel.addImageView()
//			self.addView	= viewModel.addViewBackground()
//			self.addView.frame = CGRect(x: 0, y: 0, width: 110, height: 60)
//		}
//	}
//	
//	let collectionView: UICollectionView = {
//		let layout					= UICollectionViewFlowLayout()
//		layout.scrollDirection		= .vertical
//		layout.itemSize				= CGSize(width: UIScreen.main.bounds.width - 40,	height: UIScreen.main.bounds.height / 5.5)
//		layout.headerReferenceSize	= CGSize(width: UIScreen.main.bounds.width, 		height: 55)
//		
//		let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3), collectionViewLayout: layout)
//		cv.backgroundColor = .white
//		cv.alwaysBounceVertical = true
//		cv.register(ProjectCell.self, 	forCellWithReuseIdentifier: ProjectCell.reuseId)
//		cv.register(MainSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainSectionHeader.reusedId)
//		
//		return cv
//	}()
//	
//	override func viewWillAppear(_ animated: Bool) {
//		super.viewWillAppear(true)
//		setupNormalNavBar()
//	}
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//		appDelegate?.scheduleNotification()
//		viewModel = MainVM()
//		guard let currentUser = Auth.auth().currentUser else { return }
//		user	= MUser(user: currentUser)
//		ref		= Database.database().reference(withPath: "users").child(String(user.uid))
//		collectionView.dataSource	= self
//		collectionView.delegate		= self
//		setupSections		()
//		setUpLayout		()
//		self.collectionView.reloadData	()
//		self.view.sendSubviewToBack(self.addView)
//		self.view.sendSubviewToBack(self.collectionView)
//    }
//	
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//}
//
////MARK: CollectionView Creating
//extension MainVC {
//	
//	func setupSections() {
//		let currentUser		= Auth.auth().currentUser
//		let user 			= MUser(user: currentUser!)
//		let reference		= Database.database().reference(withPath: "users").child(String(user.uid)).child("projects")
//		self.showActivityIndicator()
//		reference.observe(.value) { (snapshot) in
//			self.projects.removeAll()
//			for item in snapshot.children {
//				var project = MProject(snapshot: item as! DataSnapshot)
//				if project.image == defaultImage {
//					project.image = "_0"
//					if let referenceForProject = project.ref {
//						referenceForProject.setValue(project.projectToDictionary())
//					}
//				}
//				self.projects.append(project)
//				self.projects.sort(by: {
//					return
//							($0.date) > ($1.date)
//				})
//				self.collectionView.reloadData()
//			}
//			self.collectionView.reloadData()
//			self.hideActivityIndicator()
//		}
//	}
//	
//	private func getImage(from str: String) -> UIImage {
//		return UIImage(named: str) ?? UIImage(named: "_0")!
//	}
//}
//
////MARK: CollectionView DataSourse
//extension MainVC : UICollectionViewDataSource, UICollectionViewDelegate {
//	
//	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//		return projects.count
//	}
//	
//	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//		let project = projects[indexPath.row]
//		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectCell.reuseId, for: indexPath) as! ProjectCell
//		cell.delegate = self
//		cell.configurу(with: project)
//		if project.name == "knitting-f824f" {
//			cell.isHidden = true
//		} else {
//			cell.isHidden = false
//			cell.alpha = 1
//		}
//		AnalyticsService.reportEvent(with: "Project", parameters: ["name" : project.name])
//		return cell
//	}
//	
//	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//		guard let sectionHeader		= collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainSectionHeader.reusedId, for: indexPath) as? MainSectionHeader
//		else { return UICollectionReusableView() }
//		sectionHeader.title.text	= "Working on this?".localized()
//		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainVC.profileImageTap(recognizer:)))
//		
//		sectionHeader.profileImage.addGestureRecognizer(tapGestureRecognizer)
//		return sectionHeader
//	}
//}
//
////MARK: Gesture Selectors
//extension MainVC {
//	
//	@objc
//	func newProjectTaped() {
////		let vc = PanProject(nibName: "PanProject", bundle: nil)
////		let vc : PanModalPresentable.LayoutType = PanelNavigation(edit)
////		self.presentPanModal(vc)
////		self.presentPanModal(Project().VC)
//    }
//	
//	@objc
//    func profileImageTap	(recognizer: UITapGestureRecognizer) {
////		self.presentPanModal(Profile().VC)
//	}
//}
//
////MARK: Swipeable Collection View Cell Delegate
//extension MainVC: SwipeableCollectionViewCellDelegate {
//	
//	func duplicateContainerViewTapped(inCell cell: SwipeableCollectionViewCell) {
//		self.view.isUserInteractionEnabled = false
//		guard let indexPath = collectionView.indexPath(for: cell) else { return }
//		let project = projects[indexPath.row]
//		let image = project.image
//		let projectUniqueID = Int(Date().timeIntervalSince1970)
//		let name = project.name
//		let projectToSave = MProject(userID: user.uid, name: name, image: image, date: "\(projectUniqueID)")
//		let referenceForProject = self.ref.child("projects").child("\(projectUniqueID)")
//		referenceForProject.setValue(projectToSave.projectToDictionary())
//		let fakeCounter = MCounter(name: "knitting-f824f", rows: 0, rowsMax: -1, date: "000000000")
//		let referenceForCounter = self.ref.child("projects").child("\(projectUniqueID)").child("counters").child("knitting-f824f")
//		referenceForCounter.setValue(fakeCounter.counterToDictionary())
////		
////		var counters : [MCounter] = []
////		project.ref!.child("counters").observeSingleEvent(of: .value) { (snapshot) in
////			for item in snapshot.children {
////				let counter = MCounter(snapshot: item as! DataSnapshot)
////				let date = Int(Date().timeIntervalSince1970)
////				let name = counter.name
////				let rowsMax = counter.rowsMax
////				let counterToSave = MCounter(name: name, rows: 0, rowsMax: rowsMax, date: "\(date)")
////				counters.append(counterToSave)
////			}
////		}
////		
////		for counter in counters {
////			let counterUniqueID = Int(Date().timeIntervalSince1970)
////			referenceForCounter = self.ref.child("projects").child("\(projectUniqueID)").child("counters").child("\(counterUniqueID)")
////			referenceForCounter.setValue(counter.counterToDictionary())
////		}
//		let leftOffset = CGPoint(x: 0, y: 0)
//		cell.scrollView.setContentOffset(leftOffset, animated: true)
//		DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
//			self.view.isUserInteractionEnabled = true
//		}
//		AnalyticsService.reportEvent(with: "Duplicate project")
//	}
//	
//	func editContainerViewTapped(inCell cell: SwipeableCollectionViewCell) {
//		self.view.isUserInteractionEnabled = false
//		guard let indexPath = collectionView.indexPath(for: cell) else { return }
//		let project = projects[indexPath.row]
//		
//		let edit = PanProject(nibName: "PanProject", bundle: nil)
//		edit.currentProject = project
//		let vc : PanModalPresentable.LayoutType = PanelNavigation(edit)
//		self.presentPanModal(vc)
//		
//		let leftOffset = CGPoint(x: 0, y: 0)
//		cell.scrollView.setContentOffset(leftOffset, animated: true)
//		DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
//			self.view.isUserInteractionEnabled = true
//		}
//		AnalyticsService.reportEvent(with: "Edit project")
//	}
//	
//	func deleteContainerViewTapped(inCell cell: SwipeableCollectionViewCell) {
//		guard let indexPath = collectionView.indexPath(for: cell) else { return }
//		let project = projects[indexPath.row]
//		project.ref?.removeValue()
//		var snap = dataSourse?.snapshot()
//		snap?.deleteItems([projects[indexPath.row]])
//		projects.remove(at: indexPath.row)
//		dataSourse?.apply(snap!, animatingDifferences: true)
//		self.collectionView.reloadData()
//		let leftOffset = CGPoint(x: 0, y: 0)
//		cell.scrollView.setContentOffset(leftOffset, animated: true)
//		DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
//			self.view.isUserInteractionEnabled = true
//		}
//		AnalyticsService.reportEvent(with: "Delete project")
//	}
//	
//	func visibleContainerViewTapped(inCell cell: SwipeableCollectionViewCell) {
//		guard let indexPath = collectionView.indexPath(for: cell) else { return }
//		collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition())
//
//		let project = projects[indexPath.row]
//		
//		let vc = CountersVC()
//		vc.currentProject = project
//		vc.modalPresentationStyle = .fullScreen
//		
//		guard let navigationController = navigationController else { return }
//		navigationController.pushViewController(vc, animated: true)
//		collectionView.deselectItem(at: indexPath, animated: true)
//		let leftOffset = CGPoint(x: 0, y: 0)
//		cell.scrollView.setContentOffset(leftOffset, animated: false)
//	}
//}
//
////MARK: Layout
//extension MainVC {
//	
//	func setUpClearNavBar() {
//		guard let navigationController = navigationController else { return }
//		navigationController.navigationBar.alpha			= 0.7
//		navigationController.navigationBar.shadowImage 		= UIImage()
//		navigationController.navigationBar.isTranslucent	= true
//		navigationController.view.backgroundColor			= .clear
//		navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
//	}
//	
//	func setUpLayout() {
//		view.addSubview(collectionView)
//		view.insertSubview(collectionView, at: 0)
//		collectionView.translatesAutoresizingMaskIntoConstraints										= false
//		collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive 				= true
//		collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive 							= true
//		collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive 					= true
//		collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive					= true
//		
//		let addButton = MainButton()
//		self.view.insertSubview(addButton, at: 0)
//		addButton.translatesAutoresizingMaskIntoConstraints = false
//		addButton.setTitle("+ Create project".localized())
//		NSLayoutConstraint.activate([
//			addButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -48),
//			addButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
//			addButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
//			addButton.heightAnchor.constraint(equalToConstant: 52)
//		])
//		addButton.addTarget(self, action: #selector(newProjectTaped), for: .touchUpInside)
//	}
//	
//	func showActivityIndicator() {
//		activityView = UIActivityIndicatorView(style: .large)
//		activityView?.center = self.view.center
//		self.view.addSubview(activityView!)
//		activityView?.startAnimating()
//	}
//
//	func hideActivityIndicator(){
//		if (activityView != nil){
//			activityView?.stopAnimating()
//		}
//		collectionView.reloadData()
//	}
//}
