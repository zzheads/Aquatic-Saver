//
//  AppDelegate.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 27.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return GMSServices.provideAPIKey("AIzaSyDIHNZUUeiUeA-Ll3njbI0bHczM8oIYsqE")
    }
}

