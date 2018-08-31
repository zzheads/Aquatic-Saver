//
//  NotificationsSettings.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 31.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Foundation

class NotificationsSettings: Codable {
    var deviceLowBattery        : Bool = false
    var deviceOffline           : Bool = false
    var deviceOnline            : Bool = false
    var deviceStartMoving       : Bool = false
    var deviceStopped           : Bool = false
    var deviceUnknown           : Bool = false
    var enteredGeofence         : Bool = false
    var exitGeofence            : Bool = false
    var watchRemovedFromHand    : Bool = false
}
