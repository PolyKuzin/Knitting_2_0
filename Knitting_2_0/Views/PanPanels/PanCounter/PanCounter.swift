//
//  PanCounter.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 02.05.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit
import PanModal
import FirebaseAuth
import FirebaseDatabase

class PanCounter : BasePanVC, PanModalPresentable {
	
	private var user  : MUser!
	private var ref   : DatabaseReference!
	
	public var panScrollable: UIScrollView? {
		return tableView
	}
	
	public var longFormHeight: PanModalHeight {
		return .maxHeight
	}
	
	public var currentProject : MProject?
	public var currentCounter : MCounter? {
		didSet {
			guard let curr = currentCounter else { return }
			self.currentName = curr.name
			if curr.rowsMax == -1 {
				self.currentSwitch = false
			} else {
				self.currentRowsMax = curr.rowsMax
			}
		}
	}
	private var reloaded = false
	private var currentName    = ""   { didSet { print(currentName)    } }
	private var currentImage   = 0    { didSet { print(currentImage)   } }
	private var currentRowsMax = 0    { didSet { print(currentRowsMax) } }
	private var currentSwitch  = true {
		didSet {
			if reloaded { self.makeState() }
			print(currentSwitch)
			if currentSwitch == false { currentRowsMax = 0 }
		}
	}

	@IBOutlet weak var tableView : UITableView!

	struct ViewState {
		
		var rows : [Any]
		
		struct SelectImages     :_SelectCell {
			var items          : [Item]
			var currentImage   : Int
			var showPayWall    : (()->())
			var selectImage    : ((Int)->())
		}
		
		struct SelectName       : _SelectNameCell {
			var name           : String
			var selectName     : ((String)->())
		}
		
		struct SelectCounter    : _SwitcherCell   {
			var title          : String
			var switcher       : Bool
			var onSwitch       : ((Bool)->())
		}
		
		struct SelectRows       : _SelectRowsCell {
			var isEnabled      : Bool
			var rowsMax        : Int
			var selectRows     : ((Int)->())
		}
		
		struct BecomePro        : _BecomePro      {
			var image          : UIImage?
			var title          : String
			var color          : UIColor?
			var onBecomePro    : (()->())
		}

		struct MainButton       : _MainButton     {
			var title          : String
			var onTap          : (() -> ())
			var color          : UIColor
		}
		
		static let initial = ViewState(rows: [])
	}
	
	public var viewState : ViewState = .initial {
		didSet {
			self.tableView.reloadData()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		guard let currentUser = Auth.auth().currentUser else { return }
		user = MUser(user: currentUser)
		ref  = currentProject?.ref?.child("counters")
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.separatorStyle = .none
		self.tableView.register(UINib(nibName: "BecomeProCell",     bundle: nil), forCellReuseIdentifier: "BecomeProCell")
		self.tableView.register(UINib(nibName: "SelectRowsCell",     bundle: nil), forCellReuseIdentifier: "SelectRowsCell")
		self.tableView.register(UINib(nibName: "MainButtonCell",    bundle: nil), forCellReuseIdentifier: "MainButtonCell")
		self.tableView.register(UINib(nibName: "SelectNameCell",    bundle: nil), forCellReuseIdentifier: "SelectNameCell")
		self.tableView.register(UINib(nibName: "CreateCounterCell", bundle: nil), forCellReuseIdentifier: "CreateCounterCell")
		self.makeState()
		if currentCounter != nil {
			self.title = "Edit counter".localized()
		} else {
			self.title = "Create new counter".localized()
		}
    }
	
	private func makeState() {
		let defaults = UserDefaults()
		let payWallClosure : (()->())       = { [weak self]        in
			guard let self = self else { return }
			self.showPayWall()
		}
		let nameClosure    : ((String)->()) = { [weak self] result in
			guard let self = self else { return }
			self.currentName    = result
		}
		let counterClosure : ((Bool)->())   = { [weak self] result in
			guard let self = self else { return }
			self.currentSwitch  = result
		}
		let rowsMaxClosure : ((Int)->())    = { [weak self] result in
			guard let self = self else { return }
			self.currentRowsMax = result
		}
		let selectName    = ViewState.SelectName    (name : currentName, selectName: nameClosure)
		let selectCounter = ViewState.SelectCounter (title : "Set the number of rows?".localized(), switcher: self.currentSwitch, onSwitch    : counterClosure)
		let selectRows    = ViewState.SelectRows    (isEnabled: currentSwitch, rowsMax: self.currentRowsMax, selectRows: rowsMaxClosure)
		self.viewState.rows = [selectName, selectCounter, selectRows]
		if currentCounter != nil {
			let mainButton    = ViewState.MainButton(title : "Save".localized(), onTap: self.editCounter, color: UIColor.mainColor)
			self.viewState.rows.append(mainButton)
		} else {
			let mainButton    = ViewState.MainButton(title : "Create".localized(), onTap: self.saveCounter, color: UIColor.mainColor)
			self.viewState.rows.append(mainButton)
		}
		if defaults.bool(forKey: "setPro") == false {
			let becomePro     = ViewState.BecomePro       (image: UIImage(named: "Diamond")!, title: "Become PRO Knitter".localized(), color: UIColor(red: 0.552, green: 0.325, blue: 0.779, alpha: 1), onBecomePro : payWallClosure)
			self.viewState.rows.insert(becomePro, at: self.viewState.rows.count - 1)
		}
		reloaded = true
	}
}

extension PanCounter : UITableViewDelegate { }

extension PanCounter : UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.viewState.rows.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch self.viewState.rows[indexPath.row] {
		case is ViewState.SelectName      :
			let data = self.viewState.rows[indexPath.row] as! ViewState.SelectName
			let cell = tableView.dequeueReusableCell(withIdentifier: "SelectNameCell",    for: indexPath) as! SelectNameCell
			cell.configure(with: data)
			return cell
		case is ViewState.SelectImages    :
			let data = self.viewState.rows[indexPath.row] as! ViewState.SelectImages
			let cell = tableView.dequeueReusableCell(withIdentifier: "SelectImageCell",   for: indexPath) as! SelectImageCell
			cell.configure(with: data)
			return cell
		case is ViewState.SelectCounter   :
			let data = self.viewState.rows[indexPath.row] as! ViewState.SelectCounter
			let cell = tableView.dequeueReusableCell(withIdentifier: "CreateCounterCell", for: indexPath) as! SwitcherCell
			cell.configure(with: data)
			return cell
		case is ViewState.SelectRows      :
			let data = self.viewState.rows[indexPath.row] as! ViewState.SelectRows
			let cell = tableView.dequeueReusableCell(withIdentifier: "SelectRowsCell",    for: indexPath) as! SelectRowsCell
			cell.configure(with: data)
			return cell
		case is ViewState.MainButton      :
			let data = self.viewState.rows[indexPath.row] as! ViewState.MainButton
			let cell = tableView.dequeueReusableCell(withIdentifier: "MainButtonCell",    for: indexPath) as! MainButtonCell
			cell.configure(with: data)
			return cell
		case is ViewState.BecomePro       :
			let data = self.viewState.rows[indexPath.row] as! ViewState.BecomePro
			let cell = tableView.dequeueReusableCell(withIdentifier: "BecomeProCell",     for: indexPath) as! BecomeProCell
			cell.configure(with: data)
			return cell
		default:
			return UITableViewCell()
		}
	}
}

extension PanCounter {
	
	func saveCounter() {
		if currentName == "" { currentName = "Unnamed" }
		let date = Int(Date().timeIntervalSince1970)
		let counter = MCounter(name: currentName, rows: 0, rowsMax: currentRowsMax, date: "\(date)")
		ref.child("\(date)").setValue(counter.counterToDictionary())
		AnalyticsService.reportEvent(with: "New counter", parameters: ["name" : counter.name])
		self.dismiss(animated: true, completion: nil)
	}
	
	func editCounter() {
		if currentName == "" { currentName = "Unnamed" }
		guard let counter = self.currentCounter, let referenceForCounter = self.currentCounter?.ref else { return }
		referenceForCounter.updateChildValues(["name"     : currentName,
												"rowsMax" : currentRowsMax,
												"date"    : counter.date])
		AnalyticsService.reportEvent(with: "Edit counter", parameters: ["name" : currentName])
		self.dismiss(animated: true, completion: nil)
	}
}
