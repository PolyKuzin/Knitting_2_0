//
//  LogInVM.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 06.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class LogInVM {
	
    private lazy var logoIconView		: UIImageView = {
        let image						= Icons.logoIcon
        let imageView					= UIImageView(frame: CGRect(x: 135.33,
																	y: 116.79,
																	width: 129.39,
																	height: 154.89))
		imageView.image					= image
        imageView.contentMode			= .scaleAspectFit

		
        return imageView
	}()
	
	private lazy var emailTextField		: UITextField = {
		//change the frame of the TextFfield
		let textField = UITextField(frame: CGRect(x: 16,
													y: 448,
													width: UIScreen.main.bounds.width - 32,
													height: 62))
		//design
		textField.placeholder			= Placeholder.emailPlaceHolder
		textField.layer.cornerRadius	= CornerRadius.forTextField
		textField.backgroundColor		= Colors.normalTextField
		textField.font					= Fonts.displayMedium20
		textField.layer.borderWidth		= BorderWidth.forTextField
		textField.layer.borderColor		= Colors.normalBorderTextField.cgColor
		textField.leftView				= UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 62))
		textField.leftViewMode 			= .always

		//functionality
		textField.autocorrectionType	= UITextAutocorrectionType.no
		textField.keyboardType			= UIKeyboardType.default
		textField.returnKeyType 		= UIReturnKeyType.done
		textField.clearButtonMode 		= UITextField.ViewMode.whileEditing
		
		return textField
		}()
		
	private lazy var passwordTextField	: UITextField = {
		//change the frame of the TextFfield
		let textField 					= UITextField(frame: CGRect(x: 16,
																	y: 530,
																	width: UIScreen.main.bounds.width - 32,
																	height: 62))
		//design
		textField.placeholder			= Placeholder.passwordRegistration
		textField.layer.cornerRadius	= CornerRadius.forTextField
		textField.backgroundColor		= Colors.normalTextField
		textField.font					= Fonts.displayMedium20
		textField.layer.borderWidth		= BorderWidth.forTextField
		textField.layer.borderColor		= Colors.normalBorderTextField.cgColor
		textField.leftView				= UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 62))
		textField.leftViewMode 			= .always

		//functionality
		textField.autocorrectionType	= UITextAutocorrectionType.no
		textField.keyboardType			= UIKeyboardType.default
		textField.returnKeyType 		= UIReturnKeyType.done
		textField.clearButtonMode 		= UITextField.ViewMode.whileEditing
		
		return textField
		}()
		
	private lazy var logInButton		: UIButton = {
		let button						= UIButton(type: .system)
		button.frame 					= CGRect(x: 0, y: 0, width: 500, height: 50)
		button.titleLabel?.font			= Fonts.textSemibold17
		button.layer.cornerRadius		= CornerRadius.forButton
		button.layer.masksToBounds		= true
		button.setTitle					(Placeholder.titleForLogIn, for: .normal)
		button.setTitleColor			(Colors.titleForButton, for: .normal)
		button.setGradientBackground	(colorOne: Colors.backgroundUpButton,
										 colorTwo: Colors.backgroundDownButton)
			
			return button
		}()
		
	private lazy var questionLabel		: UILabel = {
		let label 						= UILabel(frame: CGRect(x: 0,
																y: 0,
																width: 180,
																height: 20))
		label.font						= Fonts.textRegular17
		label.text						= Placeholder.questionToRegistrLbl
		label.textColor					= Colors.questionText
		label.textAlignment				= .right
		
		return label
	}()
		
	private lazy var questionButton		: UIButton = {
		let button						= UIButton(type: .system)
		button.frame 					= CGRect(x: 0, y: 0, width: 40, height: 20)
		button.titleLabel?.font			= Fonts.textRegular17
		button.layer.masksToBounds		= true
		button.setTitle					(Placeholder.questionToRegistrBtn,	for: .normal)
		button.setTitleColor			(Colors.questionButton, 			for: .normal)
		button.contentHorizontalAlignment = .left
		
		return button
	}()
	
	func logoIcon()			-> UIImageView {
		return logoIconView
	}
	
	func email() 			-> UITextField {
		return emailTextField
	}
	
	func password() 		-> UITextField {
		return passwordTextField
	}
	
	func logIn()			-> UIButton {
		return logInButton
	}
	
	func questionLbl()		-> UILabel {
		return questionLabel
	}
	func questionBtn()		-> UIButton {
		return questionButton
	}
}
