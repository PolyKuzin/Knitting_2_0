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
	
    private var user            	: Users!
    private var ref             	: DatabaseReference!
	private var projectsCollection	: UICollectionView!
	
	private var viewModel	: MainVM! {
		didSet {
			self.projectsCollection = viewModel.projectsCollectionView
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		guard let currentUser = Auth.auth().currentUser else { return }
		user = Users(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("projects")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white
		viewModel = MainVM()
		projectsCollection.dataSource	= self
		projectsCollection.delegate		= self
		setUpLayout()
		
    }
}

//MARK: Collection View Data Source
extension MainVC : UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 4
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        myCell.backgroundColor = UIColor.blue
		
        return myCell
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
		projectsCollection.translatesAutoresizingMaskIntoConstraints	= false
		projectsCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		projectsCollection.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
		projectsCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		projectsCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
	}
}
