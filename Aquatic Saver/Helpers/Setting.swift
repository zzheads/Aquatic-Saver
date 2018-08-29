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
    var cellType    : SettingCellType { get }
    
    func getValue() -> Any
    func setValue(_ value: Any)
}

enum SettingCellType {
    case string
    case bool
}

class Setting<T: Codable & CustomStringConvertible>: SettingType {
    let key         : String
    var value       : T?
    
    init(key: String, value: T?) {
        self.key = key
        self.value = value
    }
    
    var cellType: SettingCellType {
        switch self.value {
        case is Bool                        : return .bool
        default                             : return .string
        }
    }
    
    func getValue() -> Any {
        return self.value as Any
    }
    
    func setValue(_ value: Any) {
        self.value = value as? T
    }
}

