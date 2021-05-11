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
	private let dataBase  = Database.database()
	private var dto_user  : MUser!
	private var reference : DatabaseReference!
	
	private var counters  = [MCounter]()
	private var projects  = [MProject]()
	
	private override init() {
		guard let currentUser = Auth.auth().currentUser else { return }
		dto_user  = MUser(user: currentUser)
		reference = dataBase.reference(withPath: "users").child(String(dto_user.uid))
	}
	
	private func getProjects() {
		
	}
	
	private func getCounters() {
		
	}
}
