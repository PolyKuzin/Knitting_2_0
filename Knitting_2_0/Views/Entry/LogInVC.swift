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

	private var logoIcon				= UIImageView	()
	private var loginIntoAccount		= UILabel		()
	private var emailTextField			= UITextField	()
	private var passwordTextField		= UITextField	()
	private var forgotPass				= UIButton		()
	private var warning					= UILabel		()
	private var logInButton				= UIButton		()
	private var questionToRegButton		= UIButton		()
	private var questionToRegLabel		= UILabel		()
	
	private var viewModel				: LogInVM! {
		didSet {
			self.logoIcon				= viewModel.logoIcon		()
			self.loginIntoAccount		= viewModel.titleLabel		()
			self.emailTextField			= viewModel.email			()
			self.passwordTextField		= viewModel.password		()
			self.forgotPass				= viewModel.forgotPassword	()
			self.warning				= viewModel.warnig			()
			self.logInButton		 	= viewModel.logIn			()
			self.questionToRegButton	= viewModel.questionBtn		()
			self.questionToRegLabel		= viewModel.questionLbl		()
			logInButton			.addTarget(self, action: #selector(logInTapped),		for: .touchUpInside)
			questionToRegButton	.addTarget(self, action: #selector(pushSignUpVC),		for: .touchUpInside)
			forgotPass			.addTarget(self, action: #selector(pushForgotPassVC),	for: .touchUpInside)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		emailTextField.text		= ""
		passwordTextField.text	= ""
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor				= .white
		viewModel 							= LogInVM()
		setingUpKeyboardHiding()
		let tap : UITapGestureRecognizer	= UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
		view.addGestureRecognizer(tap)
		setUpLayout()
    }
}

//MARK: Auth
extension LogInVC {
	
	@objc
	func logInTapped() {
		let error = validateFields()
		if error != nil { showError(error!) }
		else {
			guard let email		= emailTextField	.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
			guard let password	= passwordTextField	.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
			Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
				if let error = err as NSError? {
				  switch AuthErrorCode(rawValue: error.code) {
				  case .operationNotAllowed	:
					self.setErrorDesign("E-mail and password accounts are not enabled.")
				  case .userDisabled		:
					self.setErrorDesign("The user account has been disabled by an administrator.")
				  case .wrongPassword		:
					self.setErrorDesign("Incorrect password")
				  case .invalidEmail		:
					self.setErrorDesign("The email address is malformed.")
				  default					:
					self.setErrorDesign(error.localizedDescription)
				  }
				} else {
					self.dismissKeyBoard()
					self.pushMainVC		()
					AnalyticsService.reportEvent(with: "LogedIn")
				}
			}
		}
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
		showError(description)
		emailTextField.backgroundColor         = Colors.errorTextField
		emailTextField.layer.borderColor       = Colors.errorTextFieldBorder.cgColor
		emailTextField.textColor               = Colors.errorTextFieldBorder
		passwordTextField.backgroundColor      = Colors.errorTextField
		passwordTextField.layer.borderColor    = Colors.errorTextFieldBorder.cgColor
		passwordTextField.textColor            = Colors.errorTextFieldBorder
		emailTextField.shakeAnimation		()
		passwordTextField.shakeAnimation	()
		forgotPass.shakeAnimation			()
		logInButton.shakeAnimation			()
	}
}

// MARK: Keyboard Issues
extension LogInVC: UITextFieldDelegate {
    
    func setingUpKeyboardHiding(){
        emailTextField		.delegate = self
        passwordTextField	.delegate = self
		
        NotificationCenter.default.addObserver(self,	selector: #selector(keyboardWillChange(notification: )),	name: UIResponder.keyboardWillShowNotification,			object: nil)
        NotificationCenter.default.addObserver(self,	selector: #selector(keyboardWillChange(notification: )),	name: UIResponder.keyboardWillHideNotification,			object: nil)
        NotificationCenter.default.addObserver(self,	selector: #selector(keyboardWillChange(notification: )),	name: UIResponder.keyboardWillChangeFrameNotification,	object: nil)
    }
    
    func hideKeyboard(){
        emailTextField		.resignFirstResponder()
        passwordTextField	.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if 			textField == emailTextField {
			passwordTextField.becomeFirstResponder()
		} else {
			hideKeyboard()
		}
        return true
    }
    
    @objc
	func keyboardWillChange(notification: Notification){
		guard let userInfo = notification.userInfo else {return}
			  let keyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		if notification.name == UIResponder.keyboardWillShowNotification ||
		   notification.name == UIResponder.keyboardWillChangeFrameNotification {
			view.frame.origin.y = -keyboardRect.height + 150
		} else {
			view.frame.origin.y += keyboardRect.height - 150
		}
    }
		
    @objc
    private func dismissKeyBoard() {
        hideKeyboard()
    }
}

//MARK: Navigation
extension LogInVC {
	
	@objc
	func pushForgotPassVC() {
		let vc = ForgotPassVC()
		guard let navigationController = navigationController else { return }
		navigationController.pushViewController(vc, animated: true)
	}
	
	@objc
	func pushSignUpVC() {
		let vc = SignUpVC()
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
		let imageContainer = UIView()
		view.addSubview(imageContainer)
		imageContainer.translatesAutoresizingMaskIntoConstraints												= false
		imageContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive						= true
		imageContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive						= true
		imageContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive								= true
		imageContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive			= true
		
		//A place for title
		view.addSubview(loginIntoAccount)
		loginIntoAccount.translatesAutoresizingMaskIntoConstraints														= false
		loginIntoAccount.topAnchor			.constraint(equalTo: imageContainer.bottomAnchor)				.isActive	= true
		loginIntoAccount.leadingAnchor		.constraint(equalTo: view.leadingAnchor, constant: 16)			.isActive	= true
		loginIntoAccount.trailingAnchor	.constraint(equalTo: view.trailingAnchor, constant: -16)		.isActive	= true
		loginIntoAccount.heightAnchor		.constraint(equalToConstant: 33)								.isActive	= true
		
		//Image or Gif constraints in a cell
		imageContainer.addSubview(logoIcon)
		logoIcon.translatesAutoresizingMaskIntoConstraints															= false
		logoIcon.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor).isActive		= true
		logoIcon.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor, constant: 10).isActive		= true
		logoIcon.heightAnchor.constraint(lessThanOrEqualToConstant: 154.89).isActive								= true
		logoIcon.widthAnchor.constraint(lessThanOrEqualToConstant: 129.39).isActive									= true
		
		//A palce for email TextField
		view.addSubview(emailTextField)
		emailTextField.translatesAutoresizingMaskIntoConstraints													= false
		emailTextField.topAnchor.constraint(equalTo: loginIntoAccount.bottomAnchor, constant: 20).isActive		= true
		emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive				= true
		emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive					= true
		emailTextField.heightAnchor.constraint(equalToConstant: 51).isActive 										= true
		
		//A palce for password TextField
		view.addSubview(passwordTextField)
		passwordTextField.translatesAutoresizingMaskIntoConstraints													= false
		passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20).isActive			= true
		passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive			= true
		passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive				= true
		passwordTextField.heightAnchor.constraint(equalToConstant: 51).isActive 									= true
		
		//A palce for "forgot your password" button
		view.addSubview(forgotPass)
		forgotPass.translatesAutoresizingMaskIntoConstraints														= false
		forgotPass.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive					= true
		forgotPass.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8).isActive				= true
		forgotPass.heightAnchor.constraint(equalToConstant: 17).isActive											= true
//		forgotPass.leadingAnchor.constraint(lessThanOrEqualTo: view.centerXAnchor).isActive							= true
		
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
		bottomLicensSV.heightAnchor.constraint(equalToConstant: 18).isActive										= true
		
		//A place for registration buttom
		view.addSubview(logInButton)
		logInButton.translatesAutoresizingMaskIntoConstraints														= false
		logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive									= true
		logInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive				= true
		logInButton.bottomAnchor.constraint(equalTo: bottomLicensSV.topAnchor, constant: -20).isActive				= true
		logInButton.heightAnchor.constraint(equalToConstant: 53).isActive											= true
		
		//Button alignment
		questionToRegButton.translatesAutoresizingMaskIntoConstraints													= false
//		questionToRegButton.widthAnchor.constraint(lessThanOrEqualToConstant: 100).isActive								= true
		questionToRegButton.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: 50).isActive	= true
	}
}
