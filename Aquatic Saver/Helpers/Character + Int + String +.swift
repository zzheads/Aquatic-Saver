//
//  Character + Int + String +.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 02.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Foundation

extension Character {
    var asciiValue: Int {
        let s = String(self).unicodeScalars
        return Int(s[s.startIndex].value)
    }
}

extension String {
    var utf16converted: String {
        var result = ""
        self.forEach({result.append($0.asciiValue.hex)})
        return result
    }
}

extension Int {
    var hex: String {
        let hex = String(self, radix: 16, uppercase: true)
        let prefix = String(repeating: "0", count: 4 - hex.count)
        return "\(prefix)\(hex)"
    }
}
