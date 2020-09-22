//
//  ProfileCardVM.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 19.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileCardVM {
	
	private var user           		: MUser!
    private var ref             	: DatabaseReference!
	
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
	
	let close						: UILabel = {
		let label					= UILabel()
		label.text					= "Close"
		label.textColor				= .white
		label.alpha					= 0
		label.isUserInteractionEnabled = true
		label.font					= Fonts.textBold17
		
		return label
	}()
	
	let handle						: UIView = {
		let view					= UIView()
		view.backgroundColor		= .white
		
		view.isUserInteractionEnabled = true
		
		return view
	}()
	
	func chekingEmailAndNickName() {
		guard let currentUser = Auth.auth().currentUser else { return }									//TO ViewModel!
		user	= MUser(user: currentUser)
        ref		= Database.database().reference(withPath: "users").child(String(user.uid))
		ref.observeSingleEvent(of: .value, with: { (snapshot) in
			// Get user value
			let value		= snapshot.value		as? NSDictionary
			let nickname	= value?["nickname"]	as? String ?? ""
			let email		= value?["email"]		as? String ?? ""
			self.fullname.text	= nickname
			self.email.text		= email
		  }) { (error) in
			print(error.localizedDescription)
		}
	}
	
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
	
	func handleView() -> UIView {
		return handle
	}
}
