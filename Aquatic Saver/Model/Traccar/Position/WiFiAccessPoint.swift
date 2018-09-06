//
//  WiFiAccessPoint.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 06.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Foundation

struct WiFiAccessPoint: Codable {
    var macAddress      : String?
    var signalStrength  : Int?
}
