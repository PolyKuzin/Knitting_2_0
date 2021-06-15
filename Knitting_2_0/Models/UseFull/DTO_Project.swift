//
//  DTO_Project.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 13.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct DTO_Project : Hashable {
	
	let ref    : DatabaseReference?
	let userID : String
	
	var name   : String
	var image  : String
	var date   : String
	
	init(userID: String, name: String, image: String, date: String) {
		self.userID				= userID
		self.name				= name
		self.image				= image
		self.date				= date
		self.ref				= nil
	}
	
	init(snapshot: DataSnapshot) {
		let snapshotValue		= snapshot.value				as! [String	: AnyObject]
		image					= snapshotValue["image"]		as! String
		name					= snapshotValue["name"]			as! String
		userID					= snapshotValue["userID"]		as! String
		date					= snapshotValue["date"]			as! String
		ref						= snapshot.ref
	}
	
	func projectToDictionary() -> Any {
		return ["image"			: image,
				"name"			: name,
				"date"			: date,
				"userID"		: userID]
	}
}


// MARK: - Comparable
extension DTO_Project : Comparable {
	
	static func < (lhs: DTO_Project, rhs: DTO_Project) -> Bool {
		return lhs.date < rhs.date
	}
}
