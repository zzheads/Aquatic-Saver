//
//  Attributes.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 31.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Foundation

class Attributes: Codable {
    var modified        : String?
    var sat             : Int?
    var rssi            : Int?
    var steps           : Double?
    var ip              : String?
    var distance        : Double?
    var totalDistance   : Double?
    var battery         : Int?
    var photoURL        : String?
}
