//
//  DTO_Project.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 13.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import SwiftyJSON
import Foundation
import FirebaseDatabase

struct Project : Hashable {
	
	var ref    : DatabaseReference?
	var userID : String?
	
	var name   : String?
	var info   : String? = "some info" // TODO: ДОБАВИТЬ ПОЛЕ
	var image  : UIImage?
	var date   : String?
	var linkedCounters : [Counter]?
	
	init(userID: String, name: String, image: String, date: String) {
		self.userID				= userID
		self.name				= name
		self.image				= image.toImage()
		self.date				= date
		self.ref				= nil
	}
	
	init(snapshot: DataSnapshot) {
//		print(JSON(snapshot.value as Any))
		let data = JSON(snapshot.value as Any)
		self.ref    = snapshot.ref
		self.userID = data["userID"] .stringValue
		self.image  = data["image"]  .stringValue.toImage()
		self.name   = data["name"]   .stringValue
		self.date   = data["date"]   .stringValue
		checkForDefaultValues()
	}
}

// MARK: - DB Issues
extension Project {
	private func updateDefaultImage() {
		guard let ref = self.ref else { return }
		ref.updateChildValues(["image" : "_0"])
		AnalyticsService.reportEvent(with: "Removed Image DEFAILT STRING")
	}
	
	private func updateAllValues() {
		guard let ref = self.ref else { return }
		ref.updateChildValues(["name"  : name  as Any,
								"image" : image as Any,
								"date"  : date  as Any])
	}
	
	private mutating func checkForDefaultValues() {
		if self.image?.toString() == defaultImage {
			self.updateDefaultImage()
		}
	}
	
	private func projectToDictionary() -> Any {
		return ["image"  : image?.toString(),
				"name"   : name,
				"date"	 : date,
				"userID" : userID]
	}
}

// MARK: - Comparable
extension Project : Comparable {
	
	static func < (lhs: Project, rhs: Project) -> Bool {
		if let left = lhs.date, let right = rhs.date {
			return left < right
		}
		return false
	}
}
