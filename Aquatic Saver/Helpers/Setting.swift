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
    enum Keys: String {
        case baseUrl = "Server address"
        case devices = "Supported devices"
        case language = "Language"
    }
    
    static let shared: [String: UserDefaults.Keys] = [Keys.baseUrl.rawValue: .baseUrl, Keys.devices.rawValue: .devices, Keys.language.rawValue: .language]
    
    static let baseUrl = Setting(key: Keys.baseUrl.rawValue, value: UserDefaults.store?.baseUrl ?? "http://62.109.28.53/api/")
    static let devices = Setting(key: Keys.devices.rawValue, value: UserDefaults.store?.devices ?? ["ZX-612", "ZX-302"])
    static let language = Setting(key: Keys.language.rawValue, value: UserDefaults.store?.language ?? ArrayChoice(array: ["Russian", "English"], selected: 0))
    
    static func save() {
        save(baseUrl)
        save(devices)
        save(language)
    }
    
    static func load() {
        load(baseUrl)
        load(devices)
        load(language)
    }
    
    static func save(_ setting: SettingType) {
        guard let key = Settings.shared[setting.key] else { return }
        switch key {
        case .baseUrl   : UserDefaults.store?.baseUrl = setting.getValue() as? String
        case .devices   : UserDefaults.store?.devices = setting.getValue() as? [String]
        case .language  : UserDefaults.store?.language = setting.getValue() as? ArrayChoice
        default         : break
        }
    }
    
    static func load(_ setting: SettingType) {
        guard let key = Settings.shared[setting.key] else { return }
        switch key {
        case .baseUrl   : setting.setValue(UserDefaults.store?.baseUrl as Any)
        case .devices   : setting.setValue(UserDefaults.store?.devices as Any)
        case .language  : setting.setValue(UserDefaults.store?.language as Any)
        default         : break
        }
    }
}

extension Array where Element == SettingType {
    mutating func update(_ setting: SettingType?) {
        guard let setting = setting, let index = self.index(where: {$0.key == setting.key}) else { return }
        self[index] = setting
    }
    
    subscript(index: String) -> Element? {
        get { return self.filter{$0.key == index}.first }
        set { self.filter{$0.key == index}.first?.setValue(newValue?.getValue() as Any) }
    }
}

