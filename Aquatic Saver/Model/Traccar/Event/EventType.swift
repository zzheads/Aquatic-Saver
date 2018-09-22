//
//  EventType.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 17.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Foundation

enum EventType: String, Codable {
    case alarm
    case deviceOnline
    case deviceOffline
    case deviceStopped
    case deviceMoving
    case deviceUnknown
    case geofenceEnter
    case geofenceExit
}
