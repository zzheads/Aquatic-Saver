//
//  Event.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 17.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Foundation

struct Event: Codable {
    var id          : Int?
    var attributes  : EventAttributes?
    var deviceId    : Int?
    var geofenceId  : Int?
    var positionId  : Int?
    var serverTime  : String?
    var type        : EventType?
    var deviceName  : String?
    
    static func eventsFor(deviceIds: [Int], from: String, to: String) -> Resource<Event> {
        let queryString = deviceIds.compactMap{"deviceId=\($0)&"}.reduce("", +) + "from=\(from)&to=\(to)"
        return Resource<Event>(endpoint: "reports/events?\(queryString)", method: .get)
    }
}

extension Event: Extensible {
}

extension Event: CustomStringConvertible {
    var description: String {
        let deviceName = "\(self.deviceId ?? 0)"
        let geofenceName = "\(self.geofenceId ?? 0)"
        guard let type = self.type else {
            return "Unknown type"
        }
        switch type {
        case .deviceMoving      :   return "Устройство \(deviceName) начало движение"
        case .deviceStopped     :   return "Устройство \(deviceName) остановилось"
        case .deviceOnline      :   return "Устройство \(deviceName) появилось в сети"
        case .deviceOffline     :   return "Устройство \(deviceName) вышло из сети"
        case .deviceUnknown     :   return "Устройство \(deviceName) не отвечает, проверьте баланс и заряд батареи"
        case .geofenceEnter     :   return "Устройство \(deviceName) вошло в геозону \(geofenceName)"
        case .geofenceExit      :   return "Устройство \(deviceName) покинуло геозону \(geofenceName)"
        case .alarm             :
            guard let alarm = self.attributes?.alarm else {
                return "Предупреждение устройства \(deviceName)"
            }
            switch alarm {
            case .overspeed     : return "Устройство \(deviceName) снято с руки"
            case .sos           : return "Устройство просит о помощи!"
            case .lowBattery    :
                guard let battery = self.attributes?.battery else {
                    return "У устройства низкий (??) заряд батареи. Рекомендуется сменить режим трекера на экономный"
                }
                return "У устройства низкий (\(battery)%) заряд батареи. Рекомендуется сменить режим трекера на экономный"
            case .powerCut      : return "Power cut"
            case .shock         : return "Shock"
            }
        }
    }
}

extension Array where Element == Event {
    var deviceIds: [Int] {
        var result = [Int]()
        for event in self {
            if let deviceId = event.deviceId {
                if !result.contains(deviceId) {
                    result.append(deviceId)
                }
            }
        }
        return result
    }
}
