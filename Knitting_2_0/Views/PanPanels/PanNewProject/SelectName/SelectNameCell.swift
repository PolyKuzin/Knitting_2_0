//
//  SelectNameCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 24.03.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

class SelectNameCell : UITableViewCell {
	
	static var reuseId = "SelectNameCell"
	
	private var selectName : ((String)->())?
	
	private lazy var textField : UITextField = {
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
		let label 							= UILabel(frame: CGRect(x: 0, y: 0, width: 180, height: 20))
		label.font							= Fonts.textRegular14
		label.textColor						= Colors.errorTextFieldBorder
		label.numberOfLines					= 0
		label.textAlignment					= .left
		return label
	}()

    override func awakeFromNib() {
        super.awakeFromNib()
		self.setupConstraints()
		self.selectionStyle = .none
		self.textField.delegate = self
		self.textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
	}
	
	public func configure(with data: Any) {
		if let data = data as? PanNewProject.ViewState.SelectName {
			self.selectName = data.selectName
			self.textField.text = data.name
		}
	}
}

// MARK: - Layout
extension SelectNameCell {
	
	private func setupConstraints() {
		self.addSubview(self.textField)
		self.textField.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			textField.heightAnchor   .constraint(equalToConstant: 44),
			textField.topAnchor      .constraint(equalTo: self.topAnchor,      constant: 15  ),
			textField.leadingAnchor  .constraint(equalTo: self.leadingAnchor,  constant: 16  ),
			textField.trailingAnchor .constraint(equalTo: self.trailingAnchor, constant: -16 ),
			textField.bottomAnchor   .constraint(equalTo: self.bottomAnchor,   constant: -15 )
		])
	}
}

// MARK: - Select Name
extension SelectNameCell : UITextFieldDelegate {
	
	@objc
	private func textFieldDidChange(textField: UITextField){
		if let name = textField.text {
			self.selectName?(name)
		}
	}
}
