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
	private var projectsCollection	: UICollectionView!
	
	private var sections			: Array<MSection> = []
	
	var dataSourse					: UICollectionViewDiffableDataSource<MSection, MProject>?
	
//	private var viewModel	: MainVM! {
//		didSet {
//			self.projectsCollection = viewModel.projectsCollectionView
//		}
//	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		setupNavBar()
		guard let currentUser = Auth.auth().currentUser else { return }
		user = MUsers(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("projects")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		let project = MProject(userID: "123", projectID: "123", name: "123", imageRef: "123")
		let section = MSection(type: "projects", title: "Working on this?", projects: [project])
		sections.append(section)
		view.backgroundColor = .white
		setupCollectionView()
		createDataSourse()
		reloadData()
//		viewModel = MainVM()

		setUpLayout()
		
    }
	
	func setupCollectionView() {
		projectsCollection = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
		projectsCollection.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		projectsCollection.backgroundColor = .white
		projectsCollection.alwaysBounceVertical = true
		view.addSubview(projectsCollection)
		
		projectsCollection.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reusedId)
		projectsCollection.register(ProjectCell.self, forCellWithReuseIdentifier: ProjectCell.reuseId)
	}
	
	func createCompositionalLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
			let section = self.sections[sectionIndex]
			
			switch section.type {
			default:
				return self.createActiveChatSection()
			}
		}
		return layout
	}
	
	func createActiveChatSection() -> NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(86))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1))
		let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
		let section = NSCollectionLayoutSection(group: group)
		item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 10, trailing: 0)
		section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20)
		
		let header = createSectionHeader()
		section.boundarySupplementaryItems = [header]
		return section
	}
	
	func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
		let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
															 heightDimension: .estimated(1))
		let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize,
																			   elementKind: UICollectionView.elementKindSectionHeader,
																			   alignment: .top)
		return layoutSectionHeader
	}
	
	func createDataSourse() {
		dataSourse = UICollectionViewDiffableDataSource<MSection, MProject>(collectionView: projectsCollection, cellProvider: { (collectionView, indexPath, project) -> UICollectionViewCell? in
			switch self.sections[indexPath.section].type {
		// add storyies
			default:
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectCell.reuseId, for: indexPath) as! ProjectCell
				cell.configure()
				return cell
			}
		})
		dataSourse?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
			guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reusedId, for: indexPath) as? SectionHeader else { return nil }
			guard let firstProject = self?.dataSourse?.itemIdentifier(for: indexPath) else { return nil }
			guard let section = self?.dataSourse?.snapshot().sectionIdentifier(containingItem: firstProject) else { return nil}
			if section.title.isEmpty { return nil}
			sectionHeader.title.text = section.title
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
		view.addSubview(projectsCollection)
		projectsCollection.translatesAutoresizingMaskIntoConstraints								= false
		projectsCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive 		= true
		projectsCollection.topAnchor.constraint(equalTo: view.topAnchor).isActive 					= true
		projectsCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive 			= true
		projectsCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive 			= true
	}
}
