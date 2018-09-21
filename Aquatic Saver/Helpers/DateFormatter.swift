//
//  DateFormatter.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 21.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
}

extension Date {
    var toString: String? {
        let components = Calendar.current.dateComponents(in: TimeZone.current, from: self)
        guard let day = components.day, let month = components.month, let year = components.year, let hour = components.hour, let minute = components.minute else { return nil }
        return String(format: "%02d/%02d/%02d %02d:%02d", day, month, year, hour, minute)
    }
}

extension String {
    var localDate: String {
        guard let date = DateFormatter.full.date(from: self), let result = date.toString else { return self }
        return result
    }
}
