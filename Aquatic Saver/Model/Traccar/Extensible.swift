//
//  Extensible.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 31.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Foundation

protocol Extensible: Equatable {
    var id  : Int? { get set }
    static func ==(lhs: Self, rhs: Self) -> Bool
}

extension Extensible {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Sequence where Iterator.Element: Extensible {
    func findBy(id: Int) -> Iterator.Element? {
        guard let found = self.filter({$0.id == id}).first else {
            return nil
        }
        return found
    }
    
    func index(where id: Int) -> Int? {
        var index = 0
        for element in self {
            if (element.id == id) { return index }
            index += 1
        }
        return nil
    }
}
