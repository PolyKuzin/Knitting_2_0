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
	
	var editCounter 				: Bool = false
	var handle: UIView! 			= UIView()
	var currentProject : MProject!
	
	private var user           		: MUser!
	private var ref             	: DatabaseReference!

	private var imageIsChanged 		: Bool = false
	
	private var addCounter			: Bool = false

	private var createLabel			= UILabel()
	private var countersName		= UITextField()
	private var setRowsMaxLabel = UILabel()
	private var globalCounterSwitch = UISwitch()

	private var createButton		= UIButton()
	private var warning				= UILabel()
	private var rowsMaxTF			= UITextField()
	private var plusButton			= UIButton()
	private var minusButton			= UIButton()
	
	var rowsMax = -1

	private var viewModel			: NewCounterCardVM! {
		didSet {
			self.createLabel			= viewModel.createLabel()
			self.countersName			= viewModel.projectName()
			self.createButton			= viewModel.createButton()
			self.globalCounterSwitch	= viewModel.globarCounterSwitch()
			self.setRowsMaxLabel 		= viewModel.createGlobalCounterLabel()
			self.rowsMaxTF				= viewModel.setRowsMaxTF()
			self .plusButton			= viewModel.plus()
			self.minusButton			= viewModel.minus()
			
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
			if addCounter {
				rowsMax = validateRowsMax()
			}
			
			let counter = MCounter(name: name, rows: 0, rowsMax: rowsMax, date: "\(date)")
			ref.child("\(date)").setValue(counter.counterToDictionary())
			NotificationCenter.default.post(name: Notification.Name(rawValue: "disconnectNewCounterVC"), object: nil)
		}
	}
	
	func validateRowsMax() -> Int {
		if	rowsMaxTF.text?.trimmingCharacters	(in: .whitespacesAndNewlines)	== "" {
			return -1
		} else {
			return Int(rowsMaxTF.text!) ?? -1
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel = NewCounterCardVM()
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
			self.view.frame.origin.y =  keyboardReturnDistance + 150
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
		
		view.addSubview(setRowsMaxLabel)
		setRowsMaxLabel.translatesAutoresizingMaskIntoConstraints							= false
		setRowsMaxLabel.topAnchor.constraint(equalTo: countersName.bottomAnchor, constant: 39).isActive = true
		setRowsMaxLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
		setRowsMaxLabel.trailingAnchor.constraint(equalTo: globalCounterSwitch.leadingAnchor, constant: 10).isActive = true
		
		view.addSubview(rowsMaxTF)
		rowsMaxTF.translatesAutoresizingMaskIntoConstraints = false
		rowsMaxTF.topAnchor.constraint(equalTo: setRowsMaxLabel.bottomAnchor, constant: 20).isActive		= true
		rowsMaxTF.centerXAnchor.constraint(equalTo: countersName.centerXAnchor).isActive = true
		rowsMaxTF.widthAnchor.constraint(equalToConstant: 100).isActive = true
		rowsMaxTF.heightAnchor.constraint(equalToConstant: 50).isActive = true
		
		view.addSubview(plusButton)
		plusButton.translatesAutoresizingMaskIntoConstraints = false
		plusButton.centerYAnchor.constraint(equalTo: rowsMaxTF.centerYAnchor).isActive = true
		plusButton.leadingAnchor.constraint(equalTo: rowsMaxTF.trailingAnchor, constant: 15).isActive = true
		plusButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
		plusButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
		
		view.addSubview(minusButton)
		minusButton.translatesAutoresizingMaskIntoConstraints = false
		minusButton.centerYAnchor.constraint(equalTo: rowsMaxTF.centerYAnchor).isActive = true
		minusButton.trailingAnchor.constraint(equalTo: rowsMaxTF.leadingAnchor, constant: -15).isActive = true
		minusButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
		minusButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
		
		view.addSubview(createButton)
		createButton.translatesAutoresizingMaskIntoConstraints										= false
		createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive					= true
		createButton.topAnchor.constraint(equalTo: rowsMaxTF.bottomAnchor, constant: 20).isActive		= true
		createButton.widthAnchor.constraint(equalToConstant: 155).isActive							= true
		createButton.heightAnchor.constraint(equalToConstant: 50).isActive							= true
	}
}

