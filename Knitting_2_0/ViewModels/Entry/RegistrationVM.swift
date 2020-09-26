//
//  EntryVM.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 27.08.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class RegistrationVM {
	
	func logoIcon	()		-> UIImageView	{
		return logoIconView
	}
	
	func titleLabel	()		-> UILabel		{
		return createAccountLabel
	}
	
	func nickname	() 		-> UITextField	{
		return nicknameTextField
	}
	
	func email		() 		-> UITextField	{
		return emailTextField
	}
	
	func password	() 		-> UITextField	{
		return passwordTextField
	}
	
	func warning	()		-> UILabel		{
		return warningLabel
	}
	
	func signUp		()		-> UIButton		{
		return signUpButton
	}
	
	func questionLbl()		-> UILabel		{
		return questionLabel
	}
	
	func questionBtn()		-> UIButton		{
		return questionButton
	}
    
    private lazy var logoIconView		: UIImageView	= {
        let imageView					= UIImageView()
		imageView.frame 				= CGRect(x: 0, y: 0, width: 129.39, height: 154.89)
		imageView.image					= Icons.logoIcon
        imageView.contentMode			= .scaleAspectFit
		
        return imageView
	}()
	
	private lazy var createAccountLabel	: UILabel		= {
		let label 						= UILabel()
		label.text						= Placeholder.createNewAccount
		label.textColor 				= Colors.labelText
		label.font						= Fonts.displaySemibold28
		
		return label
	}()
	
	private lazy var nicknameTextField	: UITextField	= {
		let tF							= UITextField()
		tF.frame						= CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 51)
		tF.placeholder					= Placeholder.createNickname
		tF.layer.cornerRadius			= CornerRadius.forTextField
		tF.backgroundColor				= Colors.normalTextField
		tF.font							= Fonts.displayMedium20
		tF.layer.borderWidth			= BorderWidth.forTextField
		tF.layer.borderColor			= Colors.normalBorderTextField.cgColor
		tF.leftView						= UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 62))
		tF.leftViewMode 				= .always
		
		tF.autocorrectionType			= UITextAutocorrectionType.no
		tF.keyboardType					= UIKeyboardType.default
		tF.returnKeyType 				= UIReturnKeyType.continue
		tF.clearButtonMode 				= UITextField.ViewMode.whileEditing
		tF.autocapitalizationType 		= .none
		
		return tF
	}()
	
	private lazy var emailTextField		: UITextField = {
		let tF 							= UITextField()
		tF.frame 						= CGRect(x: 16, y: 448, width: UIScreen.main.bounds.width - 32,height: 51)
		tF.placeholder					= Placeholder.enterEmail
		tF.layer.cornerRadius			= CornerRadius.forTextField
		tF.backgroundColor				= Colors.normalTextField
		tF.font							= Fonts.displayMedium20
		tF.layer.borderWidth			= BorderWidth.forTextField
		tF.layer.borderColor			= Colors.normalBorderTextField.cgColor
		tF.leftView						= UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 51))
		tF.leftViewMode 				= .always
		
		tF.autocorrectionType			= UITextAutocorrectionType.no
		tF.keyboardType					= UIKeyboardType.default
		tF.returnKeyType 				= UIReturnKeyType.continue
		tF.clearButtonMode 				= UITextField.ViewMode.whileEditing
		tF.autocapitalizationType 		= .none

		return tF
	}()
	
	private lazy var passwordTextField	: UITextField = {
		let tF 							= UITextField()
		tF.frame 						= CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 51)
		tF.placeholder					= Placeholder.createPassword
		tF.layer.cornerRadius			= CornerRadius.forTextField
		tF.backgroundColor				= Colors.normalTextField
		tF.font							= Fonts.displayMedium20
		tF.layer.borderWidth			= BorderWidth.forTextField
		tF.layer.borderColor			= Colors.normalBorderTextField.cgColor
		tF.leftView						= UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 62))
		tF.leftViewMode 				= .always
		
		tF.autocorrectionType			= UITextAutocorrectionType.no
		tF.keyboardType					= UIKeyboardType.default
		tF.returnKeyType 				= UIReturnKeyType.done
		tF.clearButtonMode 				= UITextField.ViewMode.whileEditing
		tF.isSecureTextEntry 			= true
		tF.autocapitalizationType 		= .none
		
		return tF
	}()
	
	private lazy var warningLabel		: UILabel = {
		let label 						= UILabel()
		label.frame 					= CGRect(x: 0, y: 0, width: 180, height: 20)
		label.font						= Fonts.textRegular14
		label.textColor					= Colors.errorLabel
		label.numberOfLines				= 0
		label.textAlignment				= .left
		
		return label
	}()
	
	private lazy var signUpButton		: UIButton = {
		let button						= UIButton(type: .system)
		button.frame 					= CGRect(x: 0, y: 0, width: 500, height: 53)
		button.titleLabel?.font			= Fonts.textSemibold17
		button.layer.cornerRadius		= CornerRadius.forButton
        button.layer.masksToBounds		= true
		button.setTitle					(Placeholder.createNewAccount, for: .normal)
		button.setTitleColor			(Colors.whiteColor, for: .normal)
		button.setGradientBackground	(colorOne: Colors.backgroundUpButton,
										 colorTwo: Colors.backgroundDownButton)
        
        return button
	}()
	
	private lazy var questionLabel		: UILabel = {
		let label 						= UILabel()
		label.frame						= CGRect(x: 0, y: 0, width: 180, height: 20)
		label.font						= Fonts.textRegular17
		label.text						= Placeholder.questionToLogInLbl
		label.textColor					= Colors.questionText
		label.textAlignment				= .right
		
		return label
	}()
	
	private lazy var questionButton		: UIButton = {
		let button						= UIButton(type: .system)
		button.frame 					= CGRect(x: 0, y: 0, width: 40, height: 20)
		button.titleLabel?.font			= Fonts.textRegular17
		button.layer.masksToBounds		= true
		button.setTitle					(Placeholder.loginWithSpace,	for: .normal)
		button.setTitleColor			(Colors.questionButton, 		for: .normal)
		button.contentHorizontalAlignment = .left
		
        return button
	}()
}
