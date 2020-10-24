//
//  WatchManager.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 24.10.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchManager: NSObject {
	
	static let shared: WatchManager = WatchManager()
	
	fileprivate var watchSession: WCSession?
	
	override init() {
		super.init()
		if (!WCSession.isSupported()) {
			watchSession = nil
			return
		}
		watchSession = WCSession.default
		watchSession?.delegate = self
		watchSession?.activate()
	}
	
	func sendParamsToWatch(dict: [String: Any]) {
		do {
			try watchSession?.updateApplicationContext(dict)
		} catch {
			print("Error sending dictionary \(dict) to your Apple Watch")
		}
	}
}

extension WatchManager: WCSessionDelegate {
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		print("activationDidCompleteWith")
	}
	
	func sessionDidBecomeInactive(_ session: WCSession) {
		print("sessionDidBecomeInactive")

	}
	
	func sessionDidDeactivate(_ session: WCSession) {
		print("sessionDidDeactivate")
	}
}
