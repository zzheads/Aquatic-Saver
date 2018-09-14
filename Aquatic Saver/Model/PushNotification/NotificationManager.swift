//
//  NotificationManager.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 13.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class NotificationsManager: NSObject, UNUserNotificationCenterDelegate {
    static let `default` = NotificationsManager(UNUserNotificationCenter.current())
    let center : UNUserNotificationCenter
    var application: UIApplication?
    
    let okAction = UNNotificationAction(identifier: "Ok", title: "Ok", options: .foreground)
    let cancelAction = UNNotificationAction(identifier: "Cancel", title: "Cancel", options: [])
    lazy var category: UNNotificationCategory = {
        return UNNotificationCategory(identifier: "Actions", actions: [self.okAction, self.cancelAction], intentIdentifiers: [], options: [])
    }()
    
    init(_ center: UNUserNotificationCenter) {
        self.center = center
        super.init()
    }
    
    public func register(application: UIApplication) {
        self.application = application
        self.center.delegate = self
        self.center.setNotificationCategories([self.category])
        self.center.requestAuthorization(options: [.badge, .sound, .alert]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else {
                print("Can't register app for Notifications, error: \(error?.localizedDescription ?? "unknown")")
            }
        }
    }
}
