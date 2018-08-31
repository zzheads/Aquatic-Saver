//
//  Device.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 31.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Foundation

class Device: Codable {
    var id              : Int?
    var attributes      : DeviceAttributes?
    var name            : String?
    var phone           : String?
    var uniqueId        : String?
    var category        : String?
    var contact         : String?
    var geofenceIds     : [Int]?
    var groupId         : Int?
    var lastUpdate      : String?
    var model           : String?
    var positionId      : Int?
    var photo           : Data?
}

extension Device: Extensible {
    typealias Object = Device
}

extension Device {
    static func getAll() -> Resource<Device> {
        return Resource(endpoint: "devices", method: .get)
    }
    
    static func getBy(id: Int) -> Resource<Device> {
        return Resource(endpoint: "devices/\(id)", method: .get)
    }
}
