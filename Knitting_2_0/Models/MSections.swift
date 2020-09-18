//
//  MSections.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 13.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import Foundation

struct MSection		: Hashable {
	static func == (lhs: MSection, rhs: MSection) -> Bool {
		return	lhs.type == rhs.type && lhs.title == rhs.title
				
	}
	
	let type		: String
	let title		: String
	let projects	: [MProject]
}
