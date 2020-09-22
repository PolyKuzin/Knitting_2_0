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
	
//    var ref             : DatabaseReference!
//    var user            : MUser!
	
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
	
//	private var projects : Array<MProject> = {
//		var projects = Array<MProject>()
//		let currentUser = Auth.auth().currentUser //else { return MSection(type: "projects", title: "Working on this?", projects: [])}
//		let user : MUser = MUser(user: currentUser!)
//        let reff = Database.database().reference(withPath: "users").child(String(user.uid)).child("projects")
//
//		reff.observe(.value, with: { (snapshot) in
//            var _projects = Array<MProject>()
//            for item in snapshot.children {
//                let project = MProject(snapshot: item as! DataSnapshot)
//                _projects.append(project)
//            }
//			projects = _projects
//        })
//		let project = MProject(userID: user.uid, name: "name", image: "imageData")
//		let referenceForProject = reff
//		referenceForProject.setValue(project.projectToDictionary())
//
//		return projects
//	}()

	// Setting up sections
	func sections() -> MSection {
		

		let project1 = MProject(userID: "1", name: "1", image: "1")

		let section = MSection(type: "projects", title: "Working on this?", projects: [project1])
		
		return section
	}
}
