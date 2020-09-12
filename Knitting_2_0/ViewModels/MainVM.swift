//
//  MainVM.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 12.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

protocol CollectionViewViewModelType {
//	var numberOfItems : Int { get }
//	var projects	: [Project] { get }
}

class MainVM : CollectionViewViewModelType {
	
	var projects = [Project(userID: "123456", projectID: "1234567890", name: "Слон", imageRef: "!@#$%^&*()", counterID: "1234567890"),
					Project(userID: "123456", projectID: "1234567890", name: "Слон", imageRef: "!@#$%^&*()", counterID: "1234567890"),
					Project(userID: "123456", projectID: "1234567890", name: "Слон", imageRef: "!@#$%^&*()", counterID: "1234567890"),
					Project(userID: "123456", projectID: "1234567890", name: "Слон", imageRef: "!@#$%^&*()", counterID: "1234567890")]

	var projectsCollectionView : UICollectionView = {
		let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0,
															width:	UIScreen.main.bounds.width,
															height: UIScreen.main.bounds.height - 200),
											  collectionViewLayout: UICollectionViewLayout())
		let layout			= UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 95, right: 20)
		layout.itemSize 	= CGSize(width: UIScreen.main.bounds.width - 32, height: UIScreen.main.bounds.height / 6)
		layout.scrollDirection = .vertical
		
		collectionView.collectionViewLayout              = layout
		collectionView.backgroundColor                   = .purple
			
		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
			
		layout.minimumLineSpacing = 10
		collectionView.contentInset                      = UIEdgeInsets(top: 20, left: 20, bottom: 95, right: 20)
		collectionView.showsHorizontalScrollIndicator    = false
		collectionView.showsVerticalScrollIndicator      = false
			
		//Shadows:
//		let shadowPath0 = UIBezierPath(roundedRect: collectionView.bounds, cornerRadius: 30)
//		collectionView.layer.shadowPath                  = shadowPath0.cgPath
//		collectionView.layer.shadowRadius                = 30
//		collectionView.layer.shadowColor                 = UIColor(red: 1, green: 0, blue: 0, alpha: 1).cgColor
//		collectionView.layer.shadowOpacity               = 1
//		collectionView.layer.bounds                      = collectionView.bounds
//		collectionView.layer.shadowOffset                = CGSize(width: 0, height: 8)
//		collectionView.layer.position                    = collectionView.center
//		collectionView.clipsToBounds                     = false
			
		return collectionView
	}()
}
