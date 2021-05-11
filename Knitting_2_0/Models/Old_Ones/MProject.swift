//
//  MProject.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 12.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct MProject 				: Hashable, Comparable {
    
    let ref						: DatabaseReference?
    let userID					: String
	
    var name					: String
    var image					: String
	var date					: String
    
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
	
	static func < (lhs: MProject, rhs: MProject) -> Bool {
		return lhs.date < rhs.date
	}
}
