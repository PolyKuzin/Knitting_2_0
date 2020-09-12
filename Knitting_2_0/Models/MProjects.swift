//
//  MProject.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 12.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Project {
    
    let ref						: DatabaseReference?
    let userID					: String
	
    let projectID				: String
    var name					: String
    var imageData				: String
    var tags					: String
    
    init(userID: String,
         projectID: String,
         name: String,
         imageData: String,
         tags: String) {
        self.userID				= userID
        self.projectID			= projectID
        self.name				= name
        self.imageData			= imageData
        self.tags				= tags
        self.ref				= nil
    }
    
    init( snapshot: DataSnapshot) {
        let snapshotValue		= snapshot.value				as! [String: AnyObject]
        userID					= snapshotValue["userID"]		as! String
        projectID				= snapshotValue["projectID"]	as! String
        name					= snapshotValue["name"]			as! String
        imageData				= snapshotValue["imageData"]	as! String
        tags					= snapshotValue["tags"]			as! String
        ref						= snapshot.ref
    }
    
    func projectToDictionary() -> Any {
        return ["userID"		: userID,
                "projectID"		: projectID,
                "name"			: name,
                "imageData"		: imageData,
                "tags"			: tags]
    }
}
