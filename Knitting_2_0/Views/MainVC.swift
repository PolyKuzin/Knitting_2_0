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
	
//	private var viewModel	: MainVM! {
//		didSet {
//			self.projectsCollection = viewModel.projectsCollectionView
//		}
//	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		guard let currentUser = Auth.auth().currentUser else { return }
		user = MUsers(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("projects")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		let section = MSection(type: "projects", title: "Working on this?", projects: [])
		sections.append(section)
		view.backgroundColor = .white
		setupCollectionView()
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
		projectsCollection.dataSource	= self
		projectsCollection.delegate		= self
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
		item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 10, trailing: 0)
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1))
		
		let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
		
		let section = NSCollectionLayoutSection(group: group)
		section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20)
		
		return section
	}
}

extension MainVC : UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: view.frame.width, height: 76)
	}
}

//MARK: Collection View Data Source
extension MainVC : UICollectionViewDataSource {

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return sections.count
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 4
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectCell.reuseId, for: indexPath) as! ProjectCell

//		let section = sections[indexPath.section]
//		let project = section.projects[indexPath.row]
		cell.configure()//(with: project)
        cell.backgroundColor = UIColor.blue

        return cell
	}
}

//MARK: Collection View Delegate
extension MainVC : UICollectionViewDelegate {

}

//MARK: Layout
extension MainVC {
	
	func setUpLayout() {
		//Navigation Bar scould be invisible
		guard let navigationController = navigationController else { return }
		navigationController.navigationBar.barTintColor		= .white
		navigationController.navigationBar.isTranslucent	= false
		navigationController.navigationBar.shadowImage		= UIImage()
		navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
		self.navigationItem.setHidesBackButton(true, animated: true)
		
		//Projects collection View Layout
		view.addSubview(projectsCollection)
		projectsCollection.translatesAutoresizingMaskIntoConstraints								= false
		projectsCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive 		= true
		projectsCollection.topAnchor.constraint(equalTo: view.topAnchor).isActive 					= true
		projectsCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive 			= true
		projectsCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive 			= true
	}
}
