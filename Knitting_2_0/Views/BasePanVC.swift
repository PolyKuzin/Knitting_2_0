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
	
	var onPurchaise : (()->()) = {
		let iap_manager = IAPManager.shared
		let identifire = iap_manager.products.filter({
			$0.productIdentifier == IAPProducts.autoRenew.rawValue
		}).first?.productIdentifier
		iap_manager.purchase(productWith: identifire!)
	}
		
	var onPrivacy : (()->()) = {
		print("PRIVACY")
	}
	
	var onRestore : (()->()) = {
		let iap_manager = IAPManager.shared
		iap_manager.restoreCompletedTransactions()
	}
	
	var onTerms   : (()->()) = {
		print("TERMS")
	}
	
	public func getColor() -> UIColor {
		return UIColor(red: 0.745, green: 0.616, blue: 0.875, alpha: 1)
	}

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
