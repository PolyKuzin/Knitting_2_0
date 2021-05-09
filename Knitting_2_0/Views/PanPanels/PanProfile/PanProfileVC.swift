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
	
	public var panScrollable: UIScrollView? {
		return tableView
	}
	
	public var longFormHeight: PanModalHeight {
		return .maxHeight
	}
	
	private var items : [Item] = []
	
	private var currentTheme = 0 {
		didSet {
			print(currentTheme)
		}
	}
	
	private var user  : MUser!
	private var ref   : DatabaseReference!
	
	@IBOutlet weak var tableView : UITableView!
	
	struct ViewState        {
		
		var rows : [Any]
		
		struct Information  {
			var image        : UIImage
			var name         : String
			var email        : String
		}
		
		struct BecomePro      : _BecomePro      {
			var image        : UIImage?
			var title        : String
			var color        : UIColor?
			var onBecomePro  : (()->())
		}
		
		struct MainButton     : _MainButton     {
			var title        : String
			var onTap        : (() -> ())
			var color        : UIColor
		}
		
		struct SectionTitle   : _Title {
			var title        : String
		}
		
		struct SelectTheme    :_SelectCell {
			var items        : [Item]
			var currentImage : Int
			var showPayWall  : (()->())
			var selectImage  : ((Int)->())
		}
		
		struct ImageInfo    {
			var image        : UIImage
			var onTap        : (()->())
			var isEnabled    : Bool
		}
		
		struct Appearence     : _CheckCell {
			var title        : String
			var leftIcon     : UIImage
			var isSelected   : Bool
		}
		
		static let initial = ViewState(rows: [])
	}
	
	var viewState : ViewState = .initial {
		didSet {
			self.tableView.reloadData()
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		self.items = self.createItems()
		self.title = "Settings".localized()
		self.tableView.delegate = self
		self.tableView.dataSource = self

		self.tableView.register(CheckCell.nib, forCellReuseIdentifier: CheckCell.reuseId)
		self.tableView.register(SelectCell.nib, forCellReuseIdentifier: SelectCell.reuseId)
		self.tableView.register(BecomeProCell.nib, forCellReuseIdentifier: BecomeProCell.reuseId)
		self.tableView.register(MainButtonCell.nib, forCellReuseIdentifier: MainButtonCell.reuseId)
		self.tableView.register(InformationCell.nib, forCellReuseIdentifier: InformationCell.reuseId)
		self.tableView.register(SectionTitleCell.nib, forCellReuseIdentifier: SectionTitleCell.reuseId )

		self.makeState()
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
				self.tableView.reloadData()
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
	
	private func createItems() -> [Item] {
		let defaults = UserDefaults()
		let item0 = Item(image: UIImage(named: "purp_Theme")!,  isEnabled: defaults.bool(forKey: "setPro"),
						 isSelected: UserDefaults.standard.integer(forKey: "Color_main") == 0 ? true : false)
		let item1 = Item(image: UIImage(named: "green_Theme")!, isEnabled: defaults.bool(forKey: "setPro"),
						 isSelected: UserDefaults.standard.integer(forKey: "Color_main") == 1 ? true : false)
		let item2 = Item(image: UIImage(named: "red_Theme")!,   isEnabled: defaults.bool(forKey: "setPro"),
						 isSelected: UserDefaults.standard.integer(forKey: "Color_main") == 2 ? true : false)
		return [item0, item1, item2]
	}
	
	private func handleSelection(_ result: Int) {
		for index in 0...items.count-1 {
			if self.items[index].image == UIImage(named: "_\(result)") {
				self.items.enumerated().forEach { (_index,_) in self.items[_index].isSelected = false }
				self.items[index].isSelected = true
				self.makeState()
			}
		}
	}
	
	func makeState() {
		let payWallClosure : (()->())       = { [weak self]        in
			guard let self = self else { return }
			self.showPayWall()
		}
		let themeClosure   : ((Int)->())    = { [weak self] result in
			guard let self = self else { return }
			self.handleSelection (result)
			self.currentTheme   = result
		}
		let info  = self.getProfileInformation()
		self.viewState.rows = [info]
		if UserDefaults.standard.bool(forKey: "setPro") == false {
			let becomePro     = ViewState.BecomePro       (image: UIImage(named: "Diamond")!, title: "Become PRO Knitter".localized(), color: UIColor(red: 0.552, green: 0.325, blue: 0.779, alpha: 1), onBecomePro : payWallClosure)
			self.viewState.rows.append(becomePro)
		} else {
			
		}
		let shareApp     = ViewState.MainButton(title: "Share the App".localized(), onTap: {}, color: UIColor.mainColor)
		let colorsHeader = ViewState.SectionTitle(title: "Main colors:".localized())
		let selectTheme  = ViewState.SelectTheme(items: self.items, currentImage: UserDefaults.standard.integer(forKey: "Color_main"), showPayWall: payWallClosure, selectImage: themeClosure)
		let appearenceHeader = ViewState.SectionTitle(title: "Appearence:".localized())
		let currentTheme = UserDefaults.standard.integer(forKey: "Color_background")
		let darkAppearence = ViewState.Appearence(title: "Dark".localized(), leftIcon: UIImage.moon, isSelected: currentTheme == )
		
		self.viewState.rows.append(contentsOf: [shareApp, colorsHeader, selectTheme, appearenceHeader])
	}
}

// MARK: - TableView Delegate
extension PanProfileVC : UITableViewDelegate {
	
}

// MARK: - TableView Data Source
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
			return cell
		case is ViewState.SectionTitle      :
			let data = viewState.rows[indexPath.row] as! _Title
			let cell = tableView.dequeueReusableCell(withIdentifier: SectionTitleCell.reuseId, for: indexPath) as! SectionTitleCell
			cell.configure(with: data)
			return cell
		case is ViewState.SelectTheme  :
			let data = viewState.rows[indexPath.row] as! _SelectCell
			let cell = tableView.dequeueReusableCell(withIdentifier: SelectCell.reuseId, for: indexPath) as! SelectCell
			cell.configure(with: data)
			return cell
		case is ViewState.BecomePro       :
			let data = self.viewState.rows[indexPath.row] as! ViewState.BecomePro
			let cell = tableView.dequeueReusableCell(withIdentifier: "BecomeProCell",     for: indexPath) as! BecomeProCell
			cell.configure(with: data)
			return cell
		case is ViewState.MainButton      :
			let data = self.viewState.rows[indexPath.row] as! ViewState.MainButton
			let cell = tableView.dequeueReusableCell(withIdentifier: "MainButtonCell",    for: indexPath) as! MainButtonCell
			cell.configure(with: data)
			return cell
		case is ViewState.Appearence     :
			let data = self.viewState.rows[indexPath.row] as! ViewState.Appearence
			let cell = tableView.dequeueReusableCell(withIdentifier: CheckCell.reuseId,    for: indexPath) as! CheckCell
			cell.configure(with: data)
			return cell
		default                       :
			return UITableViewCell()
		}
	}
}
