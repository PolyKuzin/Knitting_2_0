//
//  Analytics.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 03.01.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import Foundation
import YandexMobileMetrica

class AnalyticsService {
	
	let apiKey = "710ec4a5-8503-4371-a935-2825ec321888"
	
	//MARK: - Report just Name
	static public func reportEvent(with name: String) {
		YMMYandexMetrica.reportEvent(name, onFailure: { (error) in
			debugPrint("REPORT ERROR: %@", error.localizedDescription)
		})
	}
	
	//MARK: - Report with Parameters
	static public func reportEvent(with name: String, parameters: [String: Any]) {
		YMMYandexMetrica.reportEvent(name, parameters: parameters, onFailure: { (error) in
			debugPrint("REPORT ERROR: %@", error.localizedDescription)
		})
	}

	//MARK: - Report Error
	static public func reportError(with identifier: String, message: String = "", parameters: [String: Any] = [:]) {
		let error = YMMError(
			identifier: identifier,
			message: message,
			parameters: parameters,
			backtrace: Thread.callStackReturnAddresses,
			underlyingError: nil)
		YMMYandexMetrica.report(error: error, onFailure: nil)
	}
}
