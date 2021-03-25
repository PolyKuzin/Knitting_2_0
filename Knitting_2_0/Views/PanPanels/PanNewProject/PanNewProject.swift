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
	var image      : UIImage
	var isSelected : Bool
}

class PanNewProject: BasePanVC, PanModalPresentable {
	
	var panScrollable: UIScrollView? {
		return self.tableView
	}
	
	var longFormHeight: PanModalHeight {
		return .maxHeight
	}
	
	private var currentImage = 0 {
		didSet {
			print(currentImage)
		}
	}

	private var currentName = "" {
		didSet {
			print(currentName)
		}
	}
	
	private var currentCounter = true {
		didSet {
			print(currentCounter)
		}
	}
	
	@IBOutlet weak var tableView : UITableView!
	
	struct ViewState {
		
		var rows : [Any]
		
		struct SelectImages                   {
			var items          : [Item]
			var currentImage   : Int
			var selectImage    : ((Int)->())
		}
		
		struct SelectName                     {
			var name           : String
			var selectName     : ((String)->())
		}
		
		struct SelectCounter                  {
			var onSwitch       : ((Bool)->())
		}
		
		struct SelectNotifications            {
			var question       : String
			var days           : [Int]
		}
		
		struct BecomePro       : _BecomePro   {
			var onBecomePro    : (()->())
		}
		
		struct IAP_RequiredBtn : IAP_Required {
			var privacy        : (() -> ())
			var restore        : (() -> ())
			var terms          : (() -> ())
		}
		
		struct MainButton      : _MainButton  {
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
		self.makeStandartState()
		self.title = "Create new counter".localized()
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.separatorStyle = .none
		self.tableView.register(UINib(nibName: "BecomeProCell", bundle: nil), forCellReuseIdentifier: "BecomeProCell")
		self.tableView.register(UINib(nibName: "MainButtonCell", bundle: nil), forCellReuseIdentifier: "MainButtonCell")
		self.tableView.register(UINib(nibName: "SelectNameCell", bundle: nil), forCellReuseIdentifier: "SelectNameCell")
		self.tableView.register(UINib(nibName: "SelectImageCell", bundle: nil), forCellReuseIdentifier: "SelectImageCell")
		self.tableView.register(UINib(nibName: "IAP_RequiredCell", bundle: nil), forCellReuseIdentifier: "IAP_RequiredCell")
		self.tableView.register(UINib(nibName: "CreateCounterCell", bundle: nil), forCellReuseIdentifier: "CreateCounterCell")
    }
	
	private func createItems() -> [Item] {
		let item0 = Item(image: UIImage(named: "_0")!, isSelected: true)
		let item1 = Item(image: UIImage(named: "_1")!, isSelected: false)
		let item2 = Item(image: UIImage(named: "_2")!, isSelected: false)
		let item3 = Item(image: UIImage(named: "_3")!, isSelected: false)
		let item4 = Item(image: UIImage(named: "_4")!, isSelected: false)
		let item5 = Item(image: UIImage(named: "_5")!, isSelected: false)
		let item6 = Item(image: UIImage(named: "_6")!, isSelected: false)
		return [item0, item1, item2, item3, item4, item5, item6]
	}
	
	private func makeStandartState() {
		let imageClosure   : ((Int)->())    = { [weak self] result in
			guard self != nil else { return }
			self?.currentImage   = result
		}
		let nameClosure    : ((String)->()) = { [weak self] result in
			guard self != nil else { return }
			self?.currentName    = result
		}
		let coгnterClosure : ((Bool)->())   = { [weak self] result in
			guard self != nil else { return }
			self?.currentCounter = result
		}
		let selectImage   = ViewState.SelectImages    (items       : createItems(), currentImage: 0, selectImage: imageClosure)
		let selectName    = ViewState.SelectName      (name        : "",            selectName: nameClosure)
		let selectCounter = ViewState.SelectCounter   (onSwitch    : coгnterClosure)
		let mainButton    = ViewState.MainButton      (title       : "+ Create project".localized(), onTap: self.createProject, color: getColor())
		let becomePro     = ViewState.BecomePro       (onBecomePro : self.becomePro)
		let iap_required  = ViewState.IAP_RequiredBtn (privacy     : self.onPrivacy, restore: self.onRestore, terms: self.onTerms)
		self.viewState.rows.append(contentsOf: [selectImage, selectName, selectCounter, mainButton, becomePro, iap_required])
	}
	
	private func createProject() {
		print("CREATED")
	}
}

extension PanNewProject : UITableViewDelegate {
	
}

extension PanNewProject : UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.viewState.rows.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch self.viewState.rows[indexPath.row] {
		case is ViewState.SelectName      :
			let data = self.viewState.rows[indexPath.row] as! ViewState.SelectName
			let cell = tableView.dequeueReusableCell(withIdentifier: "SelectNameCell", for: indexPath) as! SelectNameCell
			cell.configure(with: data)
			return cell
			
		case is ViewState.SelectImages    :
			let data = self.viewState.rows[indexPath.row] as! ViewState.SelectImages
			let cell = tableView.dequeueReusableCell(withIdentifier: "SelectImageCell", for: indexPath) as! SelectImageCell
			cell.configure(with: data)
			return cell
			
		case is ViewState.SelectCounter   :
			let data = self.viewState.rows[indexPath.row] as! ViewState.SelectCounter
			let cell = tableView.dequeueReusableCell(withIdentifier: "CreateCounterCell", for: indexPath) as! CreateCounterCell
			cell.configure(with: data)
			return cell
			
		case is ViewState.MainButton      :
			let data = self.viewState.rows[indexPath.row] as! ViewState.MainButton
			let cell = tableView.dequeueReusableCell(withIdentifier: "MainButtonCell", for: indexPath) as! MainButtonCell
			cell.configure(with: data)
			return cell
			
		case is ViewState.BecomePro       :
			let data = self.viewState.rows[indexPath.row] as! ViewState.BecomePro
			let cell = tableView.dequeueReusableCell(withIdentifier: "BecomeProCell", for: indexPath) as! BecomeProCell
			cell.configure(with: data)
			return cell
			
		case is ViewState.IAP_RequiredBtn :
			let data = self.viewState.rows[indexPath.row] as! ViewState.IAP_RequiredBtn
			let cell = tableView.dequeueReusableCell(withIdentifier: "IAP_RequiredCell", for: indexPath) as! IAP_RequiredCell
			cell.configure(data: data)
			return cell
			
		default:
			return UITableViewCell()
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
	}
}
