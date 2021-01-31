//
//  ForgotPassVM.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 12.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class ForgotPassVM  {
	
	func logo()				-> UIImageView	{
		return logoIconView
	}
	
	func resetPassLabel() -> UILabel {
		return resetPassLb
	}
	
	func email()			-> UITextField	{
		return emailTextField
	}
	
	func info()				-> UILabel	{
		return infoLabel
	}
	
	func reset() 			-> UIButton {
		return resetButton
	}
	
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
	
	private lazy var resetPassLb		: UILabel		= {
		let label 						= UILabel()
		label.text						= Placeholder.loginIntoAccount
		label.textColor 				= Colors.labelText
		label.font						= Fonts.displaySemibold28
		
		return label
	}()
	
	private lazy var emailTextField		: UITextField = {
		//change the frame of the TextFfield
		let textField = UITextField(frame: CGRect(x: 16,
													y: 448,
													width: UIScreen.main.bounds.width - 32,
													height: 51))
		//design
		textField.placeholder			= Placeholder.enterEmail
		textField.layer.cornerRadius	= CornerRadius.forTextField
		textField.backgroundColor		= Colors.normalTextField
		textField.font					= Fonts.displayRegular18
		textField.layer.borderWidth		= BorderWidth.forTextField
		textField.layer.borderColor		= Colors.normalBorderTextField.cgColor
		textField.leftView				= UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 62))
		textField.leftViewMode 			= .always

		//functionality
		textField.autocorrectionType	= UITextAutocorrectionType.no
		textField.keyboardType			= UIKeyboardType.emailAddress
		textField.returnKeyType 		= UIReturnKeyType.done
		textField.clearButtonMode 		= UITextField.ViewMode.whileEditing
		textField.autocapitalizationType = .none
		
		return textField
	}()
	
	private lazy var infoLabel			: UILabel = {
		let label 						= UILabel(frame: CGRect(x: 0,
																y: 0,
																width: 180,
																height: 20))
		label.font						= Fonts.textRegular14
		label.textColor					= Colors.questionText
		label.numberOfLines				= 0
		label.textAlignment				= .left
		label.text						= Placeholder.resetPasswordForm
		
		return label
	}()
	
	private lazy var resetButton		: UIButton = {
		let button			= UIButton()
		button.backgroundColor = UIColor(red: 0.745, green: 0.616, blue: 0.875, alpha: 1)
		button.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 52)
		button.setTitle(Placeholder.resetPassword.localized(), for: .normal)
		button.setTitleColor(UIColor.white, for: .normal)
		button.titleLabel?.font = UIFont(name: "SFProText-Medium", size: 17)
		button.layer.cornerRadius = 15
		return button
	}()
}
