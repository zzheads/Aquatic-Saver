//
//  PushNotification.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 13.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class PushNotification {
    let uuid    : String
    let title   : String
    let message : String
    
    init(title: String, message: String) {
        self.uuid = UUID().uuidString
        self.title = title
        self.message = message
    }
}

extension PushNotification {
    var timeTrigger: UNTimeIntervalNotificationTrigger {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        return trigger
    }
    
    var content: UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = self.title
        content.body = self.message
        content.categoryIdentifier = "OkAction"
        content.sound = UNNotificationSound.default()
        return content
    }
    
    var request: UNNotificationRequest? {
        let request = UNNotificationRequest(identifier: self.uuid, content: self.content, trigger: self.timeTrigger)
        return request
    }
}

extension PushNotification {
    func push(completionHandler: ((Error?) -> Void)? = nil) {
        guard let request = self.request else {
            print("PushNotification \(self) detected location event, but can not send notification")
            return
        }
        UNUserNotificationCenter.current().add(request, withCompletionHandler: completionHandler)
    }
}
