//
//  Server.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 31.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Foundation

struct Server: Codable {
    var id                  : Int!
    var attributes          : Attributes!
    var bingKey             : String!
    var distanceUnit        : String!
    var forceSettings       : Bool!
    var latitude            : Double!
    var longitude           : Double!
    var map                 : String!
    var mapUrl              : String!
    var readonly            : Bool!
    var registration        : Bool!
    var speedUnit           : String!
    var twelveHourFormat    : Bool!
    var version             : String!
    var zoom                : Int!
    var coordinateFormat    : String!
}

extension Server: Extensible, Attributable {
    static let emptyInstance = Server()
}

extension Server {
    var resource: URL {
        return URL(string: "http://62.109.28.53/server")!
    }
}
