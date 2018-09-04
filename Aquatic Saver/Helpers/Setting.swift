//
//  Setting.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 29.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Foundation

protocol SettingType {
    var key         : String { get }
    var type        : SettingValueType { get }
    
    func getValue() -> Any
    func setValue(_ value: Any)
}

enum SettingValueType: String {
    case string
    case bool
    case int
    case double
    case array
}

class Setting<T: Codable & CustomStringConvertible>: SettingType {
    let key         : String
    let type        : SettingValueType
    var value       : T?
    
    init(key: String, value: T?) {
        self.key = key
        self.value = value
        switch value {
        case is Bool    : self.type = .bool
        case is String  : self.type = .string
        case is Int     : self.type = .int
        case is Double  : self.type = .double
        default         : self.type = .array
        }
    }
    
    func getValue() -> Any {
        return self.value as Any
    }
    
    func setValue(_ value: Any) {
        self.value = value as? T
    }
}

class Settings {
    static var shared: [SettingType] = [
        Setting(key: "Server address", value: "132.197.0.34:8080"),
        Setting(key: "Maximum connections", value: 10),
        Setting(key: "Remember password", value: true),
        Setting(key: "Supported devices", value: ["KVZ-612", "KVZ-302", "KVZ-111"])
    ]
}

extension Array where Element == SettingType {
    func update(_ setting: SettingType?) {
        guard let setting = setting, let index = Settings.shared.index(where: {$0.key == setting.key}) else { return }
        Settings.shared[index] = setting
    }
}

