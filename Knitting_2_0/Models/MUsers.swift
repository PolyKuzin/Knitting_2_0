//
//  MUser.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 10.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import Foundation
import FirebaseAuth

struct Users {
    
    let uid				: String
    let email			: String
	let nickname		: String

    
	init (user: User, nickname: String){
        self.uid		= user.uid
        self.email		= user.email!
		self.nickname	= nickname
    }
}
