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

let profileImageInSectionNotificationKey = "ru.polykuzin.profileImage"

enum CardState {
	case expanded
	case collapsed
}

class MainVC	: UIViewController {
	
    private var user           		: MUsers!
    private var ref             	: DatabaseReference!
	
	private var collectionView		: UICollectionView!
	private var dataSourse			: UICollectionViewDiffableDataSource<MSection, MProject>?
	
	//MARK: UI Elements
	private var signoutBtn			= UIButton()
	private var deleteAccountBtn	= UIButton()
	private var profileImage		= UIImageView()
	private var fullname			= UILabel()
	private var email				= UILabel()
	private var darkBackground		= UIView()
	private var close				= UILabel()
	
	private var sections			: Array<MSection> = []
	
    
	var cardViewController      	: CardViewControllerProtocol!
    var visualEffectView			: UIVisualEffectView!
    
    let cardHeight					: CGFloat = 300 + 20  				//TO CONSTANTS
    let cardHandleAreaHeight		: CGFloat = 0						//TO CONSTANTS
    
    var cardVisible					= false
    var nextState					:CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0

	private var viewModel			: MainVM! {
		didSet {
			self.signoutBtn			= viewModel.signOut()
			self.deleteAccountBtn	= viewModel.deleteAccount()
			self.profileImage		= viewModel.profileImageView()
			self.fullname			= viewModel.fullnameLabel()
			self.email				= viewModel.emailLabel()
			self.darkBackground		= viewModel.darkBackgroundView()
			self.close				= viewModel.closeLabel()
			self.sections.append(viewModel.sections())
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		setupNormalNavBar()
		guard let currentUser = Auth.auth().currentUser else { return }
		user	= MUsers(user: currentUser)
        ref		= Database.database().reference(withPath: "users").child(String(user.uid)).child("projects")
	}

    let light = Notification.Name(rawValue: profileImageInSectionNotificationKey)

    override func viewDidLoad() {
        super.viewDidLoad()
		viewModel = MainVM()
		view.backgroundColor = .white

		setupCollectionView()
		setupVisualEffect()
//		setupProfileCard()
//		setupNewProjectCard()
    }
	
    deinit {
        NotificationCenter.default.removeObserver(self)
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
		let itemSize				= NSCollectionLayoutSize			(widthDimension:	.fractionalWidth(1.0),
																		 heightDimension:	.fractionalHeight(UIScreen.main.bounds.height / 6.7))
		let item					= NSCollectionLayoutItem			(layoutSize: itemSize)
		let groupSize				= NSCollectionLayoutSize			(widthDimension:	.fractionalWidth(1.0),
																		 heightDimension:	.estimated(1.0))
		let group					= NSCollectionLayoutGroup.vertical	(layoutSize: groupSize, subitems: [item])
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
		//A place for adding a stories
			default:
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectCell.reuseId, for: indexPath) as! ProjectCell
				cell.configure()
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
			let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainVC.handleCardTap(recognzier:)))
			sectionHeader.profileImage.addGestureRecognizer(tapGestureRecognizer)
			return sectionHeader
		}
	}
	
	func reloadData() {
		var snapShot = NSDiffableDataSourceSnapshot<MSection, MProject>()
		snapShot.appendSections(sections)
		for section in sections {
			snapShot.appendItems(section.projects, toSection: section)
		}
		dataSourse?.apply(snapShot)
	}
}

//MARK: Setting up cards
extension MainVC {
	
    @objc func updateCardViewController(notification: NSNotification) {
        cardViewController = ProfileCardVC()
		setupProfileCard()
    }
	
	func setupVisualEffect() {
        visualEffectView = UIVisualEffectView()
		visualEffectView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.view.addSubview(visualEffectView)
		self.view.sendSubviewToBack(visualEffectView)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainVC.visualEffectTap(recognzier:)))
		tapGestureRecognizer.numberOfTapsRequired = 1
        visualEffectView.addGestureRecognizer(tapGestureRecognizer)
	}
	
	func setupNewProjectCard() {
		
	}
	
	func setupProfileCard() {
//        cardViewController = ProfileCardVC()
        self.addChild(cardViewController)
		self.view.insertSubview(cardViewController.view, at: 2)
        
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.bounds.width, height: cardHeight)
        cardViewController.view.clipsToBounds = true
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(MainVC.handleCardPan(recognizer:)))
        cardViewController.handle.addGestureRecognizer	(panGestureRecognizer)
    }
}

//MARK: Gesture Selectors
extension MainVC {
	
	@objc
    func visualEffectTap(recognzier:UITapGestureRecognizer) {

        switch recognzier.state {
        case .ended		:
			animateTransitionIfNeeded(state: nextState, duration: 0.3)
        default			:
            break
        }
		let seconds = 0.3
		DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
			NotificationCenter.default.removeObserver(self, name: self.light, object: nil)
			
			self.teardownCardView()
		}
    }
	
	@objc
    func handleCardTap(recognzier:UITapGestureRecognizer) {
		NotificationCenter.default.addObserver(self, selector: #selector(MainVC.updateCardViewController(notification:)), name: light, object: nil)
		let name = Notification.Name(rawValue: profileImageInSectionNotificationKey)
		NotificationCenter.default.post(name: name, object: nil)
        switch recognzier.state {
        case .ended		:
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        default			:
            break
        }
    }
    
    @objc
    func handleCardPan (recognizer:UIPanGestureRecognizer) {
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
		
        self.view.addSubview(collectionView)
	}
	
	func teardownCardView() {
		runningAnimations.removeAll()
		cardViewController.removeFromParent()
		cardViewController.view.removeFromSuperview()
		cardViewController = nil
		self.view.insertSubview(self.visualEffectView, at: 0)

//		visualEffectView.removeFromSuperview()
//		visualEffectView = nil
	}
}
