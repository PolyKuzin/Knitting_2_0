//
//  LogInVC.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 06.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInVC: UIViewController {

	private var logoIcon				= UIImageView()
	private var emailTextField			= UITextField()
	private var passwordTextField		= UITextField()
	private var forgotPass				= UIButton()
	private var warning					= UILabel()
	private var logInButton				= UIButton()
	private var questionToRegButton		= UIButton()
	private var questionToRegLabel		= UILabel()
	
	private var viewModel				: LogInVM! {
		didSet {
			self.logoIcon				= viewModel.logoIcon()
			self.emailTextField			= viewModel.email()
			self.passwordTextField		= viewModel.password()
			self.forgotPass				= viewModel.forgotPassword()
			self.warning				= viewModel.warnig()
			self.logInButton		 	= viewModel.logIn()
			self.questionToRegButton	= viewModel.questionBtn()
			self.questionToRegLabel		= viewModel.questionLbl()
			forgotPass.addTarget			(self, action: #selector(pushForgotPassVC), for: .touchUpInside)
			logInButton.addTarget			(self, action: #selector(logInTapped), for: .touchUpInside)
			questionToRegButton.addTarget	(self, action: #selector(pushSignUpVC), for: .touchUpInside)
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor			= .white
		let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
		view.addGestureRecognizer(tap)
		viewModel 						= LogInVM()
		setUpLayout()
    }
}

//MARK: Lon In Tapped
extension LogInVC {
	
	@objc
	func logInTapped() {
		let error = validateFields()
		if error != nil { showError(error!) }
		else {
			let email		= emailTextField.text!.trimmingCharacters	(in: .whitespacesAndNewlines)
			let password	= passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
			Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
				if let error = err as NSError? {
				  switch AuthErrorCode(rawValue: error.code) {
				  case .operationNotAllowed:
					self.setErrorDesign("E-mail and password accounts are not enabled.")
				  case .userDisabled:
					self.setErrorDesign("The user account has been disabled by an administrator.")
				  case .wrongPassword:
					self.setErrorDesign("The password is invalid or the user does not have a password.")
				  case .invalidEmail:
					self.setErrorDesign("The email address is malformed.")
				  default:
					self.setErrorDesign(error.localizedDescription)
				  }
				} else {
					self.pushMainVC()
				}
			}
		}
		dismissKeyBoard()
	}
}

//MARK: Error handling
extension LogInVC {
	
    func validateFields() -> String? {
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)	== "" ||
        passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all the fields"
        }
        return nil
    }
	
    func showError(_ message: String) {
        warning.isHidden		= false
        warning.text			= message
        warning.alpha			= 1
    }
	
	func setErrorDesign(_ description: String) {
		passwordTextField.backgroundColor      = Colors.errorTextField
		passwordTextField.layer.borderColor    = Colors.errorTextFieldBorder.cgColor
		passwordTextField.textColor            = Colors.errorTextFieldBorder
		emailTextField.backgroundColor         = Colors.errorTextField
		emailTextField.layer.borderColor       = Colors.errorTextFieldBorder.cgColor
		emailTextField.textColor               = Colors.errorTextFieldBorder
							
//TODO: ErrorHandling; + methods to specify the errors in the UI
		showError(description)
		
		emailTextField.shakeAnimation()
		passwordTextField.shakeAnimation()
		forgotPass.shakeAnimation()
		logInButton.shakeAnimation()
	}
}

//MARK: Dismiss KeyBoard
extension LogInVC {
		
    @objc
    private func dismissKeyBoard() {
        view.endEditing(true)
    }
}

//MARK: Navigation
extension LogInVC {
	
	@objc
	func pushForgotPassVC() {
		let vc = ForgotPassVC()
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
	@objc
	func pushSignUpVC() {
		let vc = RegistrationVC()
		guard let navigationController = navigationController else { return }
		navigationController.pushViewController(vc, animated: true)
	}
	
	func pushMainVC() {
		let vc = MainVC()
		guard let navigationController = navigationController else { return }
		navigationController.pushViewController(vc, animated: true)
	}
}

//MARK: Layout
extension LogInVC {
	
	func setUpLayout() {
		//Navigation Bar scould be invisible
		self.navigationItem.setHidesBackButton(true, animated: true)
		
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
		
		//A palce for "forgot your password" button
		view.addSubview(forgotPass)
		forgotPass.translatesAutoresizingMaskIntoConstraints														= false
		forgotPass.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16).isActive					= true
		forgotPass.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8).isActive				= true
		forgotPass.heightAnchor.constraint(equalToConstant: 17).isActive											= true
		forgotPass.leadingAnchor.constraint(lessThanOrEqualTo: view.centerXAnchor).isActive							= true
		
		//A palce for warning label
		view.addSubview(warning)
		warning.isHidden																							= true
		warning.translatesAutoresizingMaskIntoConstraints															= false
		warning.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive						= true
		warning.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8).isActive					= true
		warning.heightAnchor.constraint(greaterThanOrEqualToConstant: 17).isActive									= true
		warning.trailingAnchor.constraint(lessThanOrEqualTo: view.centerXAnchor).isActive							= true
		
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
