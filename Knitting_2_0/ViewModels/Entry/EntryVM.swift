//
//  EntryVM.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 08.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class EntryVM {
	
    private lazy var logoIconView		: UIImageView = {
        let image						= Icons.logoIcon
        let imageView					= UIImageView(frame: CGRect(x: 135.33,
																	y: 116.79,
																	width: 129.39,
																	height: 154.89))
		imageView.image					= image
        imageView.contentMode			= .scaleAspectFit
		
        return imageView
	}()
	
	private lazy var signUpButton		: UIButton = {
		let button						= UIButton(type: .system)
		button.frame 					= CGRect(x: 0, y: 0, width: 500, height: 64)
		button.titleLabel?.font			= Fonts.displayMedium22
		button.layer.cornerRadius		= CornerRadius.forEntryBtn
		button.layer.masksToBounds		= true
		button.setTitle					(Placeholder.createNewAccount, for: .normal)
		button.setTitleColor			(Colors.titleForButton, for: .normal)
		button.setGradientBackground	(colorOne: Colors.backgroundUpButton,
										 colorTwo: Colors.backgroundDownButton)
			
		return button
	}()
	
	private lazy var logInButton		: UIButton = {
		let button						= UIButton(type: .system)
		button.frame 					= CGRect(x: 0, y: 0, width: 500, height: 50)
		button.titleLabel?.font			= Fonts.displaySemibold22
		button.layer.cornerRadius		= CornerRadius.forButton
		button.layer.masksToBounds		= true
		button.setTitle					(Placeholder.titleForLogIn, for: .normal)
		button.setTitleColor			(Colors.questionButton, 	for: .normal)
			
		return button
	}()
	
	func logoIcon()			-> UIImageView {
		return logoIconView
	}
	
	func signUp()			-> UIButton {
		return signUpButton
	}
	
	func logIn()			-> UIButton {
		return logInButton
	}
}
