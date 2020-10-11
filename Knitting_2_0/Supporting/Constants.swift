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
	static let whiteColor				= UIColor.white
	static let blackColor				= UIColor.black
	
	static let normalTextField			= UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1)
	static let normalBorderTextField	= UIColor(red: 0.82,  green: 0.82,  blue: 0.839, alpha: 1)
    static let errorTextField			= UIColor(red: 1,	  green: 0.954, blue: 0.976, alpha: 1)
    static let errorTextFieldBorder		= UIColor(red: 0.962, green: 0.188, blue: 0.467, alpha: 1)

	static let questionText				= UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1)
    static let errorLabel				= UIColor(red: 0.962, green: 0.188, blue: 0.467, alpha: 1)
	static let labelText				= UIColor(red: 0.234, green: 0.234, blue: 0.234, alpha: 1)
	
	static let borderButton				= UIColor(red: 0.265, green: 0.102, blue: 0.613, alpha: 1)
	static let backgroundUpButton		= UIColor(red: 0.584, green: 0.475, blue: 0.82,  alpha: 1)
	static let backgroundDownButton		= UIColor(red: 0.745, green: 0.616, blue: 0.875, alpha: 1)


	static let backIcon					= UIColor(red: 0.682, green: 0.682, blue: 0.698, alpha: 1)
	static let hiddenContainerView		= UIColor(red: 231.0 / 255.0, green: 76.0 / 255.0, blue: 60.0 / 255.0, alpha: 1)
	
	//Errors

}

struct Placeholder {
	
	static let enterEmail				= "E-mail"
	static let enterPassword			= "Enter your password"
	static let createNickname 			= "Nickname"
	static let createPassword 			= "Password"
	
	static let forgotPassword			= "Forgot your password?"
	static let fillInTheFields			= "Please fill in all fields"
	static let resetPassword			= "Reset"
	static let resetPasswordForm		= "We will send you an E-mail. Click the link in the E-mail and reset your password."
	
	static let logIn					= "Log In"
	static let loginWithSpace			= " Log in"
	static let signUp					= "Sign Up"
	static let signupWithSpace			= " Sign up"
	static let createNewAccount			= "Create new account"
	static let loginIntoAccount			= "Log in to your account"
	static let questionToLogInLbl		= "Already have an account? "
	static let questionToRegistrLbl		= "You don't have an account? "

	
	static let emptyProject				= "Empty Project"
}

struct Fonts {
	
	static let displayMedium18			= UIFont(name: "SFProDisplay-Medium",	size: 18)
	static let displayMedium20			= UIFont(name: "SFProDisplay-Medium",	size: 20)
	static let displayMedium22			= UIFont(name: "SFProDisplay-Medium",	size: 22)
	static let displaySemibold18		= UIFont(name: "SFProDisplay-Semibold", size: 18)
	static let displaySemibold22		= UIFont(name: "SFProDisplay-Semibold", size: 22)
	static let displaySemibold28		= UIFont(name: "SFProDisplay-Semibold", size: 28)
	static let textRegular17			= UIFont(name: "SFProText-Regular", 	size: 17)
	static let textRegular14			= UIFont(name: "SFProText-Regular", 	size: 14) // to test
	static let textSemibold17			= UIFont(name: "SFProText-Semibold",	size: 17)
	static let textSemibold14			= UIFont(name: "SFProText-Semibold",	size: 14) // to test
	static let displayBold28			= UIFont(name: "SFProDisplay-Bold", 	size: 28)
	static let textBold17				= UIFont(name: "SFProText-Bold", 		size: 17)
	static let displayRegular17			= UIFont(name: "SFProDisplay-Regular", size: 17)
	static let displayRegular18			= UIFont(name: "SFProDisplay-Regular", size: 18)
}
