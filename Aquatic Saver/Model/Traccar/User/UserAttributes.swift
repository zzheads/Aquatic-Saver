//
//  UserAttributes.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 31.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Foundation

class UserAttributes: Attributes {
    var notificationsSettings   : NotificationsSettings?
    
    init(notificationsSettings: NotificationsSettings? = nil) {
        super.init()
        self.notificationsSettings = notificationsSettings
    }
    
    enum CodingKeys: String, CodingKey {
        case notificationsSettings
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.notificationsSettings = try container.decodeIfPresent(NotificationsSettings.self, forKey: .notificationsSettings)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.notificationsSettings, forKey: .notificationsSettings)
    }
}

