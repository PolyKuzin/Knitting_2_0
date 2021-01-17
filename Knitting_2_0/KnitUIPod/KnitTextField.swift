//
//  KnitTextField.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 13.01.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit

@objc
protocol KnitUI {
    @objc optional var nameFild     : KnitTextField { get set }
    @objc optional var emailFild    : KnitTextField { get set }
    @objc optional var passwordFild : KnitTextField { get set }
    @objc optional var resetFild    : KnitTextField { get set }
}

@objc
protocol KnitFild {
    @objc optional func set(font: UIFont)
    @objc optional func set(frame: CGRect)
    @objc optional func set(cornerRadius: CGFloat)
    @objc optional func set(keyboardType: UIKeyboardType)
    @objc optional func set(clearButtonMode: UITextField.ViewMode)
    @objc optional func set(autocorrectionType: UITextAutocorrectionType)
}

@IBDesignable
public class KnitTextField : UITextField, KnitFild {
    
	init() {
		super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 51))
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
    
    func set(font: UIFont) { self.font = font }
    
    func set(frame: CGRect) { self.frame = frame }
    
    
}
