//
//  DeviceAttributes.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 31.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Foundation

class DeviceAttributes: Attributes {
    var sosNumbers: [String]?
    
    enum DeviceAttributesKeys: String, CodingKey {
        case sosNumbers
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DeviceAttributesKeys.self)
        self.sosNumbers = try container.decodeIfPresent([String].self, forKey: .sosNumbers)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DeviceAttributesKeys.self)
        try container.encodeIfPresent(self.sosNumbers, forKey: .sosNumbers)
        try super.encode(to: encoder)
    }
}
