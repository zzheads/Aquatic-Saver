//
//  CommandAttributes.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 02.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Foundation

class CommandAttributes: Attributes {
    var data: String?
    
    init(data: String?) {
        super.init()
        self.data = data
    }
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decodeIfPresent(String.self, forKey: .data)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.data, forKey: .data)
    }
}
