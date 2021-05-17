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

class SignUpVC	: UIViewController {
	
	private var dbReference				: DatabaseReference!
	private var logoIcon				= UIImageView	()
	private var createAccount			= UILabel		()
	private var nicknameTextField		= UITextField	()
	private var emailTextField			= UITextField	()
	private var passwordTextField		= UITextField	()
	private var warning					= UILabel		()
	private var signUpButton			= UIButton		()
	private var questionToLogInButton	= UIButton		()
	private var questionToLogInLabel	= UILabel		()

	private var viewModel				: RegistrationVM! {
		didSet {
			self.logoIcon				= viewModel.logoIcon	()
			self.createAccount			= viewModel.titleLabel	()
			self.nicknameTextField		= viewModel.nickname	()
			self.emailTextField			= viewModel.email		()
			self.passwordTextField		= viewModel.password	()
			self.warning				= viewModel.warning		()
			self.signUpButton 			= viewModel.signUp		()
			self.questionToLogInButton	= viewModel.questionBtn	()
			self.questionToLogInLabel	= viewModel.questionLbl	()
			signUpButton			.addTarget	(self, action: #selector(signUpTapped),	for: .touchUpInside)
			questionToLogInButton	.addTarget	(self, action: #selector(pushLogInVC),	for: .touchUpInside)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		nicknameTextField	.text	= ""
		emailTextField		.text	= ""
		passwordTextField	.text	= ""
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor			= .white
		viewModel 						= RegistrationVM()
        dbReference						= Database.database().reference(withPath: "users")
		setUpLayout()
		setingUpKeyboardHiding()
		let tap : UITapGestureRecognizer	= UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
		view.addGestureRecognizer(tap)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self,	name: UIResponder.keyboardWillShowNotification,			object: nil)
        NotificationCenter.default.removeObserver(self,	name: UIResponder.keyboardWillHideNotification,			object: nil)
        NotificationCenter.default.removeObserver(self,	name: UIResponder.keyboardWillChangeFrameNotification,	object: nil)
	}
}

// MARK: Keyboard Issues
extension SignUpVC: UITextFieldDelegate {
    
    func setingUpKeyboardHiding(){
		nicknameTextField	.delegate = self
        emailTextField		.delegate = self
        passwordTextField	.delegate = self
		
        NotificationCenter.default.addObserver(self,	selector: #selector(keyboardWillChange(notification: )),	name: UIResponder.keyboardWillShowNotification,			object: nil)
        NotificationCenter.default.addObserver(self,	selector: #selector(keyboardWillChange(notification: )),	name: UIResponder.keyboardWillHideNotification,			object: nil)
        NotificationCenter.default.addObserver(self,	selector: #selector(keyboardWillChange(notification: )),	name: UIResponder.keyboardWillChangeFrameNotification,	object: nil)
    }
    
    func hideKeyboard(){
		nicknameTextField	.resignFirstResponder()
        emailTextField		.resignFirstResponder()
        passwordTextField	.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {		
		if 			textField == nicknameTextField {
			emailTextField		.becomeFirstResponder()
		} else if 	textField == emailTextField {
			passwordTextField	.becomeFirstResponder()
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

//MARK: Creating User
extension SignUpVC {
	
	@objc
	func signUpTapped() {
		let error = validateFields()
		if error != nil { setErrorDesign(error!) } else {
			//Create cleaned versions of the data
			guard let nickname	= nicknameTextField	.text?.trimmingCharacters(in: .whitespacesAndNewlines)	else { return }
			guard let email		= emailTextField	.text?.trimmingCharacters(in: .whitespacesAndNewlines)	else { return }
			guard let password	= passwordTextField	.text?.trimmingCharacters(in: .whitespacesAndNewlines)	else { return }

			Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, err) in
				if let error = err as NSError? {
					switch AuthErrorCode(rawValue: error.code) {
					case .operationNotAllowed	:
						self?.setErrorDesign("The operation is disabled right now. Try again later")
					case .emailAlreadyInUse		:
						self?.setErrorDesign("The email address is already in use by another account.")
					case .invalidEmail			:
						self?.setErrorDesign("The email address is badly formatted")
					case .weakPassword			:
						self?.setErrorDesign("The password must be 6 characters long or more")
					default						:
						self?.setErrorDesign(error.localizedDescription)
					}
				} else {
					guard let userRef = self?.dbReference.child((user?.user.uid)!) else { return }
					userRef.setValue(["email"	: user!.user.email,
									  "nickname": nickname])
					let project = MProject(userID: "123", name: "knitting-f824f", image: "_0", date: "0")
					guard let referenceForProject = self?.dbReference.child((user?.user.uid)!).child("projects").child("123") else { return }
					referenceForProject.setValue(project.projectToDictionary())
					self?.dismissKeyBoard	()
					self?.hideKeyboard()
					self?.pushMainVC()
					UserDefaults.standard.setValue(email,    forKey: "UserEmail")
					UserDefaults.standard.setValue(nickname, forKey: "UserName")
					AnalyticsService.reportEvent(with: "SignedUp")
				}
			}
		}
	}
}

//MARK: Error Handling
extension SignUpVC {
	
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

//MARK: Navigation
extension SignUpVC {
	
	@objc
	func pushLogInVC() {
		let vc = LogInVC()
		guard let navigationController = navigationController else { return }
		navigationController.pushViewController(vc, animated: true)
	}
	
	func pushMainVC() {
		let vc = NewMainController()
		guard let navigationController = navigationController else { return }
		navigationController.pushViewController(vc, animated: true)
	}
}

//MARK: Layout
extension SignUpVC {
	
	func setUpLayout() {
		//Navigation Bar scould be invisible
		self.navigationItem.setHidesBackButton(true, animated: true)
		
        //A place of view, where the image is
		let imageContainer = UIView()
		view.addSubview(imageContainer)
		imageContainer.translatesAutoresizingMaskIntoConstraints													= false
		imageContainer.leadingAnchor	.constraint(equalTo: view.leadingAnchor)						.isActive	= true
        imageContainer.trailingAnchor	.constraint(equalTo: view.trailingAnchor)						.isActive	= true
        imageContainer.topAnchor		.constraint(equalTo: view.topAnchor)							.isActive	= true
        imageContainer.heightAnchor		.constraint(equalTo: view.heightAnchor, multiplier: 0.3)		.isActive	= true
		
        //Image or Gif constraints in a cell
        imageContainer.addSubview(logoIcon)
        logoIcon.translatesAutoresizingMaskIntoConstraints															= false
        logoIcon.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor)			.isActive	= true
        logoIcon.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor, constant: 10)			.isActive	= true
		logoIcon.heightAnchor.constraint(lessThanOrEqualToConstant: 154.89)								.isActive	= true
		logoIcon.widthAnchor.constraint(lessThanOrEqualToConstant: 129.39)								.isActive	= true
		
		//A place for title
		view.addSubview(createAccount)
		createAccount.translatesAutoresizingMaskIntoConstraints														= false
		createAccount.topAnchor			.constraint(equalTo: imageContainer.bottomAnchor)				.isActive	= true
		createAccount.leadingAnchor		.constraint(equalTo: view.leadingAnchor, constant: 16)			.isActive	= true
		createAccount.trailingAnchor	.constraint(equalTo: view.trailingAnchor, constant: -16)		.isActive	= true
		createAccount.heightAnchor		.constraint(equalToConstant: 33)								.isActive	= true
		
		//A palce for nickname TextField
		view.addSubview(nicknameTextField)
		nicknameTextField.translatesAutoresizingMaskIntoConstraints													= false
		nicknameTextField.topAnchor		.constraint(equalTo: createAccount.bottomAnchor, constant: 20)	.isActive	= true
		nicknameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)		.isActive	= true
		nicknameTextField.leadingAnchor	.constraint(equalTo: view.leadingAnchor, constant: 16)			.isActive	= true
		nicknameTextField.heightAnchor	.constraint(equalToConstant: 51)								.isActive 	= true
		
		//A palce for email TextField
		view.addSubview(emailTextField)
		emailTextField.translatesAutoresizingMaskIntoConstraints													= false
		emailTextField.topAnchor		.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 20).isActive	= true
		emailTextField.trailingAnchor	.constraint(equalTo: view.trailingAnchor, constant: -16)		.isActive	= true
		emailTextField.leadingAnchor	.constraint(equalTo: view.leadingAnchor, constant: 16)			.isActive	= true
		emailTextField.heightAnchor		.constraint(equalToConstant: 51)								.isActive 	= true
		
		//A palce for password TextField
		view.addSubview(passwordTextField)
		passwordTextField.translatesAutoresizingMaskIntoConstraints													= false
		passwordTextField.topAnchor		.constraint(equalTo: emailTextField.bottomAnchor, constant: 20)	.isActive	= true
		passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)		.isActive	= true
		passwordTextField.leadingAnchor	.constraint(equalTo: view.leadingAnchor, constant: 16)			.isActive	= true
		passwordTextField.heightAnchor	.constraint(equalToConstant: 51)								.isActive 	= true
		
		//A palce for warning label
		view.addSubview(warning)
		warning.isHidden																							= true
		warning.translatesAutoresizingMaskIntoConstraints															= false
		warning.leadingAnchor			.constraint(equalTo: view.leadingAnchor, constant: 16)			.isActive	= true
		warning.topAnchor				.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8).isActive	= true
		warning.heightAnchor			.constraint(greaterThanOrEqualToConstant: 17)					.isActive	= true
		warning.trailingAnchor			.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16).isActive	= true
		
		//A place for question Label And Question Button
		let bottomLicensSV			= UIStackView(arrangedSubviews: [questionToLogInLabel, questionToLogInButton])
		bottomLicensSV.distribution = .fill

        view.addSubview(bottomLicensSV)
        bottomLicensSV.translatesAutoresizingMaskIntoConstraints													= false
		bottomLicensSV.bottomAnchor		.constraint(equalTo: view.bottomAnchor, constant: -40)			.isActive	= true
		bottomLicensSV.centerXAnchor	.constraint(equalTo: view.centerXAnchor)						.isActive	= true
		bottomLicensSV.heightAnchor		.constraint(equalToConstant: 20)								.isActive	= true
		
		//A place for registration buttom
		view.addSubview(signUpButton)
		signUpButton.translatesAutoresizingMaskIntoConstraints														= false
		signUpButton.centerXAnchor		.constraint(equalTo: view.centerXAnchor)						.isActive	= true
		signUpButton.trailingAnchor		.constraint(equalTo: view.trailingAnchor, constant: -16)		.isActive	= true
		signUpButton.bottomAnchor		.constraint(equalTo: bottomLicensSV.topAnchor, constant: -20)	.isActive	= true
		signUpButton.heightAnchor		.constraint(equalToConstant: 53)								.isActive	= true
		
		//Button alignment
		questionToLogInButton.translatesAutoresizingMaskIntoConstraints													= false
		questionToLogInButton.widthAnchor.constraint(lessThanOrEqualToConstant: 100).isActive							= true
		questionToLogInButton.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: 50).isActive	= true
	}
}
