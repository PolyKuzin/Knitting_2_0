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

let profileImageInSectionNotificationKey	= "ru.polykuzin.profileImage"
let newprojectNotificationKey				= "ru.polykuzin.newproject"

class MainVC	: UIViewController {
	
	let light								= Notification.Name(rawValue: profileImageInSectionNotificationKey)
	let dark								= Notification.Name(rawValue: newprojectNotificationKey)
	
	//MARK: Supporting Stuff
    private var user           				: MUser!
    private var ref             			: DatabaseReference!
	private var collectionView				: UICollectionView!
	private var dataSourse					: UICollectionViewDiffableDataSource<MSection, MProject>?
	
	//MARK: UI Elements
    
    open var runningAnimations 				= [UIViewPropertyAnimator]()
    open var animationProgressWhenInterrupted:CGFloat = 0
	open var cardViewController      		: CardViewControllerProtocol!
    open var visualEffectView				: UIVisualEffectView! = UIVisualEffectView()
    open var cardHeight						: CGFloat = 300 + 20  				//TO CONSTANTS
	public let cardHandleAreaHeight			: CGFloat = 0						//TO CONSTANTS
    open var cardVisible					= false
    open var nextState						:CardState {
        return cardVisible ? .collapsed : .expanded
    }

	private var projects					: Array<MProject> = []
	private var sections					: Array<MSection> = []
	private var addView						= UIView()
	private var addImage					= UIImageView()
	
	private var reloadMainVc				: Bool = false
	private var setupCollectinView			: Bool = false

	private var viewModel			: MainVM! {
		didSet {
			self.addImage	= viewModel.addImageView()
			self.addView	= viewModel.addViewBackground()
			self.addView.frame = CGRect(x: 0, y: 0, width: 110, height: 60)
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
		setupVisualEffect()
		setupSections()
		self.setupCollectionView()
		self.collectionView.reloadData()
		self.view.sendSubviewToBack(self.addView)
		self.view.sendSubviewToBack(self.collectionView)
		self.view.sendSubviewToBack(self.visualEffectView)
		self.reloadMainVc = true
    }
	
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

	func setupSections() {
		let currentUser		= Auth.auth().currentUser
		let user : MUser	= MUser(user: currentUser!)
		let reff = Database.database().reference(withPath: "users").child(String(user.uid)).child("projects")
		self.sections.append(MSection(type: "projects", title: "Working on this?", projects: []))
		reff.observe(.value) { (snapshot) in
			self.sections[0].projects.removeAll()
			for item in snapshot.children {
				let project = MProject(snapshot: item as! DataSnapshot)
				if !self.sections[0].projects.contains(project) {
					self.sections[0].projects.append(project)
					self.sections[0].projects.sort(by: {
						return
								($0.date) < ($1.date)
					})
					var snapShot = NSDiffableDataSourceSnapshot<MSection, MProject>()
					snapShot.appendSections(self.sections)
					snapShot.appendItems(self.sections[0].projects)
					self.dataSourse?.apply(snapShot, animatingDifferences: true)
					self.collectionView.reloadData()
				}
			}
			self.collectionView.reloadData()
		}
	}
}

//MARK: CollectionView Creating
extension MainVC {
	
	func setupCollectionView() {
		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
		collectionView.autoresizingMask		= [.flexibleWidth, .flexibleHeight]
		collectionView.backgroundColor		= .white
		collectionView.alwaysBounceVertical	= true
		
		collectionView.register(SectionHeader.self,
									forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
									withReuseIdentifier: SectionHeader.reusedId)
		collectionView.register(ProjectCell.self,
									forCellWithReuseIdentifier: ProjectCell.reuseId)
		createDataSourse()
		reloadData()
		setUpLayout()
		setupCollectinView = true
	}
	
	func createCompositionalLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
			let section = self.sections[sectionIndex]
	//A place for adding a new section
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
		let header = createSectionHeader()
		section.boundarySupplementaryItems = [header]
		return section
	}
	
	func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
		let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension:	.fractionalWidth(1),
															 heightDimension:	.estimated(1))
		let layoutSectionHeader		= NSCollectionLayoutBoundarySupplementaryItem(layoutSize:	layoutSectionHeaderSize,
																				  elementKind:	UICollectionView.elementKindSectionHeader,
																				  alignment:	.top)
		return layoutSectionHeader
	}
}

//MARK: CollectionView DataSourse
extension MainVC {
	
	func createDataSourse() {
		dataSourse = UICollectionViewDiffableDataSource<MSection, MProject>(collectionView: collectionView,
																			cellProvider: { (collectionView, indexPath, project) -> UICollectionViewCell? in
			switch self.sections[indexPath.section].type {
//				A place for adding a stories
			default:
				let project = self.sections[0].projects[indexPath.row]
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectCell.reuseId, for: indexPath) as! ProjectCell
				cell.delegate = self
				cell.configurу(with: project)
				if project == self.sections[0].projects.last! {
					cell.isHidden = true
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
			sectionHeader.title.text	= section.title
			let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainVC.handleCardTap(recognizer:)))
			sectionHeader.profileImage.addGestureRecognizer(tapGestureRecognizer)
			return sectionHeader
		}
	}
	
	func reloadData() {
		if self.sections[0].projects.isEmpty {
			let project = MProject(userID: "123", name: "", image: "", date: "9999999999999999")
			self.sections[0].projects.append(project)
		}
		if !setupCollectinView {
			var snapShot = NSDiffableDataSourceSnapshot<MSection, MProject>()
			snapShot.appendSections(sections)
			for section in sections {
				snapShot.appendItems(section.projects, toSection: section)
			}
			dataSourse?.apply(snapShot, animatingDifferences: true)
		}
	}
}

//MARK: Setting up cards
extension MainVC {
	
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
extension MainVC {
	
	@objc
    func visualEffectTaped	(recognzier: UITapGestureRecognizer) {
		hideViewWithDeinit()
    }
	
	@objc
	func newProjectTaped	(recognizer: UITapGestureRecognizer) {
		NotificationCenter.default.addObserver(self, selector: #selector(MainVC.updateCardViewControllerWithNewProjectVC(notification:)), name: dark, object: nil)
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
		
		NotificationCenter.default.addObserver(self, selector: #selector(MainVC.updateCardViewControllerWithProfileVC(notification:)), name: light, object: nil)
		let name = Notification.Name(rawValue: profileImageInSectionNotificationKey)
		NotificationCenter.default.post(name: name, object: nil)
		addView.accessibilityElementsHidden = true
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
        default:
            break
        }
    }
	
	@objc
	func hideViewWithDeinit() {
		animateTransitionIfNeeded(state: nextState, duration: 0.3)
		let seconds = 0.3
		DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
			NotificationCenter.default.removeObserver(self, name: self.light, object: nil)
			NotificationCenter.default.removeObserver(self, name: self.dark, object: nil)
			self.teardownCardView()
		}
	}
	
}

//MARK: Swipeable Collection View Cell Delegate
extension MainVC: SwipeableCollectionViewCellDelegate {
	
	func hiddenContainerViewTapped(inCell cell: UICollectionViewCell) {
		guard let indexPath = collectionView.indexPath(for: cell) else { return }
		let project = sections[0].projects[indexPath.row]
		project.ref?.removeValue()
		var snap = dataSourse?.snapshot()
		snap?.deleteItems([sections[0].projects[indexPath.row]])
		sections[0].projects.remove(at: indexPath.row)

		dataSourse?.apply(snap!, animatingDifferences: true)
		self.collectionView.reloadData()

	}
	
	func visibleContainerViewTapped(inCell cell: UICollectionViewCell) {
		
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
		navigationController.navigationBar.barTintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
		navigationController.navigationBar.alpha = 0.7
		navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationController.navigationBar.shadowImage = UIImage()
		navigationController.navigationBar.isTranslucent = true
		navigationController.view.backgroundColor = .clear
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
		addView.addGestureRecognizer(tapToCreateNewProject1)
		addImage.addGestureRecognizer(tapToCreateNewProject2)
		view.addSubview(addView)

		addView.translatesAutoresizingMaskIntoConstraints										= false
		addView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive 					= true
		addView.widthAnchor.constraint(equalToConstant: 110).isActive							= true
		addView.heightAnchor.constraint(equalToConstant: 60).isActive							= true
		addView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -28).isActive		= true
		
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
		self.collectionView.reloadData()
		self.view.insertSubview(self.visualEffectView, at: 0)
	}
}
