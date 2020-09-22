//
//  MProject.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 12.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct MProject : Hashable {
    
    let ref						: DatabaseReference?
    let userID					: String
	
    var name					: String
    var image					: String
    
	init(userID: String, name: String, image: String) {
        self.userID				= userID
        self.name				= name
        self.image				= image
        self.ref				= nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue		= snapshot.value				as! [String: AnyObject]
        image					= snapshotValue["image"]		as! String
        name					= snapshotValue["name"]			as! String
        userID					= snapshotValue["userID"]		as! String
        ref						= snapshot.ref
    }
    
    func projectToDictionary() -> Any {
        return ["image"			: image,
                "name"			: name,
                "userID"		: userID]
    }
}
