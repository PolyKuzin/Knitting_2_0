//
//  BasePanVC.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 23.01.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UIKit
import PanModal

class BasePanVC : BaseVC {
	
	public func getButtonColor() -> UIColor {
		return UIColor(red: 0.745, green: 0.616, blue: 0.875, alpha: 1)
	}
	
	public func getImage(_ str: String) -> Int {
		switch str {
		case "_1":
			return 1
		case "_2":
			return 2
		case "_3":
			return 3
		case "_4":
			return 4
		case "_5":
			return 5
		case "_6":
			return 6
		default:
			return 0
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(selfDismiss),
											   name: NSNotification.Name(IAPProducts.autoRenew.rawValue), object: nil)
    }
	
	@objc
	public func selfDismiss() {
		self.dismiss(animated: true, completion: nil)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
}

extension BasePanVC {
	
	public func purchaise() {
		let iap_manager = IAPManager.shared
		guard let identifire = iap_manager.products.filter({
			$0.productIdentifier == IAPProducts.autoRenew.rawValue
		}).first?.productIdentifier else { return }
		iap_manager.purchase(productWith: identifire)
	}
	
	public func onRestore() {
		let iap_manager = IAPManager.shared
		iap_manager.restoreCompletedTransactions()
	}
	
	public func onPrivacy() {
		self.openWeb(link: "https://github.com/PolyKuzin/Knit-it-Privacy-Policy/blob/main/PrivacyPolicy.md")
	}
	
	public func onTerms() {
		self.openWeb(link: "https://github.com/PolyKuzin/Knit-it-Privacy-Policy/blob/main/Terms%26Conditions.md")
	}
}
