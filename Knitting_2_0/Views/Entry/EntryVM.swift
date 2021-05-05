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
			default: return 46
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
		imageView.image					= UIImage.logoIcon
        imageView.contentMode			= .scaleAspectFit
		
        return imageView
	}()
	
	private lazy var signUpButton		: UIButton		= {
		let button			= UIButton()
		button.backgroundColor = UIColor.mainColor
		button.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 52)
		button.setTitle(Placeholder.signUp.localized(), for: .normal)
		button.setTitleColor(UIColor.white, for: .normal)
		button.titleLabel?.font = UIFont.medium_17
		button.layer.cornerRadius = 15
		return button
	}()
	
	private lazy var logInButton		: UIButton		= {
		let button						= UIButton(type: .system)
		button.frame 					= CGRect(x: 0, y: 0, width: 500, height: 21)
		button.titleLabel?.font			= UIFont.semibold_18
		button.alpha					= 0
		button.layer.masksToBounds		= true
		button.setTitle					(Placeholder.logIn,		for: .normal)
		button.setTitleColor			(UIColor.black, for: .normal)
			
		return button
	}()
}
