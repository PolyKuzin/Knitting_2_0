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
        let image = Icons.logoIcon
        let imageView = UIImageView(image: image)
        
        return imageView
    }()
}
