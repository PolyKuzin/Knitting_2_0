//
//  EditProjectVC.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 07.10.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit
import PanModal
import FirebaseAuth
import FirebaseDatabase

class EditProjectVC					: UIViewController, CardViewControllerProtocol, UINavigationControllerDelegate, PanModalPresentable {
	
	var panScrollable: UIScrollView? {
		return nil
	}
	
//	var shortFormHeight: PanModalHeight {
//		return .contentHeight(200) // TODO: (350)
//	}
	
	var longFormHeight: PanModalHeight {
		return .maxHeight // shortFormHeight // .maxHeightWithTopInset(70)
	}
	
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
		self.title = "Edit project".localized()

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
		projectName.becomeFirstResponder()
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
			AnalyticsService.reportEvent(with: "Edit Project")
			self.dismiss(animated: true, completion: nil)
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
		projectName.delegate = self
		let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardWhenTapped))
		tap.numberOfTapsRequired = 1
		self.view.addGestureRecognizer(tap)
	}
	
	@objc
	func hideKeyboardWhenTapped() {
		projectName.resignFirstResponder()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		projectName.resignFirstResponder()
		return true
	}
}

//MARK: Layout
extension EditProjectVC {
	
	func setupNewProjectView() {
		view.backgroundColor	= .white

		view.addSubview(projectImage)
		projectImage.translatesAutoresizingMaskIntoConstraints										= false
		projectImage.heightAnchor.constraint(equalToConstant: 125).isActive							= true
		projectImage.widthAnchor.constraint(equalToConstant: 125).isActive							= true
		projectImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive	= true
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
		createButton.trailingAnchor .constraint(equalTo: view.trailingAnchor,   constant:  -16).isActive							= true
		createButton.heightAnchor.constraint(equalToConstant: 50).isActive							= true
	}
}


