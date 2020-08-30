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
		let textField = UITextField(frame: CGRect(x: 16,
												  y: 366,
												  width: UIScreen.main.bounds.width - 32,
												  height: 62))
		textField.placeholder			= Placeholder.nicknameRegistration
		textField.layer.cornerRadius	= 14
		textField.backgroundColor		= Colors.normalTextField
		textField.font					= Fonts.placeHolders
		
		return textField
	}()
	
	var emailTextField : UITextField = {
		let textField = UITextField(frame: CGRect(x: 16,
												  y: 448,
												  width: UIScreen.main.bounds.width - 32,
												  height: 62))
		textField.placeholder			= Placeholder.emailRegistration
		textField.layer.cornerRadius	= 14
		textField.backgroundColor		= Colors.normalTextField
		textField.font					= Fonts.placeHolders
		
		return textField
	}()
	
	var passwordTextField : UITextField = {
		let textField = UITextField(frame: CGRect(x: 16,
												  y: 530,
												  width: UIScreen.main.bounds.width - 32,
												  height: 62))
		textField.placeholder			= Placeholder.passwordRegistration
		textField.layer.cornerRadius	= 14
		textField.backgroundColor		= Colors.normalTextField
		textField.font					= Fonts.placeHolders
		
		return textField
	}()
}
