//
//  EventType.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 17.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Foundation

enum EventType: RawRepresentable, Codable {
    static let all: [EventType] = [.alarm(nil), .alarm(.sos), .alarm(.overspeed), .alarm(.lowBattery), .deviceOnline, .deviceOffline, .deviceStopped, .deviceMoving, .deviceUnknown, .geofenceEnter, .geofenceExit]
    
    case alarm(AlarmType?)
    case deviceOnline
    case deviceOffline
    case deviceStopped
    case deviceMoving
    case deviceUnknown
    case geofenceEnter
    case geofenceExit
    
    var rawValue: String {
        switch self {
        case .alarm(let alarmType)  :
            guard let alarmType = alarmType else {
                return "alarm"
            }
            return "alarm(\(alarmType.rawValue))"
        case .deviceOnline          : return "deviceOnline"
        case .deviceOffline         : return "deviceOffline"
        case .deviceStopped         : return "deviceStopped"
        case .deviceMoving          : return "deviceMoving"
        case .deviceUnknown         : return "deviceUnknown"
        case .geofenceEnter         : return "geofenceEnter"
        case .geofenceExit          : return "geofenceExit"
        }
    }
    
    init?(rawValue: String) {
        guard let found = EventType.all.filter({$0.rawValue == rawValue}).first else {
            return nil
        }
        self = found
    }
    
    var title: String {
        switch self {
        case .alarm(let alarmType)  :
            guard let alarmType = alarmType else {
                return "Предупреждение"
            }
            switch alarmType {
            case .overspeed     : return "Устройство снято с руки"
            case .sos           : return "Устройство просит о помощи"
            case .lowBattery    : return "Низкий заряд батареи устройства"
            }
            
        case .deviceOnline          : return "Устройство появилось в сети"
        case .deviceOffline         : return "Устройство вышло из сети"
        case .deviceStopped         : return "Устройство остановилось"
        case .deviceMoving          : return "Устройство начало движение"
        case .deviceUnknown         : return "Устройство не отвечает"
        case .geofenceEnter         : return "Устройство вошло в геозону"
        case .geofenceExit          : return "Устройство вышло из геозоны"
        }
    }
}

extension Array where Element == EventType {
    var string: String {
        get {
            var result = ""
            for type in self {
                result += "\(type.rawValue), "
            }
            return String(result.dropLast(2))
        }
        set {
            self = []
            for rawValue in newValue.components(separatedBy: ",") {
                if let type = EventType(rawValue: rawValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)) {
                    self.append(type)
                }
            }
        }
    }
}
