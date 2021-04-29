//
//  IAP_Manager.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 29.03.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import StoreKit
import Foundation

class IAPManager : NSObject {
	
	static let shared = IAPManager()
	private override init() {}
	
	var products : [SKProduct] = []
	let paymentQueue = SKPaymentQueue.default()
	
	public func setupPurchases(callback: @escaping(Bool) -> ()) {
		if SKPaymentQueue.canMakePayments() {
			paymentQueue.add(self)
			callback(true)
			return
		}
		callback(false)
	}
	
	public func getProducts() {
		let identifiers : Set = [
			IAPProducts.autoRenew.rawValue
		]
		let productRequest = SKProductsRequest(productIdentifiers: identifiers)
		productRequest.delegate = self
		productRequest.start()
	}
	
	public func purchase(productWith identifier : String) {
		guard let product = products.filter({$0.productIdentifier == identifier}).first else { return }
		let payment = SKPayment(product: product)
		paymentQueue.add(payment)
	}
	
	public func restoreCompletedTransactions() {
		let refresh = SKReceiptRefreshRequest()
		refresh.delegate = self
		refresh.start()
		paymentQueue.restoreCompletedTransactions()
	}
}

extension IAPManager : SKPaymentTransactionObserver {
	
	func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
		for transaction in transactions {
			switch transaction.transactionState {
			case .deferred   : break
			case .purchasing : showUniversalLoadingView(true, loadingText: "Waitng for Validation ^_^")
			case .failed     : failed    (transaction)
			case .purchased  : completed (transaction)
			case .restored   : restored  (transaction)
			@unknown default:
				fatalError()
			}
		}
		showUniversalLoadingView(false)
	}
	
	private func failed(_ transaction: SKPaymentTransaction) {
		if let transactionError = transaction.error as NSError? {
			if transactionError.code != SKError.paymentCancelled.rawValue {
				print("Transaction Errror: \(transaction.error!.localizedDescription)")
			}
		}
		paymentQueue.finishTransaction(transaction)
	}
	
	private func completed(_ transaction: SKPaymentTransaction) {
		let reciptValidator = ReceiptValidator()
		let result = reciptValidator.validateReceipt()
		
		switch result {
		case let .success(reciept):
			guard let purchase = reciept.inAppPurchaseReceipts?.filter({$0.productIdentifier == IAPProducts.autoRenew.rawValue}).first else {
				NotificationCenter.default.post(name: NSNotification.Name(transaction.payment.productIdentifier), object: nil)
				paymentQueue.finishTransaction(transaction)
				return
			}
			if purchase.subscriptionExpirationDate?.compare(Date()) == .some(.orderedDescending) {
				AnalyticsService.reportEvent(with: "Purchase", parameters: ["data" : purchase.purchaseDate ?? "0000000"])
				NotificationCenter.default.post(name: NSNotification.Name(transaction.payment.productIdentifier), object: nil)
				UserDefaults.standard.setValue(true, forKey: "setProVersion")
			} else {
				AnalyticsService.reportEvent(with: "Purchase", parameters: ["data" : purchase.purchaseDate ?? "0000000"])
				NotificationCenter.default.post(name: NSNotification.Name(transaction.payment.productIdentifier), object: nil)
				UserDefaults.standard.setValue(false, forKey: "setProVersion")
			}
			return
		case let .error(error):
			print(error.localizedDescription)
		}
		paymentQueue.finishTransaction(transaction)
	}
	
	private func restored(_ transaction: SKPaymentTransaction) {
		paymentQueue.finishTransaction(transaction)
		NotificationCenter.default.post(name: NSNotification.Name(transaction.payment.productIdentifier), object: nil)
		paymentQueue.finishTransaction(transaction)
		UserDefaults.standard.setValue(true, forKey: "setProVersion")
	}
}

extension IAPManager : SKProductsRequestDelegate {
	
	func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
		self.products = response.products
		products.forEach {
			print("""
				  ###########
				  ###########
				  ###########
				  \($0.localizedTitle)
				  """)
		}
	}
}
