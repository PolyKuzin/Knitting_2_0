//
//  Constants.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 28.08.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

struct Icons {
    
    static let logoIcon = UIImage(named: "logoIcon")
}

struct BorderWidth {
	
	static let forButton	: CGFloat	= 1
	static let forTextField : CGFloat	= 0.5
}

struct CornerRadius {
	
	static let forTextField : CGFloat	= 14
	static let forButton	: CGFloat	= 18
}

struct Colors {
	
	static let normalTextField			= UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1)
	static let normalBorderTextField	= UIColor(red: 0.82,  green: 0.82,  blue: 0.839, alpha: 1)
	static let titleButton				= UIColor(red: 0.265, green: 0.102, blue: 0.613, alpha: 1)
	static let backgroundUpButton		= UIColor(red: 0.584, green: 0.475, blue: 0.820, alpha: 1)
	static let backgroundDownButton		= UIColor(red: 0.745, green: 0.616, blue: 0.875, alpha: 1)
	static let borderButton				= UIColor(red: 0.265, green: 0.102, blue: 0.613, alpha: 1)
	
//	static let 
}

struct Placeholder {
	
	static let nicknameRegistration 	= "Enter your nickname"
	static let emailRegistration		= "Enter your e-mail"
	static let passwordRegistration 	= "Enter your password"
	static let titleForSingUp			= "Sing up"
}

struct Fonts {
	
	static let placeHolders				= UIFont(name: "SFProDisplay-Medium",	size: 20)
	static let titleButton				= UIFont(name: "SFProRounded-Regular",	size: 24)
}
