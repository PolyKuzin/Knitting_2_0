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
		textField.font					= Fonts.placeHolders
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
		textField.font					= Fonts.placeHolders
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
		button.titleLabel?.font			= Fonts.titleButton
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
		label.font						= Fonts.question
		label.text						= Placeholder.questionToRegistrLbl
		label.textColor					= Colors.questionText
		label.textAlignment				= .right
		
		return label
	}()
		
	private lazy var questionButton		: UIButton = {
		let button						= UIButton(type: .system)
		button.frame 					= CGRect(x: 0, y: 0, width: 40, height: 20)
		button.titleLabel?.font			= Fonts.question
		button.layer.masksToBounds		= true
		button.setTitle					(Placeholder.questionToRegistrBtn,	for: .normal)
		button.setTitleColor			(Colors.questionButton, 			for: .normal)
		button.contentHorizontalAlignment = .left
		
		return button
	}()
		
	func setUpLayout(toView view: UIView) {
		//A place of view, where the image is
		let topImageConteinerView = UIView()
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
		
		//A palce for email TextField
		view.addSubview(emailTextField)
		emailTextField.translatesAutoresizingMaskIntoConstraints														= false
		emailTextField.topAnchor.constraint(equalTo: topImageConteinerView.bottomAnchor, constant: 20).isActive			= true
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
		
		//A place for question Label And Question Button
		let bottomLicensSV			= UIStackView(arrangedSubviews: [questionLabel, questionButton])
		bottomLicensSV.distribution = .fill
		
		view.addSubview(bottomLicensSV)
		bottomLicensSV.translatesAutoresizingMaskIntoConstraints														= false
		bottomLicensSV.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive						= true
		bottomLicensSV.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive									= true
		bottomLicensSV.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -16).isActive		= true
		bottomLicensSV.heightAnchor.constraint(equalToConstant: 50).isActive											= true
		
		//A place for registration buttom
		view.addSubview(logInButton)
		logInButton.translatesAutoresizingMaskIntoConstraints															= false
		logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive										= true
		logInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -135).isActive					= true
		logInButton.bottomAnchor.constraint(equalTo: bottomLicensSV.topAnchor, constant: -20).isActive					= true
		logInButton.heightAnchor.constraint(equalToConstant: 50).isActive												= true
		
		//Button alignment
		questionButton.translatesAutoresizingMaskIntoConstraints														= false
		questionButton.widthAnchor.constraint(lessThanOrEqualToConstant: 100).isActive									= true
		questionButton.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: 50).isActive			= true
		
		//Label alignment
		questionLabel.translatesAutoresizingMaskIntoConstraints															= false
		questionLabel.trailingAnchor.constraint(equalTo: questionButton.leadingAnchor, constant: -5).isActive			= true
	}
	
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
