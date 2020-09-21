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

}

class MainVM : CollectionViewViewModelType {
	
//MARK: MAIN View Controller
	
	private var addImage : UIImageView = {
		let imageView = UIImageView()
		
		return imageView
	}()
	
	private var addView : UIView = {
		var view = UIView()
		view.frame = CGRect(x: 0, y: 0, width: 109, height: 60)

		view.layer.cornerRadius = 37
		return view
	}()
	
	func addImageView() -> UIImageView {
		return addImage
	}

	func addViewBackground() -> UIView {		
		return addView
	}
	
	// Setting up sections
	func sections() -> MSection {
		let project1 = MProject(userID: "1238", projectID: "123", name: "123", imageRef: "123")
		let project2 = MProject(userID: "1234", projectID: "123", name: "123", imageRef: "123")
		let project3 = MProject(userID: "1235", projectID: "123", name: "123", imageRef: "123")
		let project4 = MProject(userID: "1236", projectID: "123", name: "123", imageRef: "123")
		let project5 = MProject(userID: "1237", projectID: "123", name: "123", imageRef: "123")

		let section = MSection(type: "projects", title: "Working on this?", projects: [project1, project2, project3, project4, project5])
		
		return section
	}
	
	
}
