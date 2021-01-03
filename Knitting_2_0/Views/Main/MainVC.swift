//
//  MainVC.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 11.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

enum CardState {
	case expanded
	case collapsed
}

let animationDuration = 0.7

class MainVC								: UIViewController {
	
	var activityView						: UIActivityIndicatorView?
	
	let profileImageTaped					= Notification.Name(rawValue: profileImageInSectionNotificationKey)
	let newprojectViewTaped					= Notification.Name(rawValue: newprojectNotificationKey)
	let editprojectViewTaped				= Notification.Name(rawValue: editProjectNotificationKey)
	
	//MARK:VARIABLES: Supporting Stuff
	
	private var projects					: [MProject] = [
		MProject(userID: "1", name: "", image: "", date: ""),
		MProject(userID: "1", name: "", image: "", date: ""),
		MProject(userID: "1", name: "", image: "", date: ""),
		MProject(userID: "1", name: "", image: "", date: ""),
		MProject(userID: "1", name: "", image: "", date: ""),
		MProject(userID: "1", name: "", image: "", date: ""),
		MProject(userID: "1", name: "", image: "", date: ""),
		MProject(userID: "1", name: "", image: "", date: ""),
		MProject(userID: "1", name: "", image: "", date: ""),
		MProject(userID: "1", name: "", image: "", date: ""),
		MProject(userID: "1", name: "", image: "", date: ""),
		MProject(userID: "1", name: "", image: "", date: "")
	]
//	private var sections					: Array<MSection> = [MSection(type: "projects", title: "Working on this?", projects: [])]
	private var dataSourse					: UICollectionViewDiffableDataSource<MSection, MProject>?
	
	//MARK:VARIABLES: UI Elements
	// Add project Button
	private var addView						= UIView()
	private var addImage					= UIImageView()
    
	private var user           		: MUser!
	private var ref             	: DatabaseReference!
	
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
	
	var currentProject : MProject?

	private var viewModel					: MainVM! {
		didSet {
			self.addImage	= viewModel.addImageView()
			self.addView	= viewModel.addViewBackground()
			self.addView.frame = CGRect(x: 0, y: 0, width: 110, height: 60)
		}
	}
	
	let collectionView: UICollectionView = {
		let layout					= UICollectionViewFlowLayout()
		layout.scrollDirection		= .vertical
		layout.itemSize				= CGSize(width: UIScreen.main.bounds.width - 40,	height: UIScreen.main.bounds.height / 5.5)
		layout.headerReferenceSize	= CGSize(width: UIScreen.main.bounds.width, 		height: 55)
		
		let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3), collectionViewLayout: layout)
		cv.backgroundColor = .white
		cv.alwaysBounceVertical = true
		cv.register(ProjectCell.self, 	forCellWithReuseIdentifier: ProjectCell.reuseId)
		cv.register(MainSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainSectionHeader.reusedId)
		
		return cv
	}()
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		setupNormalNavBar()
		reloadMainVc = true
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		viewModel = MainVM()
		guard let currentUser = Auth.auth().currentUser else { return }
		user	= MUser(user: currentUser)
		ref		= Database.database().reference(withPath: "users").child(String(user.uid))
		collectionView.dataSource	= self
		collectionView.delegate		= self
		setupVisualEffect	()
		setupSections		()
		setUpLayout		()
		self.collectionView.reloadData	()
		self.view.sendSubviewToBack(self.addView)
		self.view.sendSubviewToBack(self.collectionView)
		self.view.sendSubviewToBack(self.visualEffectView)
		self.reloadMainVc = true
    }
	
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: CollectionView Creating
extension MainVC {
	
	func setupSections() {
		let currentUser		= Auth.auth().currentUser
		let user 			= MUser(user: currentUser!)
		let reference		= Database.database().reference(withPath: "users").child(String(user.uid)).child("projects")
		self.showActivityIndicator()
		reference.observe(.value) { (snapshot) in
			self.projects.removeAll()
			for item in snapshot.children {
				let project = MProject(snapshot: item as! DataSnapshot)
				print(project.name)
				self.projects.append(project)
				self.projects.sort(by: {
					return
							($0.date) > ($1.date)
				})
				self.collectionView.reloadData()
			}
			self.collectionView.reloadData()
			self.hideActivityIndicator()
		}
	}
}

//MARK: CollectionView DataSourse
extension MainVC : UICollectionViewDataSource, UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return projects.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let project = projects[indexPath.row]
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectCell.reuseId, for: indexPath) as! ProjectCell
		cell.delegate = self
		cell.configurу(with: project)
		if project.name == "knitting-f824f" {
			cell.isHidden = true
		} else {
			cell.isHidden = false
			cell.alpha = 1
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		guard let sectionHeader		= collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainSectionHeader.reusedId, for: indexPath) as? MainSectionHeader
		else { return UICollectionReusableView() }
		sectionHeader.title.text	= "Working on this?".localized()
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainVC.profileImageTap(recognizer:)))
		
		sectionHeader.profileImage.addGestureRecognizer(tapGestureRecognizer)
		return sectionHeader
	}
}

//MARK: Setting up cards
extension MainVC {
	
    @objc
	func updateCardViewControllerWithProfileVC(notification: NSNotification) {
		cardHeight = 250
		setupCardViewController(ProfileCardVC())
    }
	
	@objc
	func updateCardViewControllerWithEditProjectVC(notification: NSNotification) {
		switch UIDevice().type {
			case .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax: cardHeight = 400
			default: cardHeight = 475
		}
		let vc = EditProjectVC()
		vc.currentProject = self.currentProject
		NotificationCenter.default.addObserver(self, selector: #selector(hideViewWithDeinit), name: Notification.Name(rawValue: "disconnectEditProjectVC"), object: nil)
		setupCardViewController(vc)
	}
	
    @objc
	func updateCardViewControllerWithNewProjectVC(notification: NSNotification) {
		switch UIDevice().type {
			case .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax: cardHeight = 500
			default: cardHeight = 475
		}
		NotificationCenter.default.addObserver(self, selector: #selector(hideViewWithDeinit), name: Notification.Name(rawValue: "disconnectNewProjectVC"), object: nil)
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
		collectionView.supplementaryView(forElementKind: "header", at: IndexPath(item: 0, section: 0))?.isHidden = true
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
extension MainVC {
	
	@objc
    func visualEffectTaped	(recognzier: UITapGestureRecognizer) {
		hideViewWithDeinit()
    }
	
	@objc
	func newProjectTaped	(recognizer: UITapGestureRecognizer) {
		view.isUserInteractionEnabled = false
		NotificationCenter.default.addObserver(self, selector: #selector(MainVC.updateCardViewControllerWithNewProjectVC(notification:)), name: newprojectViewTaped, object: nil)
		let name = Notification.Name(rawValue: newprojectNotificationKey)
		NotificationCenter.default.post(name: name, object: nil)

        switch recognizer.state {
        case .ended		:
            animateTransitionIfNeeded(state: nextState, duration: animationDuration)
        default			:
            break
        }
		DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
			self.view.isUserInteractionEnabled = true
		}
    }
	
	@objc
    func profileImageTap	(recognizer: UITapGestureRecognizer) {
		view.isUserInteractionEnabled = false
		NotificationCenter.default.addObserver(self, selector: #selector(MainVC.updateCardViewControllerWithProfileVC(notification:)), name: profileImageTaped, object: nil)
		let name = Notification.Name(rawValue: profileImageInSectionNotificationKey)
		NotificationCenter.default.post(name: name, object: nil)
		addView.accessibilityElementsHidden = true
        switch recognizer.state {
        case .ended		:
            animateTransitionIfNeeded(state: nextState, duration: animationDuration)
        default			:
            break
        }
		DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
			self.view.isUserInteractionEnabled = true
		}
	}
    
    @objc
    func handleCardPan		(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began		:
            startInteractiveTransition(state: nextState, duration: animationDuration)
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
		self.animateTransitionIfNeeded(state: nextState, duration: animationDuration)
		DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
			NotificationCenter.default.removeObserver(self, name: self.profileImageTaped,		object: nil)
			NotificationCenter.default.removeObserver(self, name: self.newprojectViewTaped,		object: nil)
			NotificationCenter.default.removeObserver(self, name: self.editprojectViewTaped,	object: nil)
			self.teardownCardView()
		}
	}
}

//MARK: Swipeable Collection View Cell Delegate
extension MainVC: SwipeableCollectionViewCellDelegate {
	
	func duplicateContainerViewTapped(inCell cell: SwipeableCollectionViewCell) {
		self.view.isUserInteractionEnabled = false
		guard let indexPath = collectionView.indexPath(for: cell) else { return }
		let project = projects[indexPath.row]
		let image = project.image
		let projectUniqueID = Int(Date().timeIntervalSince1970)
		let name = project.name
		let projectToSave = MProject(userID: user.uid, name: name, image: image, date: "\(projectUniqueID)")
		let referenceForProject = self.ref.child("projects").child("\(projectUniqueID)")
		referenceForProject.setValue(projectToSave.projectToDictionary())
		let fakeCounter = MCounter(name: "knitting-f824f", rows: 0, rowsMax: -1, date: "000000000")
		let referenceForCounter = self.ref.child("projects").child("\(projectUniqueID)").child("counters").child("knitting-f824f")
		referenceForCounter.setValue(fakeCounter.counterToDictionary())
//		
//		var counters : [MCounter] = []
//		project.ref!.child("counters").observeSingleEvent(of: .value) { (snapshot) in
//			for item in snapshot.children {
//				let counter = MCounter(snapshot: item as! DataSnapshot)
//				let date = Int(Date().timeIntervalSince1970)
//				let name = counter.name
//				let rowsMax = counter.rowsMax
//				let counterToSave = MCounter(name: name, rows: 0, rowsMax: rowsMax, date: "\(date)")
//				counters.append(counterToSave)
//			}
//		}
//		
//		for counter in counters {
//			let counterUniqueID = Int(Date().timeIntervalSince1970)
//			referenceForCounter = self.ref.child("projects").child("\(projectUniqueID)").child("counters").child("\(counterUniqueID)")
//			referenceForCounter.setValue(counter.counterToDictionary())
//		}
		let leftOffset = CGPoint(x: 0, y: 0)
		cell.scrollView.setContentOffset(leftOffset, animated: true)
		DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
			self.view.isUserInteractionEnabled = true
		}
	}
	
	func editContainerViewTapped(inCell cell: SwipeableCollectionViewCell) {
		self.view.isUserInteractionEnabled = false
		guard let indexPath = collectionView.indexPath(for: cell) else { return }
		let project = projects[indexPath.row]
		
		let recognizer = UITapGestureRecognizer()
		recognizer.state = .ended
		
		self.currentProject = project
		
		NotificationCenter.default.addObserver(self, selector: #selector(MainVC.updateCardViewControllerWithEditProjectVC(notification:)), name: editprojectViewTaped, object: nil)
		let name = Notification.Name(rawValue: editProjectNotificationKey)
		NotificationCenter.default.post(name: name, object: nil)
		switch recognizer.state {
		case .ended		:
			animateTransitionIfNeeded(state: nextState, duration: animationDuration)
		default			:
			break
		}
		let leftOffset = CGPoint(x: 0, y: 0)
		cell.scrollView.setContentOffset(leftOffset, animated: true)
		DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
			self.view.isUserInteractionEnabled = true
		}
	}
	
	func deleteContainerViewTapped(inCell cell: SwipeableCollectionViewCell) {
		guard let indexPath = collectionView.indexPath(for: cell) else { return }
		let project = projects[indexPath.row]
		project.ref?.removeValue()
		var snap = dataSourse?.snapshot()
		snap?.deleteItems([projects[indexPath.row]])
		projects.remove(at: indexPath.row)
		dataSourse?.apply(snap!, animatingDifferences: true)
		self.collectionView.reloadData()
		let leftOffset = CGPoint(x: 0, y: 0)
		cell.scrollView.setContentOffset(leftOffset, animated: true)
		DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
			self.view.isUserInteractionEnabled = true
		}
	}
	
	func visibleContainerViewTapped(inCell cell: SwipeableCollectionViewCell) {
		guard let indexPath = collectionView.indexPath(for: cell) else { return }
		collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition())

		let project = projects[indexPath.row]
		
		let vc = CountersVC()
		vc.currentProject = project
		vc.modalPresentationStyle = .fullScreen
		
		self.reloadMainVc = false
		guard let navigationController = navigationController else { return }
		navigationController.pushViewController(vc, animated: true)
		collectionView.deselectItem(at: indexPath, animated: true)
		let leftOffset = CGPoint(x: 0, y: 0)
		cell.scrollView.setContentOffset(leftOffset, animated: false)
	}
}

//MARK: Layout
extension MainVC {
	
	func setupNormalNavBar() {
		//Navigation Bar scould be invisible
		guard let navigationController = navigationController else { return }
		navigationController.navigationBar.barTintColor		= .white
		navigationController.view.backgroundColor			= .white
		navigationController.navigationBar.isTranslucent	= false
		navigationController.navigationBar.shadowImage		= UIImage()
		navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
		
		self.navigationItem.setHidesBackButton(true, animated: true)
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
		
		let tapToCreateNewProject1 = UITapGestureRecognizer(target: self, action: #selector(newProjectTaped(recognizer:)))
		let tapToCreateNewProject2 = UITapGestureRecognizer(target: self, action: #selector(newProjectTaped(recognizer:)))

		addView.isUserInteractionEnabled = true
		addImage.isUserInteractionEnabled = true
		addView.isMultipleTouchEnabled = false
		addImage.isMultipleTouchEnabled = false
		addView.addGestureRecognizer(tapToCreateNewProject1)
		addImage.addGestureRecognizer(tapToCreateNewProject2)
		view.addSubview(addView)

		addView.translatesAutoresizingMaskIntoConstraints										= false
		addView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive 					= true
		addView.widthAnchor.constraint(equalToConstant: 110).isActive							= true
		addView.heightAnchor.constraint(equalToConstant: 60).isActive							= true
		addView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive		= true
		
		addView.backgroundColor		= .white
		addView.layer.shadowColor	= UIColor(red: 0, green: 0, blue: 0, alpha: 0.12).cgColor  				//TO CONSTANTS
		addView.layer.shadowOpacity	= 1
		addView.layer.shadowRadius	= 10
		addView.layer.shadowOffset	= CGSize(width: 0, height: 4)
		addView.layer.bounds		= addView.bounds
		addView.layer.position		= addView.center
		addView.layer.masksToBounds	= false
		addView.layer.cornerRadius	= 30
		
		addView.addSubview(addImage)
		addImage.image = UIImage(named: "addProject")
		addImage.translatesAutoresizingMaskIntoConstraints										= false
		addImage.bottomAnchor.constraint(equalTo: addView.bottomAnchor, constant: -12).isActive	= true
		addImage.topAnchor.constraint(equalTo: addView.topAnchor, constant: 12).isActive		= true
		addImage.widthAnchor.constraint(equalTo: addImage.heightAnchor).isActive				= true
		addImage.centerXAnchor.constraint(equalTo: addView.centerXAnchor).isActive				= true
	}
	
	func teardownCardView() {
		self.setupNormalNavBar()
		runningAnimations.removeAll()
		cardViewController.removeFromParent()
		cardViewController.view.removeFromSuperview()
		NotificationCenter.default.removeObserver(self)
		self.view.insertSubview(self.visualEffectView, at: 0)
		collectionView.reloadData()
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
		collectionView.reloadData()
	}
}
