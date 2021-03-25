//
//  NewProjectCardVC.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 20.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit
import PanModal
import FirebaseAuth
import FirebaseDatabase

class NewProjectVC					: UIViewController, UINavigationControllerDelegate, PanModalPresentable {
	
	var panScrollable: UIScrollView? {
		return nil
	}

	var longFormHeight: PanModalHeight {
		return .maxHeight
	}
	
	var handle: UIView! 			= UIView()
    
	private var user           		: MUser!
    private var ref             	: DatabaseReference!

	private var imageIsChanged 		: Bool = false
	
	private var addCounter			: Bool = false

	private var createLabel			= UILabel()
	private var projectImage		= UIImageView()
	private var projectName			= UITextField()
	private var createGlobalCounterLabel = UILabel()
	private var globalCounterSwitch = UISwitch()

	private var createButton		= UIButton()
	private var warning				= UILabel()

	private var viewModel			: NewProjectCardVM! {
		didSet {
			self.createLabel		= viewModel.createLabel()
			self.projectImage		= viewModel.profileImage()
			self.projectName		= viewModel.projectName()
			self.createButton		= viewModel.createButton()
			self.globalCounterSwitch = viewModel.globarCounterSwitch()
			self.createGlobalCounterLabel = viewModel.createGlobalCounterLabel()
			
			let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.projectImageTapped(recognizer:)))
			singleTap.numberOfTapsRequired = 1
			self.projectImage.addGestureRecognizer(singleTap)
			
			globalCounterSwitch.addTarget(self, action: #selector(didChangeGlobalCounterSwitch), for: .valueChanged)
			createButton.addTarget(self, action: #selector(saveCounter), for: .touchUpInside)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel = NewProjectCardVM()
		setupNewProjectView()
		self.title = "Create new project".localized()

		guard let currentUser = Auth.auth().currentUser else { return }
		user	= MUser(user: currentUser)
		ref		= Database.database().reference(withPath: "users").child(String(user.uid))
		
		setingUpKeyboardHiding()
		let tap : UITapGestureRecognizer	= UITapGestureRecognizer(target: self, action: #selector(hideKeyboardWhenTapped))
		view.addGestureRecognizer(tap)
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
				image = UIImage(named: "_0")
			}
			let projectUniqueID = Int(Date().timeIntervalSince1970)
			guard let imageData = image?.toString() else { return }
			guard let name		= projectName.text	else { return }
			
			let project = MProject(userID: user.uid, name: name, image: imageData, date: "\(projectUniqueID)")
			let referenceForProject = self.ref.child("projects").child("\(projectUniqueID)")
			referenceForProject.setValue(project.projectToDictionary())
			
			let fakeCounter = MCounter(name: "knitting-f824f", rows: 0, rowsMax: -1, date: "000000000")
			let referenceForCounter = self.ref.child("projects").child("\(projectUniqueID)").child("counters").child("knitting-f824f")
			referenceForCounter.setValue(fakeCounter.counterToDictionary())
			
			if addCounter {
				let counter = MCounter(name: name, rows: 0, rowsMax: -1, date: "999999999")
				let referenceForCounter = self.ref.child("projects").child("\(projectUniqueID)").child("counters").child("\(name)")
				referenceForCounter.setValue(counter.counterToDictionary())
			}
			AnalyticsService.reportEvent(with: "New project", parameters: ["name" : project.name])
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
extension NewProjectVC: UIImagePickerControllerDelegate {
    
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
extension NewProjectVC {
	
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
extension NewProjectVC: UITextFieldDelegate {
    
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
extension NewProjectVC {
	
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
		
		view.addSubview(globalCounterSwitch)
		globalCounterSwitch.translatesAutoresizingMaskIntoConstraints								= false
		globalCounterSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
		globalCounterSwitch.topAnchor.constraint(equalTo: projectName.bottomAnchor, constant: 35).isActive = true
		
		view.addSubview(createGlobalCounterLabel)
		createGlobalCounterLabel.translatesAutoresizingMaskIntoConstraints							= false
		createGlobalCounterLabel.topAnchor.constraint(equalTo: projectName.bottomAnchor, constant: 39).isActive = true
		createGlobalCounterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
		createGlobalCounterLabel.trailingAnchor.constraint(equalTo: globalCounterSwitch.leadingAnchor, constant: 10).isActive = true
		
		view.addSubview(createButton)
		createButton.translatesAutoresizingMaskIntoConstraints										= false
		createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive					= true
		createButton.topAnchor.constraint(equalTo: projectName.bottomAnchor, constant: 100).isActive		= true
		createButton.trailingAnchor .constraint(equalTo: view.trailingAnchor,   constant:  -16).isActive							= true
		createButton.heightAnchor.constraint(equalToConstant: 50).isActive							= true
	}
}


