//
//  Server.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 31.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Alamofire

class Server: Codable {
    var id                  : Int?
    var attributes          : Attributes?
    var bingKey             : String?
    var distanceUnit        : String?
    var forceSettings       : Bool?
    var latitude            : Double?
    var longitude           : Double?
    var map                 : String?
    var mapUrl              : String?
    var readonly            : Bool?
    var registration        : Bool?
    var speedUnit           : String?
    var twelveHourFormat    : Bool?
    var version             : String?
    var zoom                : Int?
    var coordinateFormat    : String?
}

extension Server: Extensible {
    typealias Object = Server
}

extension Server {
    static var serverInfo: Resource<Server> {
        return Resource(endpoint: "server", method: .get)
    }
}
