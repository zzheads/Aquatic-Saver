//
//  AppDelegate.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 27.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit
import GoogleMaps
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let googleMapsAPIKey = "AIzaSyCbWP5YpdXpeFyItQIgcHPV1mf93KynJLA"
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        NotificationsManager.default.register(application: application)
        SocketObserver.default.start()
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().keyboardDistanceFromTextField = 50
        return GMSServices.provideAPIKey(self.googleMapsAPIKey)
    }
}

extension AppDelegate: ObjectsObservable {
    func socketDidReceived(_ events: [Event]) {
        for event in events {
            guard let type = event.type else { continue }
            switch type {
            case .alarm     :
                guard let alarmType = event.attributes?.alarm else { continue }
                if alarmType == .sos {
                    PushNotification(title: "SOS", message: "\(event.serverTime?.localDate ?? ""): Device (id: \(event.deviceId ?? -1)) reporting SOS signal!\n Coordinates are in position: \(event.positionId ?? -1)").push()
                }
                
            default                     : break
            }
        }
    }
}
