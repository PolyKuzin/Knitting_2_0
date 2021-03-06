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
