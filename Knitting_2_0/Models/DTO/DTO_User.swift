//
//  DTO_User.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 11.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import Foundation
import FirebaseAuth

// let json = JSON(snapshot.value) as? [String: AnyObject]
struct DTO_User {
	
	let uid				: String
	let email			: String
	
	init (user: User){
		self.uid		= user.uid
		self.email		= user.email!
	}
}
