//
//  ViewController.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 27.08.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class RegistrationVC	: UIViewController {
	
	private var ref						: DatabaseReference!
	private var logoIcon				= UIImageView()
	private var nicknameTextField		= UITextField()
	private var emailTextField			= UITextField()
	private var passwordTextField		= UITextField()
	private var warning					= UILabel()
	private var signUpButton			= UIButton()
	private var questionToLogInButton	= UIButton()
	private var questionToLogInLabel	= UILabel()
	
	private var viewModel				: RegistrationVM! {
		didSet {
			self.logoIcon				= viewModel.logoIcon	()
			self.nicknameTextField		= viewModel.nickname	()
			self.emailTextField			= viewModel.email		()
			self.passwordTextField		= viewModel.password	()
			self.warning				= viewModel.warning		()
			self.signUpButton 			= viewModel.signUp		()
			self.questionToLogInButton	= viewModel.questionBtn	()
			self.questionToLogInLabel	= viewModel.questionLbl	()
			signUpButton.addTarget			(self, action: #selector(signUpTapped), for: .touchUpInside)
			questionToLogInButton.addTarget	(self, action: #selector(pushLogInVC), for: .touchUpInside)
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor			= .white
		viewModel 						= RegistrationVM()
		setUpLayout()
        ref								= Database.database().reference(withPath: "users")
		let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
		view.addGestureRecognizer(tap)
	}
}

extension RegistrationVC {
	
	@objc
	func signUpTapped() {
		let error = validateFields()
		if error != nil { showError(error!) } else {
			//Create cleaned versions of the data
			guard let nickname	= nicknameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
			guard let email		= emailTextField.text?.trimmingCharacters	(in: .whitespacesAndNewlines) else { return }
			guard let password	= passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }

			let db = Firestore.firestore()
			db.collection("users").addDocument(data: ["nickname"	: nickname,
													  "email"		: email]) { (error) in
				if error != nil { self.showError("Error saving user data") }
			}
				Auth.auth().createUser(withEmail: email, password: password) {[weak self] (user, err) in
					if let error = err as NSError? {
					  switch AuthErrorCode(rawValue: error.code) {
					  case .operationNotAllowed:
						self?.setErrorDesign("The operation is disabled right now. Try again later")
					  case .emailAlreadyInUse:
						self?.setErrorDesign("The email address is already in use by another account.")
					  case .invalidEmail:
						self?.setErrorDesign("The email address is badly formatted")
					  case .weakPassword:
						self?.setErrorDesign("The password must be 6 characters long or more")
					  default:
						self?.setErrorDesign(error.localizedDescription)
					  }
					} else {
						guard let userRef = self?.ref.child((user?.user.uid)!) else { return }
						userRef.setValue(["email"	: user!.user.email,
										  "nickname": nickname])
						self?.pushMainVC()
					}
				}
			}
		dismissKeyBoard()
	}
	
    func validateFields() -> String? {
        
        //check that fields are filled in
        if	nicknameTextField	.text?.trimmingCharacters	(in: .whitespacesAndNewlines)	== "" ||
			emailTextField		.text?.trimmingCharacters	(in: .whitespacesAndNewlines)	== "" ||
			passwordTextField	.text?.trimmingCharacters	(in: .whitespacesAndNewlines)	== "" {
            return "Please fill in all fields"
        }
		return nil
	}
		
	func showError(_ message: String) {
			
		signUpButton.shakeAnimation		()
		nicknameTextField.shakeAnimation()
		emailTextField.shakeAnimation	()
		passwordTextField.shakeAnimation()
		signUpButton.shakeAnimation		()
		warning.text		= message
		warning.alpha		= 1
		warning.isHidden	= false
	}
	
		func setErrorDesign(_ description: String) {
			showError(description)
			passwordTextField.backgroundColor      = Colors.errorTextField
			passwordTextField.layer.borderColor    = Colors.errorTextFieldBorder.cgColor
			passwordTextField.textColor            = Colors.errorTextFieldBorder
			emailTextField.backgroundColor         = Colors.errorTextField
			emailTextField.layer.borderColor       = Colors.errorTextFieldBorder.cgColor
			emailTextField.textColor               = Colors.errorTextFieldBorder
			emailTextField.shakeAnimation	()
			passwordTextField.shakeAnimation()
			signUpButton.shakeAnimation		()
		}
}

//MARK: AUTH
extension RegistrationVC {
    func authitication() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.performSegue(withIdentifier: "LogInSegue", sender: nil)
            }
        }
    }
}

//MARK: Dismiss KeyBoard
extension RegistrationVC {
		
    @objc
    private func dismissKeyBoard() {
        view.endEditing(true)
    }
}

//MARK: Navigation
extension RegistrationVC {
	
	@objc
	func pushLogInVC() {
		let vc = LogInVC()
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
extension RegistrationVC {
	
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
		
		//A palce for nickname TextField
		view.addSubview(nicknameTextField)
		nicknameTextField.translatesAutoresizingMaskIntoConstraints													= false
		nicknameTextField.topAnchor.constraint(equalTo: topImageConteinerView.bottomAnchor, constant: 20).isActive	= true
		nicknameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive			= true
		nicknameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive				= true
		nicknameTextField.heightAnchor.constraint(equalToConstant: 62).isActive 									= true
		
		//A palce for email TextField
		view.addSubview(emailTextField)
		emailTextField.translatesAutoresizingMaskIntoConstraints													= false
		emailTextField.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 20).isActive			= true
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
		
		//A palce for warning label
		view.addSubview(warning)
		warning.isHidden																							= true
		warning.translatesAutoresizingMaskIntoConstraints															= false
		warning.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive						= true
		warning.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8).isActive					= true
		warning.heightAnchor.constraint(greaterThanOrEqualToConstant: 17).isActive									= true
		warning.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16).isActive			= true
		
		//A place for question Label And Question Button
		let bottomLicensSV			= UIStackView(arrangedSubviews: [questionToLogInLabel, questionToLogInButton])
		bottomLicensSV.distribution = .fill

        view.addSubview(bottomLicensSV)
        bottomLicensSV.translatesAutoresizingMaskIntoConstraints													= false
		bottomLicensSV.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive					= true
		bottomLicensSV.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive								= true
		bottomLicensSV.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -16).isActive	= true
		bottomLicensSV.heightAnchor.constraint(equalToConstant: 50).isActive										= true
		
		//A place for registration buttom
		view.addSubview(signUpButton)
		signUpButton.translatesAutoresizingMaskIntoConstraints														= false
		signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive									= true
		signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive				= true
		signUpButton.bottomAnchor.constraint(equalTo: bottomLicensSV.topAnchor, constant: -20).isActive				= true
		signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive											= true
		
		//Button alignment
		questionToLogInButton.translatesAutoresizingMaskIntoConstraints													= false
		questionToLogInButton.widthAnchor.constraint(lessThanOrEqualToConstant: 100).isActive							= true
		questionToLogInButton.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: 50).isActive	= true
	}
}
