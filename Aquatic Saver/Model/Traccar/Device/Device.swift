//
//  Device.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 31.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Alamofire
import GoogleMaps

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
    
    static func add(imei: String, phone: String, name: String) -> Resource<Device> {
        return Resource(endpoint: "devices", method: .post, parameters: ["uniqueId": imei, "phone": phone, "name": name], encoding: JSONEncoding.default)
    }
    
    static func update(_ device: Device) -> Resource<Device>? {
        guard let id = device.id, let parameters = device.toJSON else { return nil }
        return Resource(endpoint: "devices/\(id)", method: .put, parameters: parameters, encoding: JSONEncoding.default)
    }
    
    static func delete(_ id: Int) -> Resource<Device?> {
        return Resource(endpoint: "devices/\(id)", method: .delete)
    }
}

extension Device {
    var onMapDescription: String {
        var description = ""
        if let phone = self.phone {
            description += "номер: \(phone)\n"
        }
        if let model = self.model {
            description += "модель: \(model)\n"
        }
        if let uniqueId = self.uniqueId {
            description += "id: \(uniqueId)\n"
        }
        description = "\(String(description.dropLast(1)))"
        return description
    }
    
    func marker(at coordinate: CLLocationCoordinate2D) -> GMSMarker {
        let marker = GMSMarker(position: coordinate)
        marker.title = self.name
        marker.snippet = self.onMapDescription
        return marker
    }
}
