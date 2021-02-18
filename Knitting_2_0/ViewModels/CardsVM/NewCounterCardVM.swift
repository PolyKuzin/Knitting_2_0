//
//  NewCounterCardVM.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 05.10.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class NewCounterCardVM {

	private lazy var create				 : UILabel = {
		let label						= UILabel()
		label.text 						= "Create new counter"		//TO CONSTANTS
		label.font 						= Fonts.displayMedium20		//CHANGE to dispayBold20
		label.textColor 				= .black					//TO CONSTANTS
		label.textAlignment 			= .center					//TO CONSTANTS
		
		return label
	}()
	
	private lazy var projetNameTextField : UITextField = {
		//Change the frame of the TextFfield
		let textField = UITextField(frame: CGRect(x: 16,
												  y: 448,
												  width: UIScreen.main.bounds.width - 32,
												  height: 44))
		//design
		textField.placeholder			= "Counter name".localized()
		textField.layer.cornerRadius	= CornerRadius.forTextField
		textField.backgroundColor		= Colors.normalTextField
		textField.font					= Fonts.textRegular17
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
	
	private lazy var warningLabel		: UILabel = {
		let label 						= UILabel(frame: CGRect(x: 0,
																y: 0,
																width: 180,
																height: 20))
		label.font						= Fonts.textRegular14
		label.textColor					= Colors.errorTextFieldBorder
		label.numberOfLines				= 0
		label.textAlignment				= .left
		
		return label
	}()
	
	private lazy var setRowsMax			: UILabel = {
		let label						= UILabel()
		label.text						= "Set the number of rows?"
		label.frame						= CGRect(x: 0, y: 0, width: 116, height: 20)
		label.textColor					= UIColor(red: 0.682, green: 0.682, blue: 0.698, alpha: 1)
		label.font						= Fonts.textRegular17
		
		return label
	}()
	
	private lazy var counterSwitch		: UISwitch = {
		let switcher					= UISwitch()
		switcher.onTintColor			= UIColor(red: 0.745, green: 0.616, blue: 0.875, alpha: 1)
		
		return switcher
	}()
	
	private lazy var createBtn			: UIButton = {
		let button			= UIButton()
		button.backgroundColor = UIColor(red: 0.745, green: 0.616, blue: 0.875, alpha: 1)
		button.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 52)
		button.setTitle("Create".localized(), for: .normal)
		button.setTitleColor(UIColor.white, for: .normal)
		button.titleLabel?.font = UIFont(name: "SFProText-Medium", size: 17)
		button.layer.cornerRadius = 15
		return button
	}()
	
	let plusButton								: UIButton = {
		let button							= UIButton()
		button.setImage(UIImage(named: "addProject"), for: .normal)
		button.frame							= CGRect(x: 0, y: 0, width: 49, height: 49)
		button.isEnabled = false
		
		return button
	}()
	
	let minusButton								: UIButton = {
		let button							= UIButton()
		button.setImage(UIImage(named: "minus"), for: .normal)
		button.frame							= CGRect(x: 0, y: 0, width: 32, height: 5)
		button.isEnabled = false

		return button
	}()
	
	private lazy var countersRowsMax	: UITextField = {
		//Change the frame of the TextFfield
		let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 85, height: 50))
		
		//design
		textField.placeholder			= "0"
		textField.textAlignment			= .center
		textField.layer.cornerRadius	= CornerRadius.forTextField
		textField.backgroundColor		= Colors.normalTextField
		textField.font					= Fonts.textRegular17
		textField.layer.borderWidth		= BorderWidth.forTextField
		textField.layer.borderColor		= Colors.normalBorderTextField.cgColor
//		textField.leftView				= UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 62))
		textField.leftViewMode 			= .always
		textField.addDoneCancelToolbar()

		//functionality
		textField.autocorrectionType	= UITextAutocorrectionType.no
		textField.keyboardType			= UIKeyboardType.numberPad
		textField.returnKeyType 		= UIReturnKeyType.done
		textField.clearButtonMode 		= UITextField.ViewMode.whileEditing
		textField.isEnabled = false
		return textField
	}()
	
	func createLabel() -> UILabel {
		return create
	}
	
	func projectName() -> UITextField {
		return projetNameTextField
	}
	
	func createGlobalCounterLabel() -> UILabel {
		return setRowsMax
	}
	
	func globarCounterSwitch() -> UISwitch {
		return counterSwitch
	}
	
	func createButton() -> UIButton {
		return createBtn
	}
	
	func setRowsMaxTF() -> UITextField {
		return countersRowsMax
	}
	
	func plus() -> UIButton {
		return plusButton
	}
	
	func minus() -> UIButton {
		return minusButton
	}
}

