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

class MainVC	: UIViewController, UIGestureRecognizerDelegate {
	
    private var user           		: MUsers!
    private var ref             	: DatabaseReference!
	
	private var collectionView		: UICollectionView!
	private var sections			: Array<MSection> = []
	var dataSourse					: UICollectionViewDiffableDataSource<MSection, MProject>?

	var signoutButton				: UIButton = {
		let button					= UIButton(type: .system)
		button.frame 				= CGRect(x: 0, y: 0, width: 500, height: 50)
		button.titleLabel?.font		= Fonts.textSemibold17
		button.setTitle				("Sign out ", for: .normal)
		button.setTitleColor		(UIColor(red: 0.961, green: 0.188, blue: 0.467, alpha: 1), 	for: .normal)
		button.addTarget			(self, action: #selector(signoutFromAccount), for: .touchUpInside)
		button.setImage(Icons.exit, for: .normal)
		button.tintColor = UIColor(red: 0.961, green: 0.188, blue: 0.467, alpha: 1)
		button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
		button.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
		button.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
		
		return button
	}()
	
	var deleteAccountButton			: UIButton = {
		let button					= UIButton(type: .system)
		button.frame 				= CGRect(x: 0, y: 0, width: 500, height: 50)
		button.titleLabel?.font		= Fonts.textSemibold14
		button.setTitle				("Delete account", for: .normal)
		button.setTitleColor		(UIColor(red: 0.961, green: 0.188, blue: 0.467, alpha: 1), 	for: .normal)
		button.addTarget			(self, action: #selector(deleteAcoount), for: .touchUpInside)
		
		return button
	}()
	
	let profileView 				: UIView = {
		let view 					= UIView()
		view.backgroundColor		= .white
        view.alpha					= 0
        view.layer.cornerRadius		= 20
        view.layer.masksToBounds	= false
		view.layer.maskedCorners	= [.layerMaxXMinYCorner, .layerMinXMinYCorner]
		
		return view
	}()
	
	let profileImage				: UIImageView = {
		let imageView				= UIImageView()
		imageView.image				= Icons.emptyProfile
		imageView.layer.cornerRadius = 40
		imageView.layer.masksToBounds = true
		
		return imageView
	}()
	
	let fullnameLabel				: UILabel = {
		let label					= UILabel()
		label.text 					= "Kostya The Knitter"
		label.textAlignment 		= .center
		label.font 					= Fonts.displaySemibold22
		label.textColor 			= UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
		
		return label
	}()
	
	let emailLabel					: UILabel = {
		let label					= UILabel()
		label.text 					= "example@example.com"
		label.textAlignment 		= .center
		label.font 					= Fonts.displayRegular17
		label.textColor 			= UIColor(red: 0.55, green: 0.55, blue: 0.55, alpha: 1)
		
		return label
	}()
	
	let darkBackground				: UIView = {
		let view					= UIView()
        view.backgroundColor		= UIColor(red: 0, green: 0, blue: 0, alpha: 1)
		view.alpha 					= 0.7
		view.isUserInteractionEnabled = true

		return view
	}()
	
	let closeLabel					: UILabel = {
		let label					= UILabel()
		label.text					= "Close"
		label.textColor				= .white
		label.alpha					= 0
		label.isUserInteractionEnabled = true
		label.font					= Fonts.textBold17
		
		return label
	}()
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		setupNavBar()
		guard let currentUser = Auth.auth().currentUser else { return }
		user	= MUsers(user: currentUser)
        ref		= Database.database().reference(withPath: "users").child(String(user.uid)).child("projects")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white
		let project1 = MProject(userID: "1238", projectID: "123", name: "123", imageRef: "123")
		let project2 = MProject(userID: "1234", projectID: "123", name: "123", imageRef: "123")
		let project3 = MProject(userID: "1235", projectID: "123", name: "123", imageRef: "123")
		let project4 = MProject(userID: "1236", projectID: "123", name: "123", imageRef: "123")
		let project5 = MProject(userID: "1237", projectID: "123", name: "123", imageRef: "123")

		let section = MSection(type: "projects", title: "Working on this?", projects: [project1, project2, project3, project4, project5])
		sections.append(section)
		setupCollectionView()
		setUpLayout()
		createDataSourse()
		reloadData()
		let teardownProfileTap1 			= UITapGestureRecognizer(target: self, action: #selector(animateOut))
		let teardownProfileTap2 			= UITapGestureRecognizer(target: self, action: #selector(animateOut))
		darkBackground.addGestureRecognizer(teardownProfileTap1)
		closeLabel.addGestureRecognizer(teardownProfileTap2)
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
			let profileTap 					= UITapGestureRecognizer(target: self, action: #selector(self?.animateIn))
			sectionHeader.profileImage.addGestureRecognizer(profileTap)
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

//MARK: ProfileView Animations
extension MainVC {
	
	@objc
    func animateIn() {
        setupProfileView()
        profileView.transform				= CGAffineTransform(translationX: 0, y: profileView.frame.height)
		UIView.animate(withDuration: 0.4) {
            self.darkBackground.alpha		= 0.7
			self.closeLabel.alpha			= 1.0
			self.profileView.alpha			= 1.0
            self.profileView.transform		= CGAffineTransform.identity
		}
	}
	
	@objc
	func animateOut() {
		print("!!!!!")
		UIView.animate(withDuration: 0.4, animations: {
			self.profileView.transform		= CGAffineTransform(translationX: 0, y: 0)
			self.darkBackground.alpha		= 0.0
			self.profileView.alpha			= 0.0
			self.closeLabel.alpha			= 0.0
		}) { (success: Bool) in
			self.teardownProfileView()
		}
	}
}

//MARK: Signout Screen
extension MainVC {
	
	@objc
	func signoutFromAccount() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
		self.navigationController?.popToRootViewController(animated: true)
		self.navigationController?.dismiss(animated: false, completion: nil)
	}
	
	@objc
	func deleteAcoount() {
		let user = Auth.auth().currentUser

		user?.delete { error in
			if let error = error {
				print(error.localizedDescription)
			} else {
				self.navigationController?.popToRootViewController(animated: true)
				self.navigationController?.dismiss(animated: false, completion: nil)
			}
		}
	}
}

//MARK: Layout
extension MainVC {
	
	func setupNavBar() {
		//Navigation Bar scould be invisible
		guard let navigationController = navigationController else { return }
		navigationController.navigationBar.barTintColor		= .white
		navigationController.navigationBar.isTranslucent	= false
		navigationController.navigationBar.shadowImage		= UIImage()
		navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
		self.navigationItem.setHidesBackButton(true, animated: true)
	}
	
	func setUpLayout() {
		//Projects collection View Layout
		view.addSubview(collectionView)
		collectionView.translatesAutoresizingMaskIntoConstraints										= false
		collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive 				= true
		collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive 							= true
		collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive 					= true
		collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive					= true
		
        self.view.addSubview(darkBackground)

	}
	
	func setupProfileView() {
		// DarkBackGround schould be
		guard let navigationController = navigationController else { return }
		navigationController.navigationBar.barTintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
		navigationController.navigationBar.alpha = 0.7
		navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationController.navigationBar.shadowImage = UIImage()
		navigationController.navigationBar.isTranslucent = true
		navigationController.view.backgroundColor = .clear

		//Seting up profile view
        self.view.addSubview(profileView)
        profileView.translatesAutoresizingMaskIntoConstraints											= false
        profileView.heightAnchor.constraint(equalToConstant: 300).isActive								= true
        profileView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width).isActive	= true
        profileView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive					= true
        profileView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive				= true
        profileView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive					= true
		
		profileView.addSubview(profileImage)
		profileImage.translatesAutoresizingMaskIntoConstraints											= false
		profileImage.topAnchor.constraint(equalTo: profileView.topAnchor, constant: 20).isActive		= true
		profileImage.centerXAnchor.constraint(equalTo: profileView.centerXAnchor).isActive				= true
		profileImage.heightAnchor.constraint(equalToConstant: 80).isActive								= true
		profileImage.widthAnchor.constraint(equalTo: profileImage.heightAnchor).isActive				= true

		profileView.addSubview(fullnameLabel)
		fullnameLabel.translatesAutoresizingMaskIntoConstraints											= false
		fullnameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20).isActive	= true
		fullnameLabel.centerXAnchor.constraint(equalTo: profileView.centerXAnchor).isActive				= true
		fullnameLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 300).isActive				= true
		
		profileView.addSubview(emailLabel)
		emailLabel.translatesAutoresizingMaskIntoConstraints											= false
		emailLabel.topAnchor.constraint(equalTo: fullnameLabel.bottomAnchor, constant: 8).isActive		= true
		emailLabel.centerXAnchor.constraint(equalTo: profileView.centerXAnchor).isActive				= true
		emailLabel.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 16).isActive	= true
		
		profileView.addSubview(signoutButton)
		signoutButton.translatesAutoresizingMaskIntoConstraints											= false
		signoutButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 45).isActive		= true
		signoutButton.centerXAnchor.constraint(equalTo: profileView.centerXAnchor).isActive				= true
		signoutButton.widthAnchor.constraint(equalToConstant: 150).isActive								= true
		
		profileView.addSubview(deleteAccountButton)
		deleteAccountButton.translatesAutoresizingMaskIntoConstraints									= false
		deleteAccountButton.topAnchor.constraint(equalTo: signoutButton.bottomAnchor, constant: 5).isActive		= true
		deleteAccountButton.centerXAnchor.constraint(equalTo: profileView.centerXAnchor).isActive		= true
		deleteAccountButton.widthAnchor.constraint(equalToConstant: 150).isActive						= true
		
		//Seting up darkBackground
        self.view.addSubview(darkBackground)
		darkBackground.translatesAutoresizingMaskIntoConstraints										= false
        darkBackground.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -50).isActive		= true
        darkBackground.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive			= true
        darkBackground.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive				= true
        darkBackground.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive				= true
       
		self.view.addSubview(closeLabel)
        closeLabel.translatesAutoresizingMaskIntoConstraints											= false
        closeLabel.bottomAnchor.constraint(equalTo: profileView.topAnchor, constant: -10).isActive		= true
        closeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive						= true
		
		self.view.bringSubviewToFront(darkBackground)
        self.view.bringSubviewToFront(profileView)
        self.view.bringSubviewToFront(closeLabel)
	}
	
	func teardownProfileView() {
		self.closeLabel.removeFromSuperview()
		self.darkBackground.removeFromSuperview()
		self.profileView.removeFromSuperview()
	}
}
