//
//  EntryVM.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 27.08.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class EntryVM {
    
    var logoIconView : UIImageView = {
        let image		= Icons.logoIcon
        let imageView	= UIImageView(frame: CGRect(x: 100.92,
													y: 205.25,
													width: 190.17,
													height: 227.65))
		imageView.image = image
		
        return imageView
    }()
}
