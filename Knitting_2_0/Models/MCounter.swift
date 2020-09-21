//
//  MCounter.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 21.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct CounterToKnit {
    
    let ref						: DatabaseReference?
    let userID					: String
    var projectID				: String
    var name					: String
    var rows					: Int
    var rowsMax					: Int
    var congratulations			: Bool = false
    
    init(userID: String,
         projectID: String,
         name: String,
         rows: Int,
         rowsMax: Int) {
        
        self.userID				= userID
        self.projectID			= projectID
        self.name				= name
        self.rows				= rows
        self.rowsMax			= rowsMax
        self.ref				= nil
    }
    
    init( snapshot: DataSnapshot){
        let snapshotValue		= snapshot.value						as! [String: AnyObject]
        userID					= snapshotValue["userID"]				as! String
        projectID				= snapshotValue["projectID"]			as! String
        name					= snapshotValue["name"]					as! String
        rows					= snapshotValue["rows"]					as! Int
        rowsMax					= snapshotValue["rowsMax"]				as! Int
        congratulations			= snapshotValue["congratulations"]		as! Bool
        ref						= snapshot.ref
    }
    
    func counterToDictionary () -> Any {
        return ["userID"             : userID,
                "projectID"          : projectID,
                "name"               : name,
                "rows"               : rows,
                "rowsMax"            : rowsMax,
                "congratulations"    : congratulations]
    }
}
