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
import YandexMobileMetricaPush

var currentCount = UserDefaults.standard.integer(forKey: "launchCount")

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	//MARK: - didFinishLaunching
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let configuration = YMMYandexMetricaConfiguration.init(apiKey: "710ec4a5-8503-4371-a935-2825ec321888")
		YMMYandexMetrica.activate(with: configuration!)
		YMPYandexMetricaPush.setExtensionAppGroup("group.ru.polykuzin.Knitting-2-0")

		notificationCenter.delegate = self
		YMPYandexMetricaPush.userNotificationCenterDelegate().nextDelegate = notificationCenter.delegate

		YMPYandexMetricaPush.handleApplicationDidFinishLaunching(options: launchOptions)
		self.registerForPushNotificationsWithApplication(application)
		
		FirebaseApp.configure()
		UIApplication.shared.applicationIconBadgeNumber = 0
		UserDefaults.standard.set(currentCount+1, forKey:"launchCount")
		AnalyticsService.reportEvent(with: "Launch KnitIt")
		requestNotification()
		let reciptValidator = ReceiptValidator()
		let result = reciptValidator.validateReceipt()
		switch result {
		case let .success(reciept):
			guard let purchase = reciept.inAppPurchaseReceipts?.filter({$0.productIdentifier == IAPProducts.autoRenew.rawValue}).first else { return true }
			if purchase.subscriptionExpirationDate?.compare(Date()) == .some(.orderedDescending) {
				AnalyticsService.reportEvent(with: "Purchase", parameters: ["data" : purchase.purchaseDate ?? "0000000"])
				UserDefaults.standard.setValue(true, forKey: "setPro")
			} else {
				UserDefaults.standard.setValue(false, forKey: "setPro")
			}
		case let .error(error):
			print(error.localizedDescription)
		}
		return true
    }
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		UIApplication.shared.applicationIconBadgeNumber = 0
	}
	
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
	
	func registerForPushNotificationsWithApplication(_ application: UIApplication)
	{
		// Register for push notifications
		if #available(iOS 8.0, *) {
			if #available(iOS 10.0, *) {
				// iOS 10.0 and above
				let center = UNUserNotificationCenter.current()
				let category = UNNotificationCategory(identifier: "Custom category",
													  actions: [],
													  intentIdentifiers: [],
													  options:UNNotificationCategoryOptions.customDismissAction)
				// Only for push notifications of this category dismiss action will be tracked.
				center.setNotificationCategories(Set([category]))
				center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
					// Enable or disable features based on authorization.
				}
			} else {
				// iOS 8 and iOS 9
				let settings = UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil)
				application.registerUserNotificationSettings(settings)
			}
			application.registerForRemoteNotifications()
		} else {
			// iOS 7
			application.registerForRemoteNotifications(matching: [.badge, .alert, .sound])
		}
	}

	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
	{
		// Send device token and APNs environment(based on default build configuration) to AppMetrica Push server.
		// Method YMMYandexMetrica.activate has to be called before using this method.
#if DEBUG
		let pushEnvironment = YMPYandexMetricaPushEnvironment.development
#else
		let pushEnvironment = YMPYandexMetricaPushEnvironment.production
#endif
		YMPYandexMetricaPush.setDeviceTokenFrom(deviceToken, pushEnvironment: pushEnvironment)
	}

	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any])
	{
		self.handlePushNotification(userInfo)
	}

	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
	{
		self.handlePushNotification(userInfo)
		completionHandler(.newData)
	}

	func handlePushNotification(_ userInfo: [AnyHashable : Any])
	{
		// Track received remote notification.
		// Method YMMYandexMetrica.activate should be called before using this method.
		YMPYandexMetricaPush.handleRemoteNotification(userInfo)

		// Check if notification is related to AppMetrica (optionally)
		if YMPYandexMetricaPush.isNotificationRelated(toSDK: userInfo) {
			// Get user data from remote notification.
			let userData = YMPYandexMetricaPush.userData(forNotification: userInfo)
			print("User Data: %@", userData?.description ?? "[no data]")
		} else {
			print("Push is not related to AppMetrica")
		}
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
