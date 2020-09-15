//
//  MProject.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 12.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct MProject {
    
    let ref						: DatabaseReference?
    let userID					: String
    let projectID				: String
	
    var name					: String
    var imageRef				: String
	var counterID				: String? = nil
    
	init(userID: String, projectID: String, name: String, imageRef: String, counterID: String? = nil) {
        self.userID				= userID
        self.projectID			= projectID
        self.name				= name
        self.imageRef			= imageRef
		self.counterID			= counterID
        self.ref				= nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue		= snapshot.value				as! [String: AnyObject]
        userID					= snapshotValue["userID"]		as! String
        projectID				= snapshotValue["projectID"]	as! String
        name					= snapshotValue["name"]			as! String
        imageRef				= snapshotValue["imageRef"]		as! String
		counterID				= snapshotValue["counterID"]	as? String
        ref						= snapshot.ref
    }
    
    func projectToDictionaryCounterNO() -> Any {
        return ["userID"		: userID,
                "projectID"		: projectID,
                "name"			: name,
                "imageRef"		: imageRef]
    }
	
    func projectToDictionaryCounterYES() -> Any {
        return ["userID"		: userID,
                "projectID"		: projectID,
                "name"			: name,
                "imageRef"		: imageRef,
				"counterID"		: counterID]
    }
}
