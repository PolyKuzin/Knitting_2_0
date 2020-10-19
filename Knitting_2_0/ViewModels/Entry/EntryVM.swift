//
//  EntryVM.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 08.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class EntryVM {
	
	func logoIcon	()	-> UIImageView	{
		return logoIconView
	}
	
	func signUp		()	-> UIButton		{
		return signUpButton
	}
	
	func logIn		()	-> UIButton		{
		return logInButton
	}
	
	func setupKeyboardBlackArea() -> CGFloat {
		switch UIDevice().type {
			case .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax: return 46
			default: return 22
		}
	}
	
	func setupKeyboardReturnDistance() -> CGFloat {
		switch UIDevice().type {
		case .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax: return 350
		default: return 150
		}
	}
	
    private lazy var logoIconView		: UIImageView	= {
        let imageView					= UIImageView()
		imageView.frame 				= CGRect(x: 0, y: 0, width: 129.39, height: 154.89)
		imageView.image					= Icons.logoIcon
        imageView.contentMode			= .scaleAspectFit
		
        return imageView
	}()
	
	private lazy var signUpButton		: UIButton		= {
		let button						= UIButton(type: .system)
		button.frame 					= CGRect(x: 0, y: 0, width: 152, height: 53)
		button.titleLabel?.font			= Fonts.displayMedium18
		button.alpha					= 0
		button.layer.cornerRadius		= button.frame.height / 2
		button.layer.masksToBounds		= true
		button.setTitle					(Placeholder.signUp, for: .normal)
		button.setTitleColor			(Colors.whiteColor, for: .normal)
		button.setGradientBackground	(colorOne: Colors.backgroundUpButton,
										 colorTwo: Colors.backgroundDownButton)
			
		return button
	}()
	
	private lazy var logInButton		: UIButton		= {
		let button						= UIButton(type: .system)
		button.frame 					= CGRect(x: 0, y: 0, width: 500, height: 21)
		button.titleLabel?.font			= Fonts.displaySemibold18
		button.alpha					= 0
		button.layer.masksToBounds		= true
		button.setTitle					(Placeholder.logIn,		for: .normal)
		button.setTitleColor			(Colors.blackColor, for: .normal)
			
		return button
	}()
}
