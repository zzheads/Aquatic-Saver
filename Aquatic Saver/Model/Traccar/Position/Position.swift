//
//  Position.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 06.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Foundation
import CoreLocation

struct Position: Codable {
    var id          : Int?
    var attributes  : Attributes?
    var latitude    : Double?
    var longitude   : Double?
    var deviceId    : Int?
    var altitude    : Double?
    var deviceTime  : String?
    var fixTime     : String?
    var outdated    : Bool?
    var `protocol`  : String?
    var serverTime  : String?
    var speed       : Double?
    var valid       : Bool?
    var accuracy    : Double?
    var address     : String?
    var course      : Double?
    var type        : String?
    var network     : Network?
}

extension Position: Extensible {
    typealias Object = Position
    
    static func last() -> Resource<Position> {
        return Resource(endpoint: "positions", method: .get)
    }
}

extension Array where Element == Position {
    func getPositions(for device: Device?) -> [Position] {
        guard let device = device else {
            return []
        }
        return self.filter({$0.deviceId == device.id})
    }
}

extension Position {
    var coordinate: CLLocationCoordinate2D? {
        guard
            let latitude = self.latitude,
            let longitude = self.longitude
            else {
                return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var onMapDescription: String {
        var description = ""
        if let deviceTime = self.deviceTime {
            let components = deviceTime.components(separatedBy: "T")
            if components.count == 2 {
                description += "дата: \(components[0])\nвремя: \(components[1])\n"
            }
        }
        if let address = self.address {
            description += "адрес: \(address)\n"
        }
        return description
    }    
}


