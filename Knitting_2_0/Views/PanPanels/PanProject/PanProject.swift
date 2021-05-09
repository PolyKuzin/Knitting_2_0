//
//  PanNewCounter.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 19.02.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit
import PanModal
import FirebaseAuth
import FirebaseDatabase

struct Item {
	var image       : UIImage
	var isEnabled   : Bool
	var isSelected  : Bool
}

class PanProject : BasePanVC, PanModalPresentable {
	
	private var items : [Item] = []
	private var user  : MUser!
	private var ref   : DatabaseReference!
	
	var panScrollable: UIScrollView? {
		return self.tableView
	}
	
	var longFormHeight: PanModalHeight {
		return .maxHeight
	}
	
	public var currentProject  : MProject? {
		didSet {
			guard let curr = currentProject else { return }
			self.currentName = curr.name
			self.currentImage = self.getImage(curr.image)
		}
	}
	
	private var currentName    = ""   { didSet { print(currentName)   } }
	private var currentImage   = 0    { didSet { print(currentImage)  } }
	private var currentSwitch  = true { didSet { print(currentSwitch) } }
	
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
		ref	 = Database.database().reference(withPath: "users").child(String(user.uid))
		self.items = self.createItems()
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.separatorStyle = .none
		self.tableView.register(SwitcherCell.nib, forCellReuseIdentifier: SwitcherCell.reuseId)
		self.tableView.register(BecomeProCell.nib, forCellReuseIdentifier: BecomeProCell.reuseId)
		self.tableView.register(MainButtonCell.nib, forCellReuseIdentifier: MainButtonCell.reuseId)
		self.tableView.register(SelectNameCell.nib, forCellReuseIdentifier: SelectNameCell.reuseId)
		self.tableView.register(SelectImageCell.nib, forCellReuseIdentifier: SelectImageCell.reuseId)
		if currentProject != nil {
			self.makeState()
			self.title = "Edit project".localized()
		} else {
			self.makeState()
			self.title = "Create new project".localized()
		}
    }
	
	private func createItems() -> [Item] {
		let defaults = UserDefaults()
		let item0 = Item(image: UIImage(named: "_0")!, isEnabled: true, isSelected: true)
		let item1 = Item(image: UIImage(named: "_1")!, isEnabled: defaults.bool(forKey: "setPro"), isSelected: false)
		let item2 = Item(image: UIImage(named: "_2")!, isEnabled: defaults.bool(forKey: "setPro"), isSelected: false)
		let item3 = Item(image: UIImage(named: "_3")!, isEnabled: defaults.bool(forKey: "setPro"), isSelected: false)
		let item4 = Item(image: UIImage(named: "_4")!, isEnabled: defaults.bool(forKey: "setPro"), isSelected: false)
		let item5 = Item(image: UIImage(named: "_5")!, isEnabled: defaults.bool(forKey: "setPro"), isSelected: false)
		let item6 = Item(image: UIImage(named: "_6")!, isEnabled: defaults.bool(forKey: "setPro"), isSelected: false)
		self.items = [item0, item1, item2, item3, item4, item5, item6]
		return self.items
	}
	
	private func handleSelection(_ result: Int) {
		for index in 0...6 {
			if self.items[index].image == UIImage(named: "_\(result)") {
				self.items.enumerated().forEach { (_index,_) in self.items[_index].isSelected = false }
				self.items[index].isSelected = true
				self.makeState()
			}
		}
	}
	
	private func makeState() {
		let defaults = UserDefaults()
		let payWallClosure : (()->())       = { [weak self]        in
			guard let self = self else { return }
			self.showPayWall()
		}
		let imageClosure   : ((Int)->())    = { [weak self] result in
			guard let self = self else { return }
			self.handleSelection (result)
			self.currentImage   = result
		}
		let nameClosure    : ((String)->()) = { [weak self] result in
			guard let self = self else { return }
			self.currentName    = result
		}
		let counterClosure : ((Bool)->())   = { [weak self] result in
			guard let self = self else { return }
			self.currentSwitch = result
		}
		let selectImage   = ViewState.SelectImages    (items: self.items,  currentImage: self.currentImage, showPayWall: payWallClosure, selectImage: imageClosure)
		let selectName    = ViewState.SelectName      (name : currentName, selectName: nameClosure)

		self.viewState.rows = [selectImage, selectName]
		if currentProject != nil {
			let mainButton    = ViewState.MainButton      (title : "Save".localized(), onTap: self.editProject, color: UIColor.mainColor)
			self.viewState.rows.append(mainButton)
		} else {
			let selectCounter = ViewState.SelectCounter   (title : "Create counter with project name?".localized(), switcher: self.currentSwitch, onSwitch    : counterClosure)
			let mainButton    = ViewState.MainButton      (title : "Create".localized(), onTap: self.saveProject, color: UIColor.mainColor)
			self.viewState.rows.append(selectCounter)
			self.viewState.rows.append(mainButton)
		}
		if defaults.bool(forKey: "setPro") == false {
			let becomePro     = ViewState.BecomePro       (image: UIImage(named: "Diamond")!, title: "Become PRO Knitter".localized(), color: UIColor(red: 0.552, green: 0.325, blue: 0.779, alpha: 1), onBecomePro : payWallClosure)
			self.viewState.rows.insert(becomePro, at: self.viewState.rows.count - 1)
		}
	}
}

// MARK: - TableView Delegate
extension PanProject : UITableViewDelegate {
	
}

// MARK: - TableView DataSource
extension PanProject : UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.viewState.rows.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch self.viewState.rows[indexPath.row] {
		case is ViewState.SelectName      :
			let data = self.viewState.rows[indexPath.row] as! ViewState.SelectName
			let cell = tableView.dequeueReusableCell(withIdentifier: SelectNameCell.reuseId,  for: indexPath) as! SelectNameCell
			cell.configure(with: data)
			return cell
		case is ViewState.SelectImages    :
			let data = self.viewState.rows[indexPath.row] as! ViewState.SelectImages
			let cell = tableView.dequeueReusableCell(withIdentifier: SelectImageCell.reuseId, for: indexPath) as! SelectImageCell
			cell.configure(with: data)
			return cell
		case is ViewState.SelectCounter   :
			let data = self.viewState.rows[indexPath.row] as! ViewState.SelectCounter
			let cell = tableView.dequeueReusableCell(withIdentifier: SwitcherCell.reuseId,    for: indexPath) as! SwitcherCell
			cell.configure(with: data)
			return cell
		case is ViewState.MainButton      :
			let data = self.viewState.rows[indexPath.row] as! ViewState.MainButton
			let cell = tableView.dequeueReusableCell(withIdentifier: MainButtonCell.reuseId,  for: indexPath) as! MainButtonCell
			cell.configure(with: data)
			return cell
		case is ViewState.BecomePro       :
			let data = self.viewState.rows[indexPath.row] as! ViewState.BecomePro
			let cell = tableView.dequeueReusableCell(withIdentifier: BecomeProCell.reuseId,   for: indexPath) as! BecomeProCell
			cell.configure(with: data)
			return cell
		default:
			return UITableViewCell()
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
	}
}

// MARK: - Saving and DB issues
extension PanProject {
	
	func saveProject() {
		let imgStr = "_" + String(currentImage)
		let projectUniqueID = Int(Date().timeIntervalSince1970)
		if currentName == "" {
			currentName = "Unnamed"
		}
		let project = MProject(userID: user.uid, name: currentName, image: imgStr, date: "\(projectUniqueID)")
		let referenceForProject = self.ref.child("projects").child("\(projectUniqueID)")
		referenceForProject.setValue(project.projectToDictionary())
		if currentSwitch {
			let counter = MCounter(name: currentName, rows: 0, rowsMax: -1, date: "999999999")
			let referenceForCounter = self.ref.child("projects").child("\(projectUniqueID)").child("counters").child("\(currentName)")
			referenceForCounter.setValue(counter.counterToDictionary())
		}
		AnalyticsService.reportEvent(with: "New project", parameters: ["name" : project.name])
		self.dismiss(animated: true, completion: nil)
	}
	
	func editProject() {
		let imgStr = "_" + String(currentImage)
		if currentName == "" { currentName = "Unnamed" }
		guard let project = self.currentProject, let referenceForProject = self.currentProject?.ref else { return }
		referenceForProject.updateChildValues(["name"  : self.currentName,
											   "image" : imgStr,
											   "date"  : project.date])
		AnalyticsService.reportEvent(with: "Edit project", parameters: ["name" : currentName])
		self.dismiss(animated: true, completion: nil)
	}
}
