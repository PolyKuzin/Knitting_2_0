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
		print(JSON(snapshot.value as Any))
		let data = JSON(snapshot.value as Any)
		self.ref     = snapshot.ref
		self.name    = data["name"]    .stringValue
		self.date    = data["date"]    .stringValue
		self.rows    = data["rows"]    .intValue
		self.rowsMax = data["rowsMax"] .intValue
	}
	
	func counterToDictionary () -> Any {
		return ["name"    : name    as Any,
				"rows"    : rows    as Any,
				"rowsMax" : rowsMax as Any,
				"date"    : date    as Any]
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
