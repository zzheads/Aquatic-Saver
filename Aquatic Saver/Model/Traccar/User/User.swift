//
//  User.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 31.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Alamofire

class User: Codable {
    var id                  : Int?
    var attributes          : UserAttributes?
    var name                : String
    var email               : String
    var password            : String?
    var administrator       : Bool?
    var coordinateFormat    : String?
    var deviceLimit         : Int?
    var disabled            : Bool?
    var distanceUnit        : String?
    var expirationTime      : String?
    var latitude            : Double?
    var longitude           : Double?
    var map                 : String?
    var readonly            : Bool?
    var speedUnit           : String?
    var token               : String?
    var twelveHourFormat    : Bool?
    var zoom                : Int?
    var photo               : Data?
    var phone               : String?
    
    init(id: Int? = nil, attributes: UserAttributes? = nil, name: String = "", email: String = "", password: String? = nil, administrator: Bool? = nil, coordinateFormat: String? = nil, deviceLimit: Int? = nil, disabled: Bool? = nil, distanceUnit: String? = nil, expirationTime: String? = nil, latitude: Double? = nil, longitude: Double? = nil, map: String? = nil, readonly: Bool? = nil, speedUnit: String? = nil, token: String? = nil, twelveHourFormat: Bool? = nil, zoom: Int? = nil, photo: Data? = nil, phone: String? = nil) {
        self.id = id
        self.attributes = attributes
        self.name = name
        self.email = email
        self.password = password
        self.administrator = administrator
        self.coordinateFormat = coordinateFormat
        self.deviceLimit = deviceLimit
        self.disabled = disabled
        self.distanceUnit = distanceUnit
        self.expirationTime = expirationTime
        self.latitude = latitude
        self.longitude = longitude
        self.map = map
        self.readonly = readonly
        self.token = token
        self.twelveHourFormat = twelveHourFormat
        self.zoom = zoom
        self.photo = photo
        self.phone = phone
    }
    
}

extension User: Extensible {
    typealias Object = User
}

extension User {
    static func session(email: String, password: String) -> Resource<User> {
        return Resource(endpoint: "session", method: .post, parameters: ["email": email, "password": password], encoding: URLEncoding.httpBody, headers: nil)
    }
}

extension User: CustomStringConvertible {
    var description: String {
        return "\(User.self):\n id: \(String(describing: self.id)),\n name: \(self.name),\n email: \(self.email),\n password: \(String(describing: self.password)),\n attributes: \(String(describing: self.attributes))"
    }
}























