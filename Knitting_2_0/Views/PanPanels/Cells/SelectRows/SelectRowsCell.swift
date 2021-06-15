//
//  SelectRowsCell.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 04.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

protocol _SelectRowsCell {
	var isEnabled    : Bool        { get set }
	var rowsMax      : Int         { get set }
	var selectRows   : ((Int)->()) { get set }
}

class SelectRowsCell : UITableViewCell {
	
	let plusButton								: UIButton = {
		let button							= UIButton()
		button.setImage(UIImage.plus_btn, for: .normal)
		button.frame							= CGRect(x: 0, y: 0, width: 49, height: 49)
		button.isEnabled = false
		
		return button
	}()
	
	let minusButton								: UIButton = {
		let button							= UIButton()
		button.setImage(UIImage.minus_btn, for: .normal)
		button.frame							= CGRect(x: 0, y: 0, width: 32, height: 5)
		button.isEnabled = false

		return button
	}()
	
	private lazy var textField	: UITextField = {
		let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 85, height: 50))
		
		//design
		textField.placeholder			= "0"
		textField.textAlignment			= .center
		textField.layer.cornerRadius	= CornerRadius.forTextField
		textField.backgroundColor		= Colors.normalTextField
		textField.font					= UIFont.regular_17
		textField.layer.borderWidth		= BorderWidth.forTextField
		textField.layer.borderColor		= Colors.normalBorderTextField.cgColor
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
	
	private var selectRows : ((Int)->())?

    override func awakeFromNib() {
        super.awakeFromNib()
		self.setConstraints()
		self.selectionStyle = .none
		self.plusButton.addTarget(self, action: #selector(addNumberToTextField), for: .touchUpInside)
		self.minusButton.addTarget(self, action: #selector(removeNumberFromTextField), for: .touchUpInside)
		self.textField.delegate = self
		self.textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
	}
	
	@objc
	func addNumberToTextField() {
		if !textField.text!.isEmpty {
			var numb = Int(textField.text!)!
			numb += 1
			self.selectRows?(numb)
			textField.text = String(numb)
		} else {
			self.selectRows?(0)
			textField.text = "0"
		}
	}
	
	@objc
	func removeNumberFromTextField() {
		if Int(textField.text!)! != 0 {
			var numb = Int(textField.text!)!
			numb -= 1
			self.selectRows?(numb)
			textField.text = String(numb)
		}
	}
	
	private func setConstraints() {
		addSubview(textField)
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive		= true
		textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive		= true
		textField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		textField.widthAnchor.constraint(equalToConstant: 100).isActive = true
		textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
		
		addSubview(plusButton)
		plusButton.translatesAutoresizingMaskIntoConstraints = false
		plusButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
		plusButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 15).isActive = true
		plusButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
		plusButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
		
		addSubview(minusButton)
		minusButton.translatesAutoresizingMaskIntoConstraints = false
		minusButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
		minusButton.trailingAnchor.constraint(equalTo: textField.leadingAnchor, constant: -15).isActive = true
		minusButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
		minusButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
	}
	
	public func configure(with data: _SelectRowsCell) {
		self.selectRows = data.selectRows
		self.textField.text = String(data.rowsMax)
		self.handleEenabling(data.isEnabled)
	}
	
	private func handleEenabling(_ enable: Bool) {
		if enable {
			self.textField.alpha = 1
			self.plusButton.alpha = 1
			self.minusButton.alpha = 1
			plusButton.isEnabled  = true
			minusButton.isEnabled = true
			textField.isEnabled   = true
		} else {
			self.textField.alpha = 0.3
			self.plusButton.alpha = 0.3
			self.minusButton.alpha = 0.3
			plusButton.isEnabled  = false
			minusButton.isEnabled = false
			textField.isEnabled   = false
		}
	}
}

// MARK: - Select Name
extension SelectRowsCell : UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.endEditing(true)
	}
	
	@objc
	private func textFieldDidChange(textField: UITextField){
		guard let numb = textField.text,
			  let rows = Int(numb)
		else { return }
		self.selectRows?(rows)
	}
}
