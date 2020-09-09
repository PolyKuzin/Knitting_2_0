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
		button.titleLabel?.font			= Fonts.displaySemiBold22
		button.layer.cornerRadius		= CornerRadius.forButton
		button.layer.masksToBounds		= true
		button.setTitle					(Placeholder.titleForLogIn, for: .normal)
		button.setTitleColor			(Colors.questionButton, 	for: .normal)
//		button.setGradientBackground	(colorOne: Colors.backgroundUpButton,
//										 colorTwo: Colors.backgroundDownButton)
			
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
	
	func setUpLayout(toView view: UIView) {
		//A place of view, where the image is
		let topImageConteinerView = UIView()
		view.addSubview(topImageConteinerView)
		topImageConteinerView.translatesAutoresizingMaskIntoConstraints													= false
		topImageConteinerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive							= true
		topImageConteinerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive							= true
		topImageConteinerView.topAnchor.constraint(equalTo: view.topAnchor).isActive									= true
		topImageConteinerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive				= true
		
		//Image or Gif constraints in a cell
		topImageConteinerView.addSubview(logoIconView)
		logoIconView.translatesAutoresizingMaskIntoConstraints															= false
		logoIconView.topAnchor.constraint(equalTo: topImageConteinerView.topAnchor, constant: 50).isActive				= true
		logoIconView.centerXAnchor.constraint(equalTo: topImageConteinerView.centerXAnchor, constant: -10).isActive		= true
		logoIconView.centerYAnchor.constraint(equalTo: topImageConteinerView.centerYAnchor).isActive					= true
		logoIconView.heightAnchor.constraint(equalTo: topImageConteinerView.heightAnchor, multiplier: 0.75).isActive	= true
		logoIconView.heightAnchor.constraint(lessThanOrEqualToConstant: 227.65).isActive								= true
		logoIconView.widthAnchor.constraint(lessThanOrEqualToConstant: 190.17).isActive									= true
		
		//A place for registration buttom
		view.addSubview(signUpButton)
		signUpButton.translatesAutoresizingMaskIntoConstraints															= false
		signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive										= true
		signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44).isActive					= true
		signUpButton.topAnchor.constraint(equalTo: topImageConteinerView.bottomAnchor, constant: 20).isActive			= true
		signUpButton.heightAnchor.constraint(equalToConstant: 64).isActive												= true

		//A place for registration buttom
		view.addSubview(logInButton)
		logInButton.translatesAutoresizingMaskIntoConstraints															= false
		logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive										= true
		logInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -135).isActive					= true
		logInButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 20).isActive						= true
		logInButton.heightAnchor.constraint(equalToConstant: 50).isActive												= true
	}
}
