//
//  EventAttributes.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 17.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Foundation

enum AlarmType: String, Codable {
    case overspeed
    case lowBattery
    case sos
}

class EventAttributes: Attributes {
    var alarm: AlarmType?
    
    enum CodingKeys: String, CodingKey {
        case alarm
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.alarm = try container.decodeIfPresent(AlarmType.self, forKey: .alarm)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.alarm, forKey: .alarm)
    }
}
