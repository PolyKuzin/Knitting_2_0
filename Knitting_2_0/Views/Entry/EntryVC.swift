//
//  EntryVC.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 06.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit
import StoreKit
import FirebaseAuth

var keyboardBlackArea			   : CGFloat = 0.0
var keyboardReturnDistance		   : CGFloat = 0.0

class EntryVC					   : UIViewController {
	
	private var logoIcon		   = UIImageView		()
	private var signUpButton	   = UIButton			()
	private var logInButton		   = UIButton			()

	private var viewModel		   : EntryVM! {
		didSet {
			keyboardReturnDistance = viewModel.setupKeyboardReturnDistance()
			keyboardBlackArea	   = viewModel.setupKeyboardBlackArea()
			self.logoIcon		   = viewModel.logoIcon()
			self.signUpButton	   = viewModel.signUp  ()
			self.logInButton	   = viewModel.logIn   ()
			logInButton.addTarget (self, action: #selector(pushLogInVC),  for: .touchUpInside)
			signUpButton.addTarget(self, action: #selector(pushSignUpVC), for: .touchUpInside)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		Auth.auth().addStateDidChangeListener { (auth, user) in
			if user != nil {
				self.pushMainVC()
			}
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		UIView.animate(withDuration: 0.5) {
			self.signUpButton.alpha = 1.0
			self.logInButton.alpha	= 1.0
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		viewModel = EntryVM()
		setupLayout()
		switch currentCount {
		case 5, 50, 100, 150, 200, 300, 400:
			requestReview()
		default:
			print("############################")
			print(currentCount)
		}
    }
	
	func requestReview() {
		if #available(iOS 10.3, *) {
			SKStoreReviewController.requestReview()
		} else {
			// Review View is unvailable for lower versions. Please use your custom view.
		}
	}
	
    override func viewDidDisappear(_ animated: Bool)	{
        super.viewWillDisappear(animated)
		guard let navigationController = navigationController else { return }
        navigationController.viewControllers.removeAll(where: { self === $0 })
    }
}

//MARK: Navigation
extension EntryVC {
	
	@objc
	func pushLogInVC()	{
		let vc = LogInVC()
		guard let navigationController = navigationController else { return }
		navigationController.pushViewController(vc, animated: true)
	}
	
	@objc
	func pushSignUpVC()	{
		let vc = SignUpVC()
		guard let navigationController = navigationController else { return }
		navigationController.pushViewController(vc, animated: true)
	}
	
	func pushMainVC()	{
		let vc = ProjectsController()
		guard let navigationController = navigationController else { return }
		navigationController.pushViewController(vc, animated: true)
	}
}

//MARK: Layout
extension EntryVC {
	
	func setupLayout()	{
		
		view.backgroundColor			= .white

		//Navigation Bar scould be invisible
		guard let navigationController = navigationController else { return }
		navigationController.navigationBar.barTintColor		= .white
		navigationController.navigationBar.isTranslucent	= true
		navigationController.navigationBar.shadowImage		= UIImage()
		navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
		
		view.addSubview(logoIcon)
		logoIcon.translatesAutoresizingMaskIntoConstraints	= false
		view.addSubview(logInButton)
		logInButton.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(signUpButton)
		signUpButton.translatesAutoresizingMaskIntoConstraints	= false
		
		NSLayoutConstraint.activate([
			//Image or Gif constraints in a cell
			logoIcon      .heightAnchor	 .constraint(equalToConstant: 219         ),
			logoIcon      .widthAnchor	 .constraint(equalToConstant: 202         ),
			logoIcon      .centerXAnchor .constraint(equalTo: view.centerXAnchor  ),
			
			//A place for login buttom
			logInButton	 .heightAnchor   .constraint(equalToConstant: 21          ),
			logInButton	 .centerXAnchor  .constraint(equalTo: view.centerXAnchor  ),
			logInButton	 .trailingAnchor .constraint(equalTo: view.trailingAnchor,	constant: -16),
			logInButton	 .bottomAnchor   .constraint(equalTo: view.bottomAnchor,	constant:  -48),
			
			//A place for signup buttom
			signUpButton .heightAnchor	 .constraint(equalToConstant: 53          ),
//			signUpButton .widthAnchor	 .constraint(equalToConstant: 200         ),
			signUpButton .centerXAnchor	 .constraint(equalTo: view.centerXAnchor  ),
			signUpButton .trailingAnchor .constraint(equalTo: view.trailingAnchor,   constant:  -16),
			signUpButton .topAnchor		 .constraint(equalTo: logoIcon.bottomAnchor, constant:  163),
			signUpButton .bottomAnchor	 .constraint(equalTo: logInButton.topAnchor, constant:  -24),
		])
	}
}
