//
//  MCounter.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 21.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct MCounter : Hashable, Comparable {
    
    let ref						: DatabaseReference?
	
    
    var name					: String
    var rows					: Int
    var rowsMax					: Int
	var date					: String
    
	init(name: String, rows: Int, rowsMax: Int, date: String) {
        self.name				= name
        self.rows				= rows
        self.rowsMax			= rowsMax
		self.date				= date
        self.ref				= nil
    }
    
    init(snapshot				: DataSnapshot){
        let snapshotValue		= snapshot.value						as! [String	: AnyObject]
        name					= snapshotValue["name"]					as! String
        rows					= snapshotValue["rows"]					as! Int
        rowsMax					= snapshotValue["rowsMax"]				as! Int
		date					= snapshotValue["date"]					as! String
        ref						= snapshot.ref
    }
    
    func counterToDictionary () -> Any {
        return ["name"               : name,
                "rows"               : rows,
                "rowsMax"            : rowsMax,
				"date"				 : date]
    }
	
	static func < (lhs: MCounter, rhs: MCounter) -> Bool {
		return lhs.date < rhs.date
	}
}
