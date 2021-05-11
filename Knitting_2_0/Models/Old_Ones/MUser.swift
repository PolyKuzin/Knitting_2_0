//
//  MUser.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 10.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import Foundation
import FirebaseAuth

struct MUser {
    
    let uid				: String
    let email			: String
    
	init (user: User){
        self.uid		= user.uid
        self.email		= user.email!
    }
}
