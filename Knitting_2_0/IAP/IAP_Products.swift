//
//  IAP_Products.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 29.03.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import StoreKit
import Foundation

enum IAPProducts : String {
	case autoRenew    = "KnittingMonth"
}

extension SKProduct {

	private static let formatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		return formatter
	}()

	var isFree: Bool {
		price == 0.00
	}

	var localizedPrice: String? {
		guard !isFree else {
			return nil
		}
		
		let formatter = SKProduct.formatter
		formatter.locale = priceLocale

		return formatter.string(from: price)
	}
}
