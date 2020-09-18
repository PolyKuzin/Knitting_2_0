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

class MainVC: UIViewController {
	
    private var user            	: MUsers!
    private var ref             	: DatabaseReference!
	private var collectionView		: UICollectionView!
	
	private var sections			: Array<MSection> = []
	
	var dataSourse					: UICollectionViewDiffableDataSource<MSection, MProject>?
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		setupNavBar()
		guard let currentUser = Auth.auth().currentUser else { return }
		user = MUsers(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("projects")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		let project1 = MProject(userID: "123", projectID: "123", name: "123", imageRef: "123")
		let project2 = MProject(userID: "1234", projectID: "123", name: "123", imageRef: "123")
		let project3 = MProject(userID: "1235", projectID: "123", name: "123", imageRef: "123")
		let project4 = MProject(userID: "1236", projectID: "123", name: "123", imageRef: "123")
		let project5 = MProject(userID: "1237", projectID: "123", name: "123", imageRef: "123")

		let section = MSection(type: "projects", title: "Working on this?", projects: [project1, project2, project3, project4, project5])
		sections.append(section)
		view.backgroundColor = .white
		setupCollectionView()
		setUpLayout()
		createDataSourse()
		reloadData()
    }
	
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

//MARK: DataSourse
extension MainVC {
	
	func createDataSourse() {
		dataSourse = UICollectionViewDiffableDataSource<MSection, MProject>(collectionView: collectionView,
																			cellProvider: { (collectionView, indexPath, project) -> UICollectionViewCell? in
			switch self.sections[indexPath.section].type {
		//A place for adding a stories
			default:
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectCell.reuseId, for: indexPath) as! ProjectCell
				
				cell.layer.cornerRadius	= 20
				cell.layer.borderWidth	= 0.0
				cell.layer.shadowColor	= UIColor(red: 0, green: 0, blue: 0, alpha: 0.12).cgColor
				cell.layer.shadowOffset = CGSize(width: 0, height: 8)
				cell.layer.shadowRadius = 30.0
				cell.layer.shadowOpacity = 1
				cell.layer.masksToBounds = false
				
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
		collectionView.translatesAutoresizingMaskIntoConstraints								= false
		collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive 		= true
		collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive 					= true
		collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive 			= true
		collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive 			= true
	}
}
