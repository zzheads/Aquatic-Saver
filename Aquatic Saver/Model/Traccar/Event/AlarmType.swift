//
//  AlarmType.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 22.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Foundation

enum AlarmType: String, Codable {
    case overspeed
    case lowBattery
    case sos
    case shock
    case powerCut
}
