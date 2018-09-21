//
//  DeviceStatus.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 16.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit

enum DeviceStatus: String, Codable {
    case online
    case offline
    case unknown
}

extension Device {
    var markerColor: UIColor {
        let status = self.status ?? .unknown
        var color: UIColor = .clear
        switch status {
        case .online    : color = UIElements.Color.green
        case .offline   : color = UIColor(red: 103/255, green: 163/255, blue: 190/255, alpha: 1.0)
        case .unknown   : color = .gray
        }
        return color
    }
}
