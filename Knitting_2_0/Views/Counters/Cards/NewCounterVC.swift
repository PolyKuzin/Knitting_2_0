//
//  NewCounterVC.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 05.10.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

import UIKit
import FirebaseAuth
import FirebaseDatabase

class NewCounterVC					: UIViewController, CardViewControllerProtocol, UINavigationControllerDelegate {
	
	var handle: UIView! 			= UIView()
	var currentProject : MProject!
	
	private var user           		: MUser!
	private var ref             	: DatabaseReference!

	private var imageIsChanged 		: Bool = false
	
	private var addCounter			: Bool = false

	private var createLabel			= UILabel()
	private var countersName			= UITextField()
	private var createGlobalCounterLabel = UILabel()
	private var globalCounterSwitch = UISwitch()

	private var createButton		= UIButton()
	private var warning				= UILabel()

	private var viewModel			: NewProjectCardVM! {
		didSet {
			self.createLabel		= viewModel.createLabel()
			self.countersName		= viewModel.projectName()
			self.createButton		= viewModel.createButton()

			self.globalCounterSwitch = viewModel.globarCounterSwitch()
			self.createGlobalCounterLabel = viewModel.createGlobalCounterLabel()
			
			globalCounterSwitch.addTarget(self, action: #selector(didChangeGlobalCounterSwitch), for: .valueChanged)
			createButton.addTarget(self, action: #selector(saveCounter), for: .touchUpInside)
		}
	}
	
	@objc
	func didChangeGlobalCounterSwitch() {
			addCounter = !addCounter
	}
	
	@objc
	func saveCounter() {
		let error = validateFields()
		if error != nil {  setErrorDesign(error!) } else {
			
			let date = Int(Date().timeIntervalSince1970)
			guard let name		= countersName.text	else { return }
			var rowsMax = -1
			if addCounter {
				rowsMax = 123
			}
			
			let counter = MCounter(name: name, rows: 0, rowsMax: rowsMax, date: "\(date)")
			ref.child("\(date)").setValue(counter.counterToDictionary())
			NotificationCenter.default.post(name: Notification.Name(rawValue: "disconnectNewCounterVC"), object: nil)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel = NewProjectCardVM()
		setupNewProjectView()
		
		guard let currentUser = Auth.auth().currentUser else { return }
		user	= MUser(user: currentUser)
		ref		= currentProject.ref?.child("counters")
		
		setingUpKeyboardHiding()
		let tap : UITapGestureRecognizer	= UITapGestureRecognizer(target: self, action: #selector(hideKeyboardWhenTapped))
		view.addGestureRecognizer(tap)
	}
}

//MARK: Error Handling
extension NewCounterVC {
	
	func validateFields() -> String? {
		
		//check that fields are filled in
		if	countersName	.text?.trimmingCharacters	(in: .whitespacesAndNewlines)	== "" {
			return "Please fill in all fields"
		}
		return nil
	}
		
	func showError(_ message: String) {
		warning.textColor	= Colors.errorTextFieldBorder
		warning.text		= message
		warning.alpha		= 1
		warning.isHidden	= false
	}
	
	func setErrorDesign(_ description: String) {
		showError(description)
		countersName.backgroundColor      = Colors.errorTextField
		countersName.layer.borderColor    = Colors.errorTextFieldBorder.cgColor
		countersName.shakeAnimation		()
		createLabel.shakeAnimation		()
		createButton.shakeAnimation		()
	}
}


// MARK: Keyboard Issues
extension NewCounterVC: UITextFieldDelegate {
	
	func setingUpKeyboardHiding(){
		countersName		.delegate = self
		
		NotificationCenter.default.addObserver(self,	selector: #selector(keyboardWillChange(notification: )),	name: UIResponder.keyboardWillShowNotification,			object: nil)
		NotificationCenter.default.addObserver(self,	selector: #selector(keyboardWillChange(notification: )),	name: UIResponder.keyboardWillHideNotification,			object: nil)
		NotificationCenter.default.addObserver(self,	selector: #selector(keyboardWillChange(notification: )),	name: UIResponder.keyboardWillChangeFrameNotification,	object: nil)
	}
	
	@objc
	func hideKeyboardWhenTapped() {
		hideKeyboard()
	}
	func hideKeyboard(){
		countersName		.resignFirstResponder()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		countersName		.resignFirstResponder()
		NotificationCenter.default.post(name: UIResponder.keyboardDidHideNotification, object: nil)
		return true
	}
	
	@objc
	func keyboardWillChange(notification: Notification){
		guard let userInfo = notification.userInfo else {return}
			  let keyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		
		if notification.name == UIResponder.keyboardWillShowNotification ||
		   notification.name == UIResponder.keyboardWillChangeFrameNotification {
			self.view.frame.origin.y -= keyboardRect.height - 200
		} else {
			self.view.frame.origin.y =  keyboardReturnDistance
		}
	}
}

//MARK: Layout
extension NewCounterVC {
	
	func setupNewProjectView() {
		view.backgroundColor	= .white

		view.addSubview(handle)
		handle.translatesAutoresizingMaskIntoConstraints											= false
		handle.topAnchor.constraint(equalTo: view.topAnchor).isActive								= true
		handle.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive						= true
		handle.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive						= true
		handle.heightAnchor.constraint(equalToConstant: 100).isActive								= true
		
		view.addSubview(createLabel)
		createLabel.translatesAutoresizingMaskIntoConstraints										= false
		createLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive			= true
		createLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive					= true
		createLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive	= true
		
		view.addSubview(countersName)
		countersName.translatesAutoresizingMaskIntoConstraints										= false
		countersName.topAnchor.constraint(equalTo: createLabel.bottomAnchor, constant: 20).isActive = true
		countersName.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive					= true
		countersName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive	= true
		countersName.heightAnchor.constraint(equalToConstant: 44).isActive							= true
		
		view.addSubview(warning)
		warning.translatesAutoresizingMaskIntoConstraints											= false
		warning.topAnchor.constraint(equalTo: countersName.bottomAnchor, constant: 7).isActive		= true
		warning.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive		= true
		warning.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive		= true
		
		view.addSubview(globalCounterSwitch)
		globalCounterSwitch.translatesAutoresizingMaskIntoConstraints								= false
		globalCounterSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
		globalCounterSwitch.topAnchor.constraint(equalTo: countersName.bottomAnchor, constant: 35).isActive = true
		
		view.addSubview(createGlobalCounterLabel)
		createGlobalCounterLabel.translatesAutoresizingMaskIntoConstraints							= false
		createGlobalCounterLabel.topAnchor.constraint(equalTo: countersName.bottomAnchor, constant: 39).isActive = true
		createGlobalCounterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
		createGlobalCounterLabel.trailingAnchor.constraint(equalTo: globalCounterSwitch.leadingAnchor, constant: 10).isActive = true
		
		view.addSubview(createButton)
		createButton.translatesAutoresizingMaskIntoConstraints										= false
		createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive					= true
		createButton.topAnchor.constraint(equalTo: countersName.bottomAnchor, constant: 135).isActive		= true
		createButton.widthAnchor.constraint(equalToConstant: 155).isActive							= true
		createButton.heightAnchor.constraint(equalToConstant: 50).isActive							= true
	}
}

