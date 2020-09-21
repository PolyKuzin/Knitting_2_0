//
//  NewProjectCardVC.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 20.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class NewProjectVC					: UIViewController, CardViewControllerProtocol, UINavigationControllerDelegate {
	
	var handle: UIView! 			= UIView()
    
	private var user           		: MUsers!
    private var ref             	: DatabaseReference!
	private var imageIsChanged = false


	private var createLabel			= UILabel()
	private var projectImage		= UIImageView()
	
//	let tapGestureRecognizer		= UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(recognizer:)))
	
	private var viewModel			: NewProjectCardVM! {
		didSet {
			self.createLabel		= viewModel.create()
			self.projectImage		= viewModel.profileImage()
			let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.profileImageTapped(recognizer:)))
			singleTap.numberOfTapsRequired = 1
			self.projectImage.addGestureRecognizer(singleTap)
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white
		viewModel = NewProjectCardVM()
		setupProfileView()
		
		guard let currentUser = Auth.auth().currentUser else { return }
		user	= MUsers(user: currentUser)
        ref		= Database.database().reference(withPath: "users").child(String(user.uid))
    }
	
	@objc
	func profileImageTapped(recognizer: UIGestureRecognizer) {
		print("!!!!!!!!!!!!!!")
		let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let camera = UIAlertAction(title: "Camera", style: .default) { _ in
			self.chooesImagePicker(sourse: .camera)
		}
		let photo = UIAlertAction(title: "Library", style: .default) { _ in
			self.chooesImagePicker(sourse: .photoLibrary)
		}
		let cancel = UIAlertAction(title: "Cancel", style: .cancel)
		actionSheet.addAction(camera)
		actionSheet.addAction(photo)
		actionSheet.addAction(cancel)
		present(actionSheet, animated: true)
	}
}

// MARK: Work with IMAGE
extension NewProjectVC: UIImagePickerControllerDelegate {
    
    func chooesImagePicker (sourse: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(sourse) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = sourse
            present(imagePicker, animated: true)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        projectImage.image = info[.editedImage] as? UIImage
        projectImage.contentMode = .scaleAspectFill
        projectImage.clipsToBounds = true
        imageIsChanged = true
        dismiss(animated: true)
    }
}

//MARK: Layout
extension NewProjectVC {
	
	func setupProfileView() {

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
	}
}


