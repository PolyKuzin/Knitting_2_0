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
        let imageView	= UIImageView(frame: CGRect(x: 135.33,
													y: 116.79,
													width: 129.39,
													height: 154.89))
		imageView.image = image
		
        return imageView
    }()
	
	var nicknameTextField : UITextField = {
		let textField = UITextField()
		
		return textField
	}()
	
	var emailTextField : UITextField = {
		let textField = UITextField()
		
		return textField
	}()
	
	var passwordTextField : UITextField = {
		let textField = UITextField()
		
		return textField
	}()
}
