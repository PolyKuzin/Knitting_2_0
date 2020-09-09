//
//  LogInVC.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 06.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

class LogInVC: UIViewController {

	private var logoIcon				= UIImageView()
	private var emailTextField			= UITextField()
	private var passwordTextField		= UITextField()
	private var logInButton				= UIButton()
	private var questionToRegButton		= UIButton()
	private var questionToRegLabel		= UILabel()
	
	private var viewModel : LogInVM! {
		didSet {
			self.logoIcon				= viewModel.logoIcon()
			self.emailTextField			= viewModel.email()
			self.passwordTextField		= viewModel.password()
			self.logInButton		 	= viewModel.logIn()
			self.questionToRegButton	= viewModel.questionBtn()
			self.questionToRegLabel		= viewModel.questionLbl()
			questionToRegButton.addTarget(self, action: #selector(pushSignUpVC), for: .touchUpInside)
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor			= .white
		viewModel 						= LogInVM()
		setUpLayout()
    }
}

//MARK: Navigation
extension LogInVC {
	@objc
	func pushSignUpVC() {
		let vc = RegistrationVC()
		guard let navigationController = navigationController else { return }
		navigationController.pushViewController(vc, animated: true)
	}
}

//MARK: Layout
extension LogInVC {
	
	func setUpLayout() {
		//A place of view, where the image is
		let topImageConteinerView = UIView()
		view.addSubview(topImageConteinerView)
		topImageConteinerView.translatesAutoresizingMaskIntoConstraints												= false
		topImageConteinerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive						= true
		topImageConteinerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive						= true
		topImageConteinerView.topAnchor.constraint(equalTo: view.topAnchor).isActive								= true
		topImageConteinerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35).isActive		= true
		
		//Image or Gif constraints in a cell
		topImageConteinerView.addSubview(logoIcon)
		logoIcon.translatesAutoresizingMaskIntoConstraints															= false
		logoIcon.centerXAnchor.constraint(equalTo: topImageConteinerView.centerXAnchor, constant: -10).isActive		= true
		logoIcon.centerYAnchor.constraint(equalTo: topImageConteinerView.centerYAnchor, constant: 10).isActive		= true
		logoIcon.heightAnchor.constraint(lessThanOrEqualToConstant: 154.89).isActive								= true
		logoIcon.widthAnchor.constraint(lessThanOrEqualToConstant: 129.39).isActive									= true
		
		//A palce for email TextField
		view.addSubview(emailTextField)
		emailTextField.translatesAutoresizingMaskIntoConstraints													= false
		emailTextField.topAnchor.constraint(equalTo: topImageConteinerView.bottomAnchor, constant: 20).isActive		= true
		emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive				= true
		emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive					= true
		emailTextField.heightAnchor.constraint(equalToConstant: 62).isActive 										= true
		
		//A palce for password TextField
		view.addSubview(passwordTextField)
		passwordTextField.translatesAutoresizingMaskIntoConstraints													= false
		passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20).isActive			= true
		passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive			= true
		passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive				= true
		passwordTextField.heightAnchor.constraint(equalToConstant: 62).isActive 									= true
		
		//A place for question Label And Question Button
		let bottomLicensSV			= UIStackView(arrangedSubviews: [questionToRegLabel, questionToRegButton])
		bottomLicensSV.distribution = .fill
		
		view.addSubview(bottomLicensSV)
		bottomLicensSV.translatesAutoresizingMaskIntoConstraints													= false
		bottomLicensSV.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive					= true
		bottomLicensSV.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive								= true
		bottomLicensSV.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -16).isActive	= true
		bottomLicensSV.heightAnchor.constraint(equalToConstant: 50).isActive										= true
		
		//A place for registration buttom
		view.addSubview(logInButton)
		logInButton.translatesAutoresizingMaskIntoConstraints														= false
		logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive									= true
		logInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -135).isActive				= true
		logInButton.bottomAnchor.constraint(equalTo: bottomLicensSV.topAnchor, constant: -20).isActive				= true
		logInButton.heightAnchor.constraint(equalToConstant: 50).isActive											= true
		
		//Button alignment
		questionToRegButton.translatesAutoresizingMaskIntoConstraints													= false
		questionToRegButton.widthAnchor.constraint(lessThanOrEqualToConstant: 100).isActive								= true
		questionToRegButton.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: 50).isActive	= true
	}
}
