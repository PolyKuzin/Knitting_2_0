//
//  EntryVM.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 27.08.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class RegistrationVM {
    
    private var logoIconView		: UIImageView = {
        let image						= Icons.logoIcon
		//change the frame of the ImageView
        let imageView					= UIImageView(frame: CGRect(x: 135.33,
																	y: 116.79,
																	width: 129.39,
																	height: 154.89))
		imageView.image					= image
        imageView.contentMode			= .scaleAspectFit

		
        return imageView
	}()
	
	private var nicknameTextField	: UITextField = {
		//change the frame of the TextFfield
		let textField = UITextField(frame: CGRect(x: 16,
												  y: 366,
												  width: UIScreen.main.bounds.width - 32,
												  height: 62))
		//design
		textField.placeholder			= Placeholder.nicknameRegistration
		textField.layer.cornerRadius	= 14
		textField.backgroundColor		= Colors.normalTextField
		textField.font					= Fonts.placeHolders
		textField.layer.borderWidth		= 0.5
		textField.layer.borderColor		= Colors.normalTextFieldBorder.cgColor
		textField.leftView				= UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 62))
		textField.leftViewMode 			= .always
		
		//functionality
		textField.autocorrectionType	= UITextAutocorrectionType.no
		textField.keyboardType			= UIKeyboardType.default
		textField.returnKeyType 		= UIReturnKeyType.done
		textField.clearButtonMode 		= UITextField.ViewMode.whileEditing
		
		return textField
	}()
	
	private var emailTextField		: UITextField = {
		//change the frame of the TextFfield
		let textField = UITextField(frame: CGRect(x: 16,
												  y: 448,
												  width: UIScreen.main.bounds.width - 32,
												  height: 62))
		//design
		textField.placeholder			= Placeholder.emailRegistration
		textField.layer.cornerRadius	= 14
		textField.backgroundColor		= Colors.normalTextField
		textField.font					= Fonts.placeHolders
		textField.layer.borderWidth		= 0.5
		textField.layer.borderColor		= Colors.normalTextFieldBorder.cgColor
		textField.leftView				= UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 62))
		textField.leftViewMode 			= .always
		
		//functionality
		textField.autocorrectionType	= UITextAutocorrectionType.no
		textField.keyboardType			= UIKeyboardType.default
		textField.returnKeyType 		= UIReturnKeyType.done
		textField.clearButtonMode 		= UITextField.ViewMode.whileEditing
		
		return textField
	}()
	
	private var passwordTextField	: UITextField = {
		//change the frame of the TextFfield
		let textField 					= UITextField(frame: CGRect(x: 16,
																	y: 530,
																	width: UIScreen.main.bounds.width - 32,
																	height: 62))
		//design
		textField.placeholder			= Placeholder.passwordRegistration
		textField.layer.cornerRadius	= 14
		textField.backgroundColor		= Colors.normalTextField
		textField.font					= Fonts.placeHolders
		textField.layer.borderWidth		= 0.5
		textField.layer.borderColor		= Colors.normalTextFieldBorder.cgColor
		textField.leftView				= UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 62))
		textField.leftViewMode 			= .always
		
		//functionality
		textField.autocorrectionType	= UITextAutocorrectionType.no
		textField.keyboardType			= UIKeyboardType.default
		textField.returnKeyType 		= UIReturnKeyType.done
		textField.clearButtonMode 		= UITextField.ViewMode.whileEditing
		
		return textField
	}()
	
	private var signUpButton		: UIButton = {
		let button						= UIButton(type: .system)
        button.setTitle("   Продолжить   ", for: .normal)
        button.titleLabel?.font			= UIFont(name: "SFProRounded-Regular", size: 24)
        button.setTitleColor(UIColor(red: 0.265, green: 0.102, blue: 0.613, alpha: 1), for: .normal)
        button.layer.borderWidth		= 1
        button.layer.borderColor		= UIColor(red: 0.265, green: 0.102, blue: 0.613, alpha: 1).cgColor
        button.layer.cornerRadius		= 18
        
        button.isHidden = true
        
        return button
	}()
	
	func setUpLayout(toView view: UIView) {
        //A place of view, where the image is
		let topImageConteinerView = UIView(); topImageConteinerView.backgroundColor = .purple
		view.addSubview(topImageConteinerView)
		topImageConteinerView.translatesAutoresizingMaskIntoConstraints													= false
		topImageConteinerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive							= true
        topImageConteinerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive							= true
        topImageConteinerView.topAnchor.constraint(equalTo: view.topAnchor).isActive									= true
        topImageConteinerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35).isActive			= true
		
        //Image or Gif constraints in a cell
        topImageConteinerView.addSubview(logoIconView)
        logoIconView.translatesAutoresizingMaskIntoConstraints															= false
		logoIconView.topAnchor.constraint(equalTo: topImageConteinerView.topAnchor, constant: 50).isActive				= true
        logoIconView.centerXAnchor.constraint(equalTo: topImageConteinerView.centerXAnchor, constant: -10).isActive		= true
        logoIconView.centerYAnchor.constraint(equalTo: topImageConteinerView.centerYAnchor).isActive					= true
		logoIconView.heightAnchor.constraint(equalTo: topImageConteinerView.heightAnchor, multiplier: 0.75).isActive	= true
		logoIconView.heightAnchor.constraint(lessThanOrEqualToConstant: 154.89).isActive								= true
		logoIconView.widthAnchor.constraint(lessThanOrEqualToConstant: 129.39).isActive									= true

		
		//A palce for nickname TextField
		view.addSubview(nicknameTextField)
		nicknameTextField.translatesAutoresizingMaskIntoConstraints														= false
		nicknameTextField.topAnchor.constraint(equalTo: topImageConteinerView.bottomAnchor, constant: 20).isActive		= true
		nicknameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive				= true
		nicknameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive					= true
		nicknameTextField.heightAnchor.constraint(equalToConstant: 62).isActive 										= true
		
		//A palce for email TextField
		view.addSubview(emailTextField)
		emailTextField.translatesAutoresizingMaskIntoConstraints														= false
		emailTextField.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 20).isActive				= true
		emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive					= true
		emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive						= true
		emailTextField.heightAnchor.constraint(equalToConstant: 62).isActive 											= true
		
		//A palce for password TextField
		view.addSubview(passwordTextField)
		passwordTextField.translatesAutoresizingMaskIntoConstraints														= false
		passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20).isActive				= true
		passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive				= true
		passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive					= true
		passwordTextField.heightAnchor.constraint(equalToConstant: 62).isActive 										= true
	}
	
	func logoIcon()		-> UIImageView {
		return logoIconView
	}
	
	func nickname() 	-> UITextField {
		return nicknameTextField
	}
	
	func email() 		-> UITextField {
		return emailTextField
	}
	
	func password() 	-> UITextField {
		return passwordTextField
	}
	
	func registration() -> UIButton {
		return signUpButton
	}
}
