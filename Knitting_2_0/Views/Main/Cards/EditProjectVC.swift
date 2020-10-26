//
//  EditProjectVC.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 07.10.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class EditProjectVC					: UIViewController, CardViewControllerProtocol, UINavigationControllerDelegate {
	
	var handle: UIView! 			= UIView()
	
	private var user           		: MUser!
	private var ref             	: DatabaseReference!
	
	var currentProject				: MProject?

	private var imageIsChanged 		: Bool = false
	private var addCounter			: Bool = false

	private var createLabel			= UILabel()
	private var projectImage		= UIImageView()
	private var projectName			= UITextField()

	private var createButton		= UIButton()
	private var warning				= UILabel()

	private var viewModel			: EditProjectCardVM! {
		didSet {
			self.createLabel		= viewModel.createLabel()
			self.projectImage		= viewModel.profileImage()
			self.projectName		= viewModel.projectName()
			self.createButton		= viewModel.createButton()
			
			let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.projectImageTapped(recognizer:)))
			singleTap.numberOfTapsRequired = 1
			self.projectImage.addGestureRecognizer(singleTap)
			
			createButton.addTarget(self, action: #selector(saveCounter), for: .touchUpInside)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel = EditProjectCardVM()
		setupNewProjectView()
		
		guard let currentUser = Auth.auth().currentUser else { return }
		user	= MUser(user: currentUser)
		ref		= Database.database().reference(withPath: "users").child(String(user.uid))
		
		setingUpKeyboardHiding()
		let tap : UITapGestureRecognizer	= UITapGestureRecognizer(target: self, action: #selector(hideKeyboardWhenTapped))
		view.addGestureRecognizer(tap)
		
		
		projectImage.image = currentProject?.image.toImage()
		projectImage.layer.cornerRadius = 20
		projectImage.layer.masksToBounds = true
		projectName.text	= currentProject?.name
	}
	
	@objc
	func didChangeGlobalCounterSwitch() {
			addCounter = !addCounter
	}
	
	@objc
	func saveCounter() {
		let error = validateFields()
		if error != nil {  setErrorDesign(error!) } else {
			var image: UIImage?
			if imageIsChanged {
				image = projectImage.image
			} else {
				image = #imageLiteral(resourceName: "empty")
			}
			let projectUniqueID = String(Int(Date().timeIntervalSince1970))
			guard let imageData = image?.toString() else { return }
			guard let name		= projectName.text	else { return }
			
			let referenceForProject = self.currentProject?.ref
			referenceForProject?.updateChildValues(["name" : name,
												   "image" : imageData,
												   "date": projectUniqueID])

			NotificationCenter.default.post(name: Notification.Name(rawValue: "disconnectEditProjectVC"), object: nil)
		}
	}
	
	@objc
	func projectImageTapped(recognizer: UIGestureRecognizer) {
		let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//		let camera = UIAlertAction(title: "Camera", style: .default) { _ in
//			self.chooesImagePicker(sourse: .camera)
//		}
		let photo = UIAlertAction(title: "Library", style: .default) { _ in
			self.chooesImagePicker(sourse: .photoLibrary)
		}
		let cancel = UIAlertAction(title: "Cancel", style: .cancel)
//		actionSheet.addAction(camera)
		actionSheet.addAction(photo)
		actionSheet.addAction(cancel)
		present(actionSheet, animated: true)
	}
}

//MARK: Work with IMAGE
extension EditProjectVC: UIImagePickerControllerDelegate {
	
	func chooesImagePicker (sourse: UIImagePickerController.SourceType){
		if UIImagePickerController.isSourceTypeAvailable(sourse) {
			let imagePicker				= UIImagePickerController()
			imagePicker.delegate		= self
			imagePicker.allowsEditing 	= true
			imagePicker.sourceType		= sourse
			present(imagePicker, animated: true)
		}
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		projectImage.image 				= info[.editedImage] as? UIImage
		projectImage.contentMode 		= .scaleAspectFill
		projectImage.clipsToBounds 		= true
		imageIsChanged 					= true
		dismiss(animated: true)
	}
}

//MARK: Error Handling
extension EditProjectVC {
	
	func validateFields() -> String? {
		
		//check that fields are filled in
		if	projectName	.text?.trimmingCharacters	(in: .whitespacesAndNewlines)	== "" {
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
		projectName.backgroundColor      = Colors.errorTextField
		projectName.layer.borderColor    = Colors.errorTextFieldBorder.cgColor
		projectName.shakeAnimation		()
		createLabel.shakeAnimation		()
		createButton.shakeAnimation		()
	}
}


// MARK: Keyboard Issues
extension EditProjectVC: UITextFieldDelegate {
	
	func setingUpKeyboardHiding(){
		projectName		.delegate = self
		
		NotificationCenter.default.addObserver(self,	selector: #selector(keyboardWillChange(notification: )),	name: UIResponder.keyboardWillShowNotification,			object: nil)
		NotificationCenter.default.addObserver(self,	selector: #selector(keyboardWillChange(notification: )),	name: UIResponder.keyboardWillHideNotification,			object: nil)
		NotificationCenter.default.addObserver(self,	selector: #selector(keyboardWillChange(notification: )),	name: UIResponder.keyboardWillChangeFrameNotification,	object: nil)
	}
	
	@objc
	func hideKeyboardWhenTapped() {
		hideKeyboard()
	}
	func hideKeyboard(){
		projectName		.resignFirstResponder()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		projectName		.resignFirstResponder()
		NotificationCenter.default.post(name: UIResponder.keyboardDidHideNotification, object: nil)
		return true
	}
	
	@objc
	func keyboardWillChange(notification: Notification){
		guard let userInfo = notification.userInfo else {return}
			  let keyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

		if notification.name == UIResponder.keyboardWillShowNotification ||
		   notification.name == UIResponder.keyboardWillChangeFrameNotification {
			view.frame.origin.y = keyboardRect.height - 150
		} else {
			view.frame.origin.y += keyboardRect.height + keyboardBlackArea
		}
	}
}

//MARK: Layout
extension EditProjectVC {
	
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
		
		view.addSubview(projectImage)
		projectImage.translatesAutoresizingMaskIntoConstraints										= false
		projectImage.heightAnchor.constraint(equalToConstant: 125).isActive							= true
		projectImage.widthAnchor.constraint(equalToConstant: 125).isActive							= true
		projectImage.topAnchor.constraint(equalTo: createLabel.bottomAnchor, constant: 20).isActive	= true
		projectImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive					= true
		
		view.addSubview(projectName)
		projectName.translatesAutoresizingMaskIntoConstraints										= false
		projectName.topAnchor.constraint(equalTo: projectImage.bottomAnchor, constant: 20).isActive = true
		projectName.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive					= true
		projectName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive	= true
		projectName.heightAnchor.constraint(equalToConstant: 44).isActive							= true
		
		view.addSubview(warning)
		warning.translatesAutoresizingMaskIntoConstraints											= false
		warning.topAnchor.constraint(equalTo: projectName.bottomAnchor, constant: 7).isActive		= true
		warning.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive		= true
		warning.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive		= true
		
		view.addSubview(createButton)
		createButton.translatesAutoresizingMaskIntoConstraints										= false
		createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive					= true
		createButton.topAnchor.constraint(equalTo: projectName.bottomAnchor, constant: 20).isActive		= true
		createButton.widthAnchor.constraint(equalToConstant: 155).isActive							= true
		createButton.heightAnchor.constraint(equalToConstant: 50).isActive							= true
	}
}


