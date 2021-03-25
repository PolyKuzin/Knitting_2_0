//
//  NewCounterVC.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 05.10.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit

import UIKit
import PanModal
import FirebaseAuth
import FirebaseDatabase

class NewCounterVC					: UIViewController, CardViewControllerProtocol, UINavigationControllerDelegate, PanModalPresentable {
	
	var panScrollable: UIScrollView? {
		return nil
	}
	
	var longFormHeight: PanModalHeight {
		return .maxHeight
	}
	
	var editCounter 				: Bool = false
	var handle: UIView! 			= UIView()
	var currentProject : MProject!
	
	private var user           		: MUser!
	private var ref             	: DatabaseReference!

	private var imageIsChanged 		: Bool = false
	
	private var addCounter			: Bool = false

	private var createLabel			= UILabel()
	private var counterName		= UITextField()
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
			self.counterName			= viewModel.projectName()
			self.createButton			= viewModel.createButton()
			self.globalCounterSwitch	= viewModel.globarCounterSwitch()
			self.setRowsMaxLabel 		= viewModel.createGlobalCounterLabel()
			self.rowsMaxTF				= viewModel.setRowsMaxTF()
			self .plusButton			= viewModel.plus()
			self.minusButton			= viewModel.minus()
			
			globalCounterSwitch.addTarget(self, action: #selector(didChangeGlobalCounterSwitch), for: .valueChanged)
			createButton.addTarget(self, action: #selector(saveCounter), for: .touchUpInside)
			
			plusButton.addTarget(self, action: #selector(addNumberToTextField), for: .touchUpInside)
			minusButton.addTarget(self, action: #selector(removeNumberFromTextField), for: .touchUpInside)
		}
	}
	
	@objc
	func addNumberToTextField() {
		if !rowsMaxTF.text!.isEmpty{
			var number = Int(rowsMaxTF.text!)!
			number += 1
			rowsMaxTF.text = String(number)
		} else {
			rowsMaxTF.text = "1"
		}
	}
	
	@objc
	func removeNumberFromTextField() {
		if Int(rowsMaxTF.text!)! != 0 {
			var number = Int(rowsMaxTF.text!)!
			number -= 1
			rowsMaxTF.text = String(number)
		}
	}
	
	@objc
	func didChangeGlobalCounterSwitch() {
		addCounter = !addCounter
		if addCounter {
			plusButton.isEnabled  = true
			minusButton.isEnabled = true
			rowsMaxTF.isEnabled   = true
		} else {
			plusButton.isEnabled  = false
			minusButton.isEnabled = false
			rowsMaxTF.isEnabled   = false
		}
	}
	
	@objc
	func saveCounter() {
		let error = validateFields()
		if error != nil {  setErrorDesign(error!) } else {
			
			let date = Int(Date().timeIntervalSince1970)
			guard let name		= counterName.text	else { return }
			if addCounter {
				rowsMax = validateRowsMax()
			}
			
			let counter = MCounter(name: name, rows: 0, rowsMax: rowsMax, date: "\(date)")
			ref.child("\(date)").setValue(counter.counterToDictionary())
			AnalyticsService.reportEvent(with: "New counter", parameters: ["name" : counter.name])
			self.dismiss(animated: true, completion: nil)
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
		self.title = "Create new counter".localized()
		guard let currentUser = Auth.auth().currentUser else { return }
		user	= MUser(user: currentUser)
		ref		= currentProject.ref?.child("counters")
		setingUpKeyboardHiding()
		let tap : UITapGestureRecognizer	= UITapGestureRecognizer(target: self, action: #selector(hideKeyboardWhenTapped))
		view.addGestureRecognizer(tap)
		counterName.becomeFirstResponder()
	}
}

//MARK: Error Handling
extension NewCounterVC {
	
	func validateFields() -> String? {
		//check that fields are filled in
		if	counterName	.text?.trimmingCharacters	(in: .whitespacesAndNewlines)	== "" {
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
		counterName.backgroundColor      = Colors.errorTextField
		counterName.layer.borderColor    = Colors.errorTextFieldBorder.cgColor
		counterName.shakeAnimation		()
		createLabel.shakeAnimation		()
		createButton.shakeAnimation		()
	}
}


// MARK: Keyboard Issues
extension NewCounterVC: UITextFieldDelegate {
	
	func setingUpKeyboardHiding(){
		counterName.delegate = self
		let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardWhenTapped))
		tap.numberOfTapsRequired = 1
		self.view.addGestureRecognizer(tap)
	}
	
	@objc
	func hideKeyboardWhenTapped() {
		counterName.resignFirstResponder()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		counterName.resignFirstResponder()
		return true
	}
}

//MARK: Layout
extension NewCounterVC {
	
	func setupNewProjectView() {
		view.backgroundColor	= .white

		view.addSubview(counterName)
		counterName.translatesAutoresizingMaskIntoConstraints										= false
		counterName.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
		counterName.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive					= true
		counterName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive	= true
		counterName.heightAnchor.constraint(equalToConstant: 44).isActive							= true
		
		view.addSubview(warning)
		warning.translatesAutoresizingMaskIntoConstraints											= false
		warning.topAnchor.constraint(equalTo: counterName.bottomAnchor, constant: 7).isActive		= true
		warning.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive		= true
		warning.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive		= true
		
		view.addSubview(globalCounterSwitch)
		globalCounterSwitch.translatesAutoresizingMaskIntoConstraints								= false
		globalCounterSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
		globalCounterSwitch.topAnchor.constraint(equalTo: counterName.bottomAnchor, constant: 35).isActive = true
		
		view.addSubview(setRowsMaxLabel)
		setRowsMaxLabel.translatesAutoresizingMaskIntoConstraints							= false
		setRowsMaxLabel.topAnchor.constraint(equalTo: counterName.bottomAnchor, constant: 39).isActive = true
		setRowsMaxLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
		setRowsMaxLabel.trailingAnchor.constraint(equalTo: globalCounterSwitch.leadingAnchor, constant: 10).isActive = true
		
		view.addSubview(rowsMaxTF)
		rowsMaxTF.translatesAutoresizingMaskIntoConstraints = false
		rowsMaxTF.topAnchor.constraint(equalTo: setRowsMaxLabel.bottomAnchor, constant: 20).isActive		= true
		rowsMaxTF.centerXAnchor.constraint(equalTo: counterName.centerXAnchor).isActive = true
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
		createButton.trailingAnchor .constraint(equalTo: view.trailingAnchor,   constant:  -16).isActive							= true
		createButton.heightAnchor.constraint(equalToConstant: 50).isActive							= true
	}
}

