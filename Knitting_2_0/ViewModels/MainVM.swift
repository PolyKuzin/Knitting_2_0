//
//  MainVM.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 12.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

protocol CollectionViewViewModelType {

}

class MainVM : CollectionViewViewModelType {
	
//MARK: MAIN View Controller
	// Setting up sections
	func sections() -> MSection {
		let project1 = MProject(userID: "1238", projectID: "123", name: "123", imageRef: "123")
		let project2 = MProject(userID: "1234", projectID: "123", name: "123", imageRef: "123")
		let project3 = MProject(userID: "1235", projectID: "123", name: "123", imageRef: "123")
		let project4 = MProject(userID: "1236", projectID: "123", name: "123", imageRef: "123")
		let project5 = MProject(userID: "1237", projectID: "123", name: "123", imageRef: "123")

		let section = MSection(type: "projects", title: "Working on this?", projects: [project1, project2, project3, project4, project5])
		
		return section
	}
	
	
//MARK: Profile Card View Controller
	private var signoutBtn			: UIButton = {
		let button					= UIButton(type: .system)
		button.frame 				= CGRect(x: 0, y: 0, width: 500, height: 50)
		button.titleLabel?.font		= Fonts.textSemibold17
		button.setTitle				("Sign out ", for: .normal)
		button.setTitleColor		(UIColor(red: 0.961, green: 0.188, blue: 0.467, alpha: 1), 	for: .normal)
		button.setImage(Icons.exit, for: .normal)
		button.tintColor = UIColor(red: 0.961, green: 0.188, blue: 0.467, alpha: 1)
		button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
		button.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
		button.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
		
		return button
	}()
	
	var deleteAccountBtn			: UIButton = {
		let button					= UIButton(type: .system)
		button.frame 				= CGRect(x: 0, y: 0, width: 500, height: 50)
		button.titleLabel?.font		= Fonts.textSemibold14
		button.setTitle				("Delete account", for: .normal)
		button.setTitleColor		(UIColor(red: 0.961, green: 0.188, blue: 0.467, alpha: 1), 	for: .normal)
		
		return button
	}()
	
	let profileImage				: UIImageView = {
		let imageView				= UIImageView()
		imageView.image				= Icons.emptyProfile
		imageView.layer.cornerRadius = 40
		imageView.layer.masksToBounds = true
		
		return imageView
	}()
	
	let fullname				: UILabel = {
		let label					= UILabel()
		label.text 					= "Kostya The Knitter"
		label.textAlignment 		= .center
		label.font 					= Fonts.displaySemibold22
		label.textColor 			= UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
		
		return label
	}()
	
	let email						: UILabel = {
		let label					= UILabel()
		label.text 					= "example@example.com"
		label.textAlignment 		= .center
		label.font 					= Fonts.displayRegular17
		label.textColor 			= UIColor(red: 0.55, green: 0.55, blue: 0.55, alpha: 1)
		
		return label
	}()
	
	let darkBackground				: UIView = {
		let view					= UIView()
        view.backgroundColor		= UIColor(red: 0, green: 0, blue: 0, alpha: 1)
		view.alpha 					= 0.7
		view.isUserInteractionEnabled = true

		return view
	}()
	
	let close					: UILabel = {
		let label					= UILabel()
		label.text					= "Close"
		label.textColor				= .white
		label.alpha					= 0
		label.isUserInteractionEnabled = true
		label.font					= Fonts.textBold17
		
		return label
	}()
	
	func signOut() -> UIButton {
		return signoutBtn
	}
	
	func deleteAccount() -> UIButton {
		return deleteAccountBtn
	}
	
	func profileImageView() -> UIImageView {
		return profileImage
	}
	
	func fullnameLabel() -> UILabel {
		return fullname
	}
	
	func emailLabel() -> UILabel {
		return email
	}
	
	func darkBackgroundView() -> UIView {
		return darkBackground
	}
	
	func closeLabel() -> UILabel {
		return close
	}
}
