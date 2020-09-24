//
//  ForgotPassVC.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 12.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPassVC				: UIViewController {

	private var logoIcon		= UIImageView()
	private var resetPass		= UILabel()
	private var emailTextField	= UITextField()
	private var infoLabel		= UILabel()
	private var resetBtn		= UIButton()
	
	private var viewModel	: ForgotPassVM! {
		didSet {
			self.logoIcon		= viewModel.logo	()
			self.resetPass		= viewModel.resetPassLabel()
			self.emailTextField	= viewModel.email	()
			self.infoLabel		= viewModel.info	()
			self.resetBtn		= viewModel.reset	()
			resetBtn.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white
		viewModel = ForgotPassVM()
		setUpLayout()
		setingUpKeyboardHiding()
		let tap : UITapGestureRecognizer	= UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
		view.addGestureRecognizer(tap)
	}
}

//MARK: Error handling
extension ForgotPassVC {
	
    func validateFields() -> String? {
        //check that fields are filled in
        if	emailTextField.text?.trimmingCharacters	(in: .whitespacesAndNewlines)	== "" {
            return "Please fill in all field"
        }
		return nil
	}
		
	func showError(_ message: String) {
		emailTextField.shakeAnimation	()
		resetBtn.shakeAnimation			()
		infoLabel.text		= message
		infoLabel.alpha		= 1
		infoLabel.textColor = Colors.errorTextFieldBorder
	}
	
	func setErrorDesign(_ description: String) {
		emailTextField.backgroundColor         = Colors.errorTextField
		emailTextField.layer.borderColor       = Colors.errorTextFieldBorder.cgColor
		emailTextField.textColor               = Colors.errorTextFieldBorder
		showError(description)
		emailTextField.shakeAnimation()
		}
}

extension ForgotPassVC {
	
	@objc
	func resetPassword() {
		guard let email = emailTextField.text else {
			return
		}
		Auth.auth().sendPasswordReset(withEmail: email) { err in
			if err != nil {
			// Display error message
				if let error = err as NSError? {
					switch (AuthErrorCode(rawValue: error.code)) {
					case .userNotFound:
						self.setErrorDesign("No account exists with this email address.")
						return
					default:
						self.setErrorDesign(error.localizedDescription)
						return
					}
				}
			} else {
				let alert = UIAlertController(title: "Don't worry:", message: "A form for password recovery has been send to your email address.", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
					self.pushLoginVC()
				}))
				self.dismissKeyBoard()
				self.present(alert, animated: true)
			}
		}
	}
}

//MARK: Navigation
extension ForgotPassVC {
	
	func pushLoginVC() {
		let vc = LogInVC()
		guard let navigationController = self.navigationController else { return }
		navigationController.pushViewController(vc, animated: true)
	}
}

// MARK: Keyboard Issues
extension ForgotPassVC: UITextFieldDelegate {
    
    func setingUpKeyboardHiding(){
        emailTextField		.delegate = self
		
        NotificationCenter.default.addObserver(self,	selector: #selector(keyboardWillChange(notification: )),	name: UIResponder.keyboardWillShowNotification,			object: nil)
        NotificationCenter.default.addObserver(self,	selector: #selector(keyboardWillChange(notification: )),	name: UIResponder.keyboardWillHideNotification,			object: nil)
        NotificationCenter.default.addObserver(self,	selector: #selector(keyboardWillChange(notification: )),	name: UIResponder.keyboardWillChangeFrameNotification,	object: nil)
    }
    
    func hideKeyboard(){
        emailTextField		.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		hideKeyboard()
        return true
    }
    
    @objc
	func keyboardWillChange(notification: Notification){
        guard let userInfo = notification.userInfo else {return}
              let keyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        if notification.name == UIResponder.keyboardWillShowNotification ||
           notification.name == UIResponder.keyboardWillChangeFrameNotification {
			view.frame.origin.y = -keyboardRect.height + 110
        } else {
			view.frame.origin.y += keyboardRect.height - keyboardBlackArea
        }
    }
	
    @objc
    private func dismissKeyBoard() {
        hideKeyboard()
    }
}

//MARK: Layout
extension ForgotPassVC {

	func setUpLayout() {
		//Navigation Bar scould be visible with custom "Back" Button
		let backIcon = Icons.backIcon
		guard let navigationController = navigationController else { return }
		navigationController.navigationBar.backIndicatorImage														= backIcon
		navigationController.navigationBar.backIndicatorTransitionMaskImage											= backIcon
		navigationController.navigationBar.topItem?.title 															= ""
		navigationController.navigationBar.tintColor 																= Colors.backIcon
		
		//A place of view, where the image is
		let imageContainer = UIView()
		view.addSubview(imageContainer)
		imageContainer.translatesAutoresizingMaskIntoConstraints												= false
		imageContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive						= true
		imageContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive						= true
		imageContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive								= true
		imageContainer.heightAnchor	.constraint(equalTo: view.heightAnchor, multiplier: 0.35).isActive		= true
		
		//A place for title
		view.addSubview(resetPass)
		resetPass.translatesAutoresizingMaskIntoConstraints														= false
		resetPass.topAnchor			.constraint(equalTo: imageContainer.bottomAnchor)				.isActive	= true
		resetPass.leadingAnchor		.constraint(equalTo: view.leadingAnchor, constant: 16)			.isActive	= true
		resetPass.trailingAnchor	.constraint(equalTo: view.trailingAnchor, constant: -16)		.isActive	= true
		resetPass.heightAnchor		.constraint(equalToConstant: 33)								.isActive	= true
		
		//Image or Gif constraints in a cell
		imageContainer.addSubview(logoIcon)
		logoIcon.translatesAutoresizingMaskIntoConstraints															= false
		logoIcon.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor, constant: -10).isActive		= true
		logoIcon.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor, constant: 10).isActive		= true
		logoIcon.heightAnchor.constraint(lessThanOrEqualToConstant: 154.89).isActive								= true
		logoIcon.widthAnchor.constraint(lessThanOrEqualToConstant: 129.39).isActive									= true
		
		//A palce for email TextField
		view.addSubview(emailTextField)
		emailTextField.translatesAutoresizingMaskIntoConstraints													= false
		emailTextField.topAnchor.constraint(equalTo: resetPass.bottomAnchor, constant: 20).isActive		= true
		emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive				= true
		emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive					= true
		emailTextField.heightAnchor.constraint(equalToConstant: 51).isActive 										= true
		
		//A palce for info label
		view.addSubview(infoLabel)
		infoLabel.translatesAutoresizingMaskIntoConstraints															= false
		infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive						= true
		infoLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 8).isActive					= true
		infoLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 17).isActive								= true
		infoLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16).isActive			= true
		
		//A place for registration buttom
		view.addSubview(resetBtn)
		resetBtn.translatesAutoresizingMaskIntoConstraints															= false
		resetBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive										= true
		resetBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -120).isActive					= true
		resetBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -75).isActive						= true
		resetBtn.heightAnchor.constraint(equalToConstant: 50).isActive												= true
	}
}
