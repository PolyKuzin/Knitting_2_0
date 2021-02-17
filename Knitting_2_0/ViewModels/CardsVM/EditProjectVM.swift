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
		textField.placeholder			= "Project name".localized()
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
		let button			= UIButton()
		button.backgroundColor = UIColor(red: 0.745, green: 0.616, blue: 0.875, alpha: 1)
		button.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 52)
		button.setTitle("Save".localized(), for: .normal)
		button.setTitleColor(UIColor.white, for: .normal)
		button.titleLabel?.font = UIFont(name: "SFProText-Medium", size: 17)
		button.layer.cornerRadius = 15
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
