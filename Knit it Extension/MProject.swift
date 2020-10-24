//
//  MProject.swift
//  Knit it Extension
//
//  Created by Павел Кузин on 24.10.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import Foundation

struct MProject 				: Hashable {
	
	var name					: String
	var image					: String
	var date					: String
	
	init(name: String, image: String, date: String) {
		self.name				= name
		self.image				= image
		self.date				= date
	}
}

