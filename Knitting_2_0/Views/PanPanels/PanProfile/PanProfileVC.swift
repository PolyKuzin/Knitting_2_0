//
//  PanProfileVC.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 23.01.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit
import PanModal
import FirebaseAuth
import FirebaseDatabase

class PanProfileVC : BasePanVC, PanModalPresentable {
	
	var panScrollable: UIScrollView? {
		return tableView
	}
	
	var longFormHeight: PanModalHeight {
		return .maxHeight
	}
	
	private var user  : MUser!
	private var ref   : DatabaseReference!
	
	@IBOutlet weak var tableView : UITableView!
	
	struct ViewState {
		
		var rows : [Any]
		
		struct Information {
			var image : UIImage
			var name  : String
			var email : String
		}
		
		static let initial = ViewState(rows: [])
	}
	
	var viewState : ViewState = .initial {
		didSet {
			tableView.reloadData()
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)

	}

    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Settings".localized()
//		tableView.isScrollEnabled = false
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorStyle = .none
		tableView.register(UINib(nibName: "InformationCell", bundle: nil), forCellReuseIdentifier: InformationCell.reuseID )
		
		UserDefaults.standard.bool(forKey: "setPro") ? makePremiumState() : makeStandartState()
    }
	
	func getProfileInformation() -> ViewState.Information {
		var name = ""
		var email = ""
		if !(UserDefaults.standard.string(forKey: "UserName") != nil), let currentUser = Auth.auth().currentUser {
			user	= MUser(user: currentUser)
			ref		= Database.database().reference(withPath: "users").child(String(user.uid))
			ref.observeSingleEvent(of: .value, with: { (snapshot) in
				let value = snapshot.value		as? NSDictionary
				name      = value?["nickname"]	as? String ?? ""
				email     = value?["email"]		as? String ?? ""
				UserDefaults.standard.setValue(name,  forKey: "UserName")
				UserDefaults.standard.setValue(email, forKey: "UserEmail")
				AnalyticsService.reportEvent(with: "Profile Dowloaded")
				UIView.performWithoutAnimation {
					self.tableView.reloadData()
				}
				}) { (error) in
				print(error.localizedDescription)
				name  = UserDefaults.standard.string(forKey: "UserName")  ?? "Your name"
				email = UserDefaults.standard.string(forKey: "UserEmail") ?? "Your email"
			}
		} else {
			AnalyticsService.reportEvent(with: "Profile From Phone")
			name  = UserDefaults.standard.string(forKey: "UserName")  ?? "Your name"
			email = UserDefaults.standard.string(forKey: "UserEmail") ?? "Your email"
		}
		if let image = UserDefaults.standard.string(forKey: "UserImage")?.toImage() {
			return ViewState.Information(image: image, name: name, email: email)
		}
		return ViewState.Information(image: UIImage(named: "emptyProfile")!, name: name, email: email)
	}
	
	func makePremiumState() {
		let info = self.getProfileInformation()
		
		viewState.rows.append(contentsOf: [info])
	}
	
	func makeStandartState() {
		let info  = self.getProfileInformation()
		self.viewState.rows = [info]
	}
}

extension PanProfileVC : UITableViewDelegate {
	
}

extension PanProfileVC : UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewState.rows.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch viewState.rows[indexPath.row] {
		case is ViewState.Information :
			let data = viewState.rows[indexPath.row]
			let cell = tableView.dequeueReusableCell(withIdentifier: "InformationCell", for: indexPath) as! InformationCell
			cell.configure(with: data)
			cell.selectionStyle = .none
			cell.separatorInset = .zero
			return cell
		default                       :
			return UITableViewCell()
		}
	}
}