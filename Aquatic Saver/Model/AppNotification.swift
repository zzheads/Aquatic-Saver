//
//  AppNotification.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 31.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Foundation

enum AppNotification {
    case userLogged(user: User)
    case getDevices(devices: [Device])
    
    var name: Notification.Name {
        switch self {
        case .userLogged(_) : return Notification.Name("user logged")
        case .getDevices(_) : return Notification.Name("get devices")
        }
    }
    
    var notification: Notification {
        switch self {
        case .userLogged(let user)      : return Notification(name: name, object: user, userInfo: ["email": user.email, "password": user.password as Any])
        case .getDevices(let devices)   : return Notification(name: name, object: devices, userInfo: ["devices": devices])
        }
    }
}
