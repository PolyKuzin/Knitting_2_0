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

enum KnitError : String, Error {
	case error  = "Error getting data"
	case noData = "No data available"
}

class NetworkManager : NSObject {
	
	static let shared     = NetworkManager()
	private var userDTO   : MUser!
	private let dataBase  = Database.database()
	private var reference : DatabaseReference!
	
	private var projects  = [Project]()
	
	private override init() {
		guard let user = Auth.auth().currentUser else { return }
		userDTO  = MUser(user: user)
		reference = dataBase.reference(withPath: "users").child(String(userDTO.uid))
	}
	
	public func getProjects(callBack: @escaping (Result<[Project], KnitError>) -> Void) {
		guard self.reference != nil else { return }
		let ref = reference.child("projects")
		ref.getData { (error, snapshot) in
			if let error = error {
				print("Error getting data \(error)")
				callBack(.failure(.error))
			}
			else if snapshot.exists() {
				for item in snapshot.children {
					let project = Project(snapshot: item as! DataSnapshot)
					self.projects.append(project)
				}
				print("Got data \(snapshot.value!)")
				self.projects.sort { $0 < $1 }
				callBack(.success(self.projects))
			} else {
				print("No data available")
				callBack(.failure(.noData))
			}
		}
	}
	
	public func getLinkedCounters(for project: Project, callBack: @escaping (Result<[Counter], KnitError>) -> Void) {
		guard let ref = project.ref?.child("counters") else { return }
		ref.getData { (error, snapshot) in
			var counters : [Counter] = []
			if let error = error {
				print("Error getting data \(error)")
				callBack(.failure(.error))
			}
			else if snapshot.exists() {
				for item in snapshot.children {
					let counter = Counter(snapshot: item as! DataSnapshot)
					counters.append(counter)
				}
				print("Got data \(snapshot.value!)")
				counters.sort { $0 < $1 }
				var ptoject = self.projects.filter { $0.ref == ref}.first
				ptoject?.linkedCounters = counters
				callBack(.success(counters))
			} else {
				print("No data available")
				callBack(.failure(.noData))
			}
		}
	}
	
	public func deleteProject(project: Project) {
		
	}
	
	public func deleteCounter(counter: Counter) {
		
	}
}
