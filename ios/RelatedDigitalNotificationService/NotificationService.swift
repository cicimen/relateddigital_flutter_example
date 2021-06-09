//
//  NotificationService.swift
//  RelatedDigitalNotificationService
//
//  Created by Egemen Gulkilik on 3.05.2021.
//

import UserNotifications
import Euromsg

class NotificationService: UNNotificationServiceExtension {

        var contentHandler: ((UNNotificationContent) -> Void)?
        var bestAttemptContent: UNMutableNotificationContent?

        override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
                self.contentHandler = contentHandler
                bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
            Euromsg.didReceive(bestAttemptContent, withContentHandler: contentHandler)
        }
        
        override func serviceExtensionTimeWillExpire() {
                if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
                    Euromsg.didReceive(bestAttemptContent, withContentHandler: contentHandler)
                }
        }

}
