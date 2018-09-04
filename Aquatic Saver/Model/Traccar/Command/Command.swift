//
//  Command.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 02.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Foundation

struct Command: Codable {
    var id          : Int?
    var deviceId    : Int
    var type        : CommandType
    var attributes  : CommandAttributes
    
    init(deviceId: Int = 0, type: CommandType = .custom(.find), attributes: CommandAttributes? = nil) {
        self.deviceId = deviceId
        self.type = type
        guard let attributes = attributes else {
            self.attributes = CommandAttributes(data: Command.data(uniqueId: "", type: type))
            return
        }
        self.attributes = attributes
    }
    
    enum CodingKeys: String, CodingKey {
        case type, deviceId, attributes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(CommandType.self, forKey: .type)
        let deviceId = try container.decode(Int.self, forKey: .deviceId)
        let attributes = try container.decode(CommandAttributes.self, forKey: .attributes)
        self.init(deviceId: deviceId, type: type, attributes: attributes)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.type, forKey: .type)
        try container.encode(self.deviceId, forKey: .deviceId)
        try container.encode(self.attributes, forKey: .attributes)
    }
}

extension Command: Extensible {
    typealias Object = Command
}

extension Command {
    fileprivate static func data(uniqueId: String, type: CommandType) -> String? {
        let hexLength = type.command.count.hex
        return "[SG*\(uniqueId)*\(hexLength)*\(type.command)]"
    }
}
