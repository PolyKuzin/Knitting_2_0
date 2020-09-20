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
	
    enum CardState {
        case expanded
        case collapsed
    }
    
    var cardViewController      : ProfileCardVC!
    var visualEffectView        : UIVisualEffectView!
    
    let cardHeight              : CGFloat = 300 + 20  				//TO CONSTANTS
    let cardHandleAreaHeight    : CGFloat = 0						//TO CONSTANTS
    
    var cardVisible				= false
    var nextState				:CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
	
	func setupCard() {
        visualEffectView = UIVisualEffectView()
		visualEffectView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.view.addSubview(visualEffectView)
		self.view.sendSubviewToBack(visualEffectView)
        
        cardViewController = ProfileCardVC()
        self.addChild(cardViewController)
		self.view.insertSubview(cardViewController.view, at: 2)
        
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.bounds.width, height: cardHeight)
        
        cardViewController.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainVC.handleCardTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(MainVC.handleCardPan(recognizer:)))
        visualEffectView.addGestureRecognizer			(tapGestureRecognizer)
        cardViewController.handle.addGestureRecognizer	(panGestureRecognizer)
    }
	
	@objc
    func handleCardTap(recognzier:UITapGestureRecognizer) {
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
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		setupNormalNavBar()
		guard let currentUser = Auth.auth().currentUser else { return }
		user	= MUsers(user: currentUser)
        ref		= Database.database().reference(withPath: "users").child(String(user.uid)).child("projects")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		viewModel = MainVM()
		view.backgroundColor = .white
		
		setupCollectionView()
		setUpLayout()
		createDataSourse()
		reloadData()
		
		setupCard()
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
		let itemSize			= NSCollectionLayoutSize			(widthDimension:	.fractionalWidth(1.0),
																	 heightDimension:	.fractionalHeight(UIScreen.main.bounds.height / 6.7))
		let item				= NSCollectionLayoutItem			(layoutSize: itemSize)
		let groupSize			= NSCollectionLayoutSize			(widthDimension:	.fractionalWidth(1.0),
																	 heightDimension:	.estimated(1.0))
		let group				= NSCollectionLayoutGroup.vertical	(layoutSize: groupSize, subitems: [item])
		let section				= NSCollectionLayoutSection			(group: group)
		item.contentInsets		= NSDirectionalEdgeInsets.init		(top: 20,	leading: 0,		bottom: 20,	trailing: 0)
		group.interItemSpacing = .fixed(20)
		section.contentInsets	= NSDirectionalEdgeInsets.init		(top: 20,	leading: 20,	bottom: 20,	trailing: 20)
		section.interGroupSpacing = 15
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
				
				cell.layer.cornerRadius		= 20
				cell.layer.borderWidth		= 0.0
				cell.layer.shadowColor		= UIColor(red: 0, green: 0, blue: 0, alpha: 0.12).cgColor
				cell.layer.shadowOffset		= CGSize(width: 0, height: 8)
				cell.layer.shadowRadius		= 30.0
				cell.layer.shadowOpacity	= 1
				cell.layer.masksToBounds	= false
				
				cell.configure()

				return cell
			}
		})
		dataSourse?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
			guard let sectionHeader		= collectionView.dequeueReusableSupplementaryView(ofKind: kind,
																						  withReuseIdentifier: SectionHeader.reusedId,
																						  for: indexPath) as? SectionHeader
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

//MARK: CardView Animations
extension MainVC {

    func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
			
		let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
			switch state {
			case .expanded	:
				self.setUpClearNavBar()
				self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight + 20
			case .collapsed	:
				self.setupNormalNavBar()
				self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
			}
		}
		frameAnimator.addCompletion { _ in
			self.cardVisible = !self.cardVisible
			self.runningAnimations.removeAll()
		}
		frameAnimator.startAnimation()
		runningAnimations.append(frameAnimator)
		
		let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
			switch state {
			case .expanded:
				self.cardViewController.view.layer.cornerRadius = 20
			case .collapsed:
				self.cardViewController.view.layer.cornerRadius = 0
			}
		}
		
		cornerRadiusAnimator.startAnimation()
		runningAnimations.append(cornerRadiusAnimator)
		
		let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
			switch state {
			case .expanded:
				self.view.insertSubview(self.visualEffectView, at: 1)
				self.visualEffectView.effect	= UIBlurEffect(style: .dark)
				self.visualEffectView.alpha		= 0.7
			case .collapsed:
				self.visualEffectView.effect	= nil
				self.view.sendSubviewToBack(self.visualEffectView)
			}
		}
		blurAnimator.startAnimation()
		runningAnimations.append(blurAnimator)
	}
}
	
    func startInteractiveTransition(state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted:CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition (){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
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
		cardViewController.dismiss(animated: false, completion: nil)
		visualEffectView.removeFromSuperview()
		visualEffectView = nil
	}
}
