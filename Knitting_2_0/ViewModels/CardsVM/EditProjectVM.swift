//
//  EditProjectVM.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 07.10.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class EditProjectCardVM {

	private lazy var create				 : UILabel = {
		let label						= UILabel()
		label.text 						= "Edit project"			//TO CONSTANTS
		label.font 						= Fonts.displayMedium20		//CHANGE to dispayBold20
		label.textColor 				= .black					//TO CONSTANTS
		label.textAlignment 			= .center					//TO CONSTANTS
		
		return label
	}()
	
	private lazy var projectImageView : UIImageView = {
		let imageView					= UIImageView()
		
		imageView.layer.cornerRadius	= 20						//TO CONSTANTS
		imageView.isUserInteractionEnabled = true
		
		return imageView
	}()
	
	private lazy var projetNameTextField : UITextField = {
		//Change the frame of the TextFfield
		let textField = UITextField(frame: CGRect(x: 16,
												  y: 448,
												  width: UIScreen.main.bounds.width - 32,
												  height: 44))
		//design
		textField.placeholder			= "Project name"
		textField.layer.cornerRadius	= CornerRadius.forTextField
		textField.backgroundColor		= Colors.normalTextField
		textField.font					= Fonts.textRegular17
		textField.layer.borderWidth		= BorderWidth.forTextField
		textField.layer.borderColor		= Colors.normalBorderTextField.cgColor
		textField.leftView				= UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 62))
		textField.leftViewMode 			= .always

		//functionality
		textField.autocorrectionType	= UITextAutocorrectionType.no
		textField.keyboardType			= UIKeyboardType.asciiCapable
		textField.returnKeyType 		= UIReturnKeyType.done
		textField.clearButtonMode 		= UITextField.ViewMode.whileEditing
		
		return textField
	}()
	
	private lazy var warningLabel			: UILabel = {
		let label 							= UILabel(frame: CGRect(x: 0,
																y: 0,
																width: 180,
																height: 20))
		label.font							= Fonts.textRegular14
		label.textColor						= Colors.errorTextFieldBorder
		label.numberOfLines					= 0
		label.textAlignment					= .left
		
		return label
	}()
	
	private lazy var createBtn			: UIButton = {
		let button						= UIButton(type: .system)
		button.frame 					= CGRect(x: 0, y: 0, width: 155, height: 50)
		button.titleLabel?.font			= Fonts.textSemibold17
		button.layer.cornerRadius		= CornerRadius.forButton
		button.layer.masksToBounds		= true
		button.setTitle					("Save", for: .normal)
		button.setTitleColor			(Colors.whiteColor, for: .normal)
		button.setGradientBackground	(colorOne: Colors.backgroundUpButton,
										 colorTwo: Colors.backgroundDownButton)
			
		return button
	}()
	
	func createLabel() -> UILabel {
		return create
	}
	
	func profileImage() -> UIImageView {
		return projectImageView
	}
	
	func projectName() -> UITextField {
		return projetNameTextField
	}

	func createButton() -> UIButton {
		return createBtn
	}
}
