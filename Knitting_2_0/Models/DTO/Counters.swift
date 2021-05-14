//
//  Counters.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 14.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import SwiftyJSON
import Foundation
import FirebaseDatabase

struct Counter : Hashable {
	
	var ref : DatabaseReference?
	
	var name    : String?
	var rows    : Int?
	var rowsMax : Int?
	var date    : String?
	
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
}

extension Counter : Comparable {
	
	static func < (lhs: Counter, rhs: Counter) -> Bool {
		if let left = lhs.date, let right = rhs.date {
			return left < right
		}
		return false
	}
}
