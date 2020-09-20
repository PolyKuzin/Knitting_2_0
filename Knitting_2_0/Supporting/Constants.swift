//
//  Constants.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 28.08.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

struct Icons {
    
    static let logoIcon 	= UIImage(named: "logoIcon")
	
	static let backIcon		= UIImage(named: "arrow")
	static let delete		= UIImage(named: "delete")
	static let emptyProject	= UIImage(named: "empty")
	static let emptyProfile	= UIImage(named: "emptyProfile")
	static let exit			= UIImage(named: "exit")

}

struct BorderWidth {
	
	static let forButton	: CGFloat	= 1
	static let forTextField : CGFloat	= 0.5
}

struct CornerRadius {
	
	static let forTextField : CGFloat	= 14
	static let forButton	: CGFloat	= 25
	
	static let forEntryBtn	: CGFloat	= 32
}

struct Colors {
	
	//Normal
	static let normalTextField			= UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1)
	static let normalBorderTextField	= UIColor(red: 0.82,  green: 0.82,  blue: 0.839, alpha: 1)
	static let backgroundUpButton		= UIColor(red: 0.584, green: 0.475, blue: 0.820, alpha: 1)
	static let backgroundDownButton		= UIColor(red: 0.745, green: 0.616, blue: 0.875, alpha: 1)
	static let borderButton				= UIColor(red: 0.265, green: 0.102, blue: 0.613, alpha: 1)
	static let questionText				= UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1)
    static let someErrorHappend			= UIColor(red: 0.962, green: 0.188, blue: 0.467, alpha: 1)

	static let whiteColor				= UIColor.white
	static let questionButton			= UIColor.black
	static let backIcon					= UIColor(red: 0.682, green: 0.682, blue: 0.698, alpha: 1)
	static let hiddenCollectionView		= UIColor(red: 231.0 / 255.0, green: 76.0 / 255.0, blue: 60.0 / 255.0, alpha: 1)
	
	//Errors
    static let errorTextField			= UIColor(red: 1,	  green: 0.954, blue: 0.976, alpha: 1)
    static let errorTextFieldBorder		= UIColor(red: 0.962, green: 0.188, blue: 0.467, alpha: 1)
}

struct Placeholder {
	
	static let nicknameRegistration 	= "Create a nickname"
	static let emailPlaceHolder			= "Enter your e-mail"
	static let passwordRegistration 	= "Create a password"
	static let passwordLogIn			= "Enter your password"
	
	static let forgotPass				= "Forgot your password?" // to test
	static let fillInTheFields			= "Please fill in all fields" // to test
	static let resetPassword			= "Reset" // to test
	static let resetPasswordForm		= "A form for password recovery will be sent to your email address" // to test
	
	static let titleForSingUp			= "Sign up"
	static let titleForLogIn			= "Log in"
	static let questionToLogInLbl		= "Already have an account? "
	static let questionToLogInBtn		= " Log in"
	static let questionToRegistrLbl		= "You don't have an account? "
	static let questionToRegistrBtn		= " Sign up"
	static let createNewAccount			= "Create a new account"
	
	static let emptyProject				= "Empty Project"
}

struct Fonts {
	
	static let displayMedium20			= UIFont(name: "SFProDisplay-Medium",	size: 20)
	static let displayMedium22			= UIFont(name: "SFProDisplay-Medium",	size: 22)
	static let displaySemibold22		= UIFont(name: "SFProDisplay-Semibold", size: 22)
	static let textRegular17			= UIFont(name: "SFProText-Regular", 	size: 17)
	
	static let textRegular14			= UIFont(name: "SFProText-Regular", 	size: 14) // to test

	static let textSemibold17			= UIFont(name: "SFProText-Semibold",	size: 17)
	
	static let textSemibold14			= UIFont(name: "SFProText-Semibold",	size: 14) // to test
	static let displayBold28			= UIFont(name: "SFProDisplay-Bold", 	size: 28)
	static let textBold17				= UIFont(name: "SFProText-Bold", 		size: 17)
	static let displayRegular17			= UIFont(name: "SFProDisplay-Regular", size: 17)
}
