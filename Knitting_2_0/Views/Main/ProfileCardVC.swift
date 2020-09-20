//
//  ProfileCardVC.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 19.09.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

protocol CardViewControllerProtocol	: UIViewController {
	var handle : UIView! { get }
}

class ProfileCardVC					: UIViewController, CardViewControllerProtocol {
	
	var handle: UIView! 			= UIView()
    
	private var user           		: MUsers!
    private var ref             	: DatabaseReference!

	private var signoutBtn			= UIButton()
	private var deleteAccountBtn	= UIButton()
	private var profileImage		= UIImageView()
	private var fullname			= UILabel()
	private var email				= UILabel()
	private var darkBackground		= UIView()
	private var close				= UILabel()
	
	private var viewModel			: ProfileCardVM! {
		didSet {
			self.signoutBtn			= viewModel.signOut()
			self.deleteAccountBtn	= viewModel.deleteAccount()
			self.profileImage		= viewModel.profileImageView()
			self.fullname			= viewModel.fullnameLabel()
			self.email				= viewModel.emailLabel()
			self.darkBackground		= viewModel.darkBackgroundView()
			self.close				= viewModel.closeLabel()
			self.handle				= viewModel.handleView()
			
			self.signoutBtn.addTarget		(self, action: #selector(signoutFromAccount),	for: .touchUpInside)
			self.deleteAccountBtn.addTarget	(self, action: #selector(deleteAcoount),		for: .touchUpInside)
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white
		viewModel = ProfileCardVM()
		setupProfileView()
		
		guard let currentUser = Auth.auth().currentUser else { return }
		user	= MUsers(user: currentUser)
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

	@objc
	func signoutFromAccount() {
		do {
			try Auth.auth().signOut()
		} catch {
			print(error.localizedDescription)
		}
		self.navigationController?.popToRootViewController(animated: true)
		self.navigationController?.dismiss(animated: false, completion: nil)
	}
	
	@objc
	func deleteAcoount() {
		let user = Auth.auth().currentUser
		
		user?.delete { error in
			if let error = error {
				print(error.localizedDescription)
			} else {
				self.navigationController?.popToRootViewController(animated: true)
				self.navigationController?.dismiss(animated: false, completion: nil)
			}
		}
	}
}

//MARK: Layout
extension ProfileCardVC {
	
	func setupProfileView() {

		view.addSubview(handle)
		handle.translatesAutoresizingMaskIntoConstraints											= false
		handle.topAnchor.constraint(equalTo: view.topAnchor).isActive								= true
		handle.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive						= true
		handle.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive						= true
		handle.heightAnchor.constraint(equalToConstant: 100).isActive								= true
		
		view.addSubview(profileImage)
		profileImage.translatesAutoresizingMaskIntoConstraints										= false
		profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive			= true
		profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive					= true
		profileImage.heightAnchor.constraint(equalToConstant: 80).isActive							= true
		profileImage.widthAnchor.constraint(equalTo: profileImage.heightAnchor).isActive			= true

		view.addSubview(fullname)
		fullname.translatesAutoresizingMaskIntoConstraints											= false
		fullname.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20).isActive	= true
		fullname.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive						= true
		fullname.widthAnchor.constraint(greaterThanOrEqualToConstant: 300).isActive					= true
		
		view.addSubview(email)
		email.translatesAutoresizingMaskIntoConstraints												= false
		email.topAnchor.constraint(equalTo: fullname.bottomAnchor, constant: 8).isActive			= true
		email.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive						= true
		
		view.addSubview(signoutBtn)
		signoutBtn.translatesAutoresizingMaskIntoConstraints										= false
		signoutBtn.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 45).isActive			= true
		signoutBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive					= true
		signoutBtn.widthAnchor.constraint(equalToConstant: 150).isActive							= true
		
		view.addSubview(deleteAccountBtn)
		deleteAccountBtn.translatesAutoresizingMaskIntoConstraints									= false
		deleteAccountBtn.topAnchor.constraint(equalTo: signoutBtn.bottomAnchor, constant: 5).isActive	= true
		deleteAccountBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive				= true
		deleteAccountBtn.widthAnchor.constraint(equalToConstant: 150).isActive						= true
       
		self.view.addSubview(close)
        close.translatesAutoresizingMaskIntoConstraints												= false
        close.bottomAnchor.constraint(equalTo: view.topAnchor, constant: -10).isActive				= true
        close.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive						= true
		
		self.view.bringSubviewToFront(darkBackground)
        self.view.bringSubviewToFront(close)
	}
//	
//	func teardownProfileView() {
//		self.close.removeFromSuperview()
//		self.darkBackground.removeFromSuperview()
//		self.view.removeFromSuperview()
//	}
}
