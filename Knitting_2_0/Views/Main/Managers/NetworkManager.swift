//
//  NetworkManager.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 11.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class NetworkManager : NSObject {
	
	static let shared     = NetworkManager()
	private var userDTO   : MUser!
	private let dataBase  = Database.database()
	private var reference : DatabaseReference!
	
	private var counters  = [MCounter]()
	private var projects  = [Project]()
	
	private override init() {
		guard let user = Auth.auth().currentUser else { return }
		userDTO  = MUser(user: user)
		reference = dataBase.reference(withPath: "users").child(String(userDTO.uid))
	}
	
	public func getProjects() {
		guard self.reference != nil else { return }
		let ref = reference.child("projects")
		ref.observe(.value) { (snapshot) in
			self.projects.removeAll()
			for item in snapshot.children {
				let project = Project(snapshot: item as! DataSnapshot)
//				if project.image == defaultImage {
//					project.image = "_0"
//					if let referenceForProject = project.ref {
//						referenceForProject.setValue(project.projectToDictionary())
//					}
//				}
//				self.projectsDTOs.append(project)
//				self.projects.sort(by: {
//					return
//							($0.date) > ($1.date)
//				})
			}
		}
	}
}
