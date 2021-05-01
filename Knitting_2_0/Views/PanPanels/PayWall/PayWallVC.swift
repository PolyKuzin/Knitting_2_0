//
//  PayWallVC.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 28.04.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit
import PanModal

class PayWallVC : BasePanVC, PanModalPresentable {
	
	var panScrollable: UIScrollView? {
		return tableView
	}
	
	var longFormHeight: PanModalHeight {
		return .maxHeight
	}
	
	@IBOutlet weak var tableView : UITableView!
	
	struct ViewState {
		
		var rows : [Any]
		
		struct Benefit          : _Benefit     {
			var text           : String
			var image          : UIImage
		}
		
		struct IAP_Pricing      : _IAP_PricingCell {
			var title          : String
		}
		
		struct BecomePro        : _BecomePro   {
			var image          : UIImage?
			var title          : String
			var color          : UIColor?
			var onBecomePro    : (()->())
		}

		struct IAP_RequiredBtn  : IAP_Required {
			var privacy        : (() -> ())
			var restore        : (() -> ())
			var terms          : (() -> ())
		}
		
		static let initial = ViewState(rows: [])
	}
	
	public var viewState : ViewState = .initial {
		didSet {
			tableView.reloadData()
		}
	}

	fileprivate func setupNavigationItem() {
		let wrapperView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 90))
		let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 90))
		label.backgroundColor = .clear
		label.numberOfLines = 2
		label.textAlignment = .center
		label.textColor = .black
		label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
		label.text = "Become a PRO Knitter \nwith Premium".localized()
		wrapperView.addSubview(label)
		self.navigationItem.titleView = wrapperView
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupNavigationItem()

		self.makeState()
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.register(UINib(nibName: "BenefitCell",      bundle: nil), forCellReuseIdentifier: BenefitCell.reuseID)
		self.tableView.register(UINib(nibName: "BecomeProCell",    bundle: nil), forCellReuseIdentifier: BecomeProCell.reuseID)
		self.tableView.register(UINib(nibName: "IAP_PricingCell",  bundle: nil), forCellReuseIdentifier: IAP_PricingCell.reuseID)
		self.tableView.register(UINib(nibName: "IAP_RequiredCell", bundle: nil), forCellReuseIdentifier: IAP_RequiredCell.reuseID)
    }
	
	private func makeState() {

		let benefit1 = ViewState.Benefit(text: "Create unlimited projects and counters", image: UIImage(named: "Infinity")!)
		let benefit2 = ViewState.Benefit(text: "Beautiful project icons",                image: UIImage(named: "Squares")!)
		let benefit3 = ViewState.Benefit(text: "Different color themes + dark theme",    image: UIImage(named: "Colors")!)
		let benefit4 = ViewState.Benefit(text: "Cancel any time",                        image: UIImage(named: "Check")!)
		
		let becomePro : (()->()) = { [weak self] in
			guard let self = self else { return }
			self.onPurchaise()
		}
		let pricing   = ViewState.IAP_Pricing(title: "Try 7-days free trial, then 3.99$/mounth".localized())
		let subscribe = ViewState.BecomePro(title: "Subscribe".localized(), color: UIColor(red: 0.552, green: 0.325, blue: 0.779, alpha: 1), onBecomePro: becomePro)
		let iap_required = ViewState.IAP_RequiredBtn(privacy: self.onPrivacy, restore: self.onRestore, terms: self.onTerms)
		self.viewState.rows = [benefit1, benefit2, benefit3, benefit4, pricing, subscribe, iap_required]
	}
}

// MARK: - TableView Delegate
extension PayWallVC : UITableViewDelegate { }

// MARK: - TableView DataSource
extension PayWallVC : UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.viewState.rows.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch self.viewState.rows[indexPath.row] {
		case is ViewState.Benefit         :
			let data = viewState.rows[indexPath.row] as! ViewState.Benefit
			let cell = tableView.dequeueReusableCell(withIdentifier: "BenefitCell",      for: indexPath) as! BenefitCell
			cell.configure(with: data)
			return cell
		case is ViewState.IAP_Pricing     :
			let data = viewState.rows[indexPath.row] as! ViewState.IAP_Pricing
			let cell = tableView.dequeueReusableCell(withIdentifier: "IAP_PricingCell",  for: indexPath) as! IAP_PricingCell
			cell.configure(with: data)
			return cell
		case is ViewState.BecomePro       :
			let data = viewState.rows[indexPath.row] as! ViewState.BecomePro
			let cell = tableView.dequeueReusableCell(withIdentifier: "BecomeProCell",    for: indexPath) as! BecomeProCell
			cell.configure(with: data)
			return cell
		case is ViewState.IAP_RequiredBtn :
			let data = viewState.rows[indexPath.row] as! ViewState.IAP_RequiredBtn
			let cell = tableView.dequeueReusableCell(withIdentifier: "IAP_RequiredCell", for: indexPath) as! IAP_RequiredCell
			cell.configure(with: data)
			return cell
		default:
			return UITableViewCell()
		}
	}
}
