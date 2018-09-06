//
//  CellTower.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 06.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Foundation

struct CellTower: Codable {
    var cellId              : Int?
    var locationAreaCode    : Int?
    var mobileCountryCode   : Int?
    var mobileNetworkCode   : Int?
    var signalStrength      : Int?
}
