//
//  MSections.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 13.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

struct MSection		: Hashable {
	
	let type		: String
	let title		: String
	var projects	: [MProject]
	
	static func == (lhs: MSection, rhs: MSection) -> Bool {
		return	lhs.type == rhs.type && lhs.title == rhs.title
				
	}
}

struct MCounterSection : Hashable {
	
	let type		: String
	let title		: String
	let image		: UIImageView
	let buttom		: UIButton
	var counters	: [MCounter]
	
	static func == (lhs: MCounterSection, rhs: MCounterSection) -> Bool {
		return	lhs.type == rhs.type && lhs.title == rhs.title
				
	}
}
