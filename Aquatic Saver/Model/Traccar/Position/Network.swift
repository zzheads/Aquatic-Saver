//
//  Network.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 06.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Foundation

struct Network: Codable {
    var radioType           : String?
    var considerIp          : Bool?
    var cellTowers          : [CellTower]?
    var wifiAccessPoints    : [WiFiAccessPoint]?
}
