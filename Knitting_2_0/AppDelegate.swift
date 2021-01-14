//
//  AppDelegate.swift
//  Knitting_2_0
//
//  Created by Павел Кузин on 27.08.2020.
//  Copyright © 2020 Павел Кузин. All rights reserved.
//

import UIKit
import StoreKit
import FirebaseCore
import UserNotifications
import YandexMobileMetrica

//https://apps.apple.com/us/app/knit-it/id1532396965
var currentCount = UserDefaults.standard.integer(forKey: "launchCount")

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	//MARK: - didFinishLaunching
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		FirebaseApp.configure()
		let configuration = YMMYandexMetricaConfiguration.init(apiKey: "710ec4a5-8503-4371-a935-2825ec321888")
		YMMYandexMetrica.activate(with: configuration!) 
		UserDefaults.standard.set(currentCount+1, forKey:"launchCount")
		AnalyticsService.reportEvent(with: "Launch KnitIt")
		requestNotification()
		notificationCenter.delegate = self
		scheduleNotification()
		UIApplication.shared.applicationIconBadgeNumber = 0
		return true
    }
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		UIApplication.shared.applicationIconBadgeNumber = 0
	}
	
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
	
	//MARK: - Notifications
	let notificationCenter = UNUserNotificationCenter.current()
	
	func requestNotification() {
		notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
			guard granted else { return }
			self.getNotificationSettings()
		}
	}
	
	func getNotificationSettings() {
		notificationCenter.getNotificationSettings { (settings) in
			
		}
	}
	
	func scheduleNotification() {
		let content = UNMutableNotificationContent()
		content.title = "Get some time to Knit?".localized()
		content.body  = "How about you spend it on your hobby?".localized()
		content.sound = UNNotificationSound.defaultCritical
		content.badge = 1
		
		var dateComponents = DateComponents()
		dateComponents.hour = 12
		dateComponents.minute = 30
		dateComponents.weekday = 7
		dateComponents.second = 3
		let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,repeats: true)
		let identifire = "RowsAddedNotification"
		let reequest = UNNotificationRequest(identifier: identifire, content: content, trigger: trigger)
		notificationCenter.add(reequest) { (error) in
			if let error = error {
				print("Error \(error.localizedDescription)")
			}
		}
	}
}

extension AppDelegate : UNUserNotificationCenterDelegate {
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		if response.notification.request.identifier == "RowsAddedNotification" {
//			UserDefaults.standard.setValue(0, forKey: "RowsAdded")
		}
		completionHandler()
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler([.alert, .sound])
	}
}
