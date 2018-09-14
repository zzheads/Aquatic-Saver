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
    case socketObjects(key: SocketObserver.WebSocketObject, json: [JSON])
    case socketUnknown(message: String?)
    
    static var userLoggedName = Notification.Name("user logged")
    static var getDevicesName = Notification.Name("get devices")
    static var socketObjectsName = Notification.Name("socket got objects")
    static var socketUnknownName = Notification.Name("socket got unknown")
    
    var name: Notification.Name {
        switch self {
        case .userLogged(_)         : return AppNotification.userLoggedName
        case .getDevices(_)         : return AppNotification.getDevicesName
        case .socketObjects(_)      : return AppNotification.socketObjectsName
        case .socketUnknown(_)      : return AppNotification.socketUnknownName
        }
    }
    
    var notification: Notification {
        switch self {
        case .userLogged(let user)              : return Notification(name: name, object: user, userInfo: ["email": user.email, "password": user.password as Any])
        case .getDevices(let devices)           : return Notification(name: name, object: devices, userInfo: ["devices": devices])
        case .socketObjects(let key, let json)  : return Notification(name: name, object: json, userInfo: ["key": key, "json": json])
        case .socketUnknown(let message)        : return Notification(name: name, object: message, userInfo: ["message": message as Any])
        }
    }
}
