//
//  Constants.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 28.08.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

struct BorderWidth {
	static let forButton	: CGFloat	= 1
	static let forTextField : CGFloat	= 0.5
}

struct CornerRadius {
	static let forButton	: CGFloat	= 25
	static let forEntryBtn	: CGFloat	= 32
	static let forTextField : CGFloat	= 14
}

struct Placeholder {
	
	static let enterEmail				= "E-mail".localized()
	static let enterPassword			= "Enter your password".localized()
	static let createNickname 			= "Nickname".localized()
	static let createPassword 			= "Password".localized()
	
	static let forgotPassword			= "Forgot your password?".localized()
	static let fillInTheFields			= "Please fill in all fields".localized()
	static let resetPassword			= "Reset".localized()
	static let resetPasswordForm		= "We will send you an E-mail. Click the link in the E-mail and reset your password.".localized()
	
	static let logIn					= "Log In".localized()
	static let loginWithSpace			= " Log in".localized()
	static let signUp					= "Sign Up".localized()
	static let signupWithSpace			= " Sign up".localized()
	static let createNewAccount			= "Create new account".localized()
	static let loginIntoAccount			= "Log in to your account".localized()
	static let questionToLogInLbl		= "Already have an account? ".localized()
	static let questionToRegistrLbl		= "You don't have an account? ".localized()	
}
