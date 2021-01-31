//
//  NotificationService.swift
//  KnitNotifications
//
//  Created by Павел Кузин on 17.01.2021.
//  Copyright © 2021 Павел Кузин. All rights reserved.
//

import UserNotifications
import YandexMobileMetricaPush

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
		if let bestAttemptContent = bestAttemptContent {
			YMPYandexMetricaPush.setExtensionAppGroup("group.ru.polykuzin.Knitting-2-0")
			YMPYandexMetricaPush.handleDidReceive(request)
			contentHandler(bestAttemptContent)
		}
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
