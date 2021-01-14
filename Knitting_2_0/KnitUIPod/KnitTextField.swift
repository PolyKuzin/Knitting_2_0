//
//  KnitTextField.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 13.01.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

protocol KnitTextFields {
    func setRegistarionForm(on view: UIView)
}

@IBDesignable
public class KnitTextField : UITextField {
    
	init(frame: CGRect, _ p: String?, _ t: UITextAutocapitalizationType?) {
		super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 51))
		(t != nil) ? (autocapitalizationType = t!) : (autocapitalizationType = .none)
		(p != nil) ? (placeholder = p!) : (placeholder = "")
		self.backgroundColor = Colors.normalTextField
		font                 = Fonts.displayRegular18
		layer.cornerRadius   = CornerRadius.forTextField
		layer.borderWidth    = BorderWidth.forTextField
		layer.borderColor    = Colors.normalBorderTextField.cgColor
		leftViewMode         = .always
		clearButtonMode      = UITextField.ViewMode.whileEditing
		keyboardType         = UIKeyboardType.default
		returnKeyType        = UIReturnKeyType.continue
		autocorrectionType   = UITextAutocorrectionType.no
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 51))
	}
    
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
