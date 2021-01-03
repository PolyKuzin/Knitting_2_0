//
//  AppDelegate.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 27.08.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit
import FirebaseCore
import YandexMobileMetrica
import StoreKit

var currentCount = UserDefaults.standard.integer(forKey: "launchCount")

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		FirebaseApp.configure()
		let configuration = YMMYandexMetricaConfiguration.init(apiKey: "710ec4a5-8503-4371-a935-2825ec321888")
		YMMYandexMetrica.activate(with: configuration!) 
		UserDefaults.standard.set(currentCount+1, forKey:"launchCount")
		return true
    }
	
	// MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

}

