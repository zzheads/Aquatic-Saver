//
//  Translator.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 17.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Foundation

class Translator {
    static let shared = Translator("Strings")!
    
    let dictionary: [String: String]
    var isOn: Bool {
        let translate = Settings.shared["Language"]?.getValue() as? Bool
        return translate ?? false
    }
    
    init?(_ filename: String) {
        guard let path = Bundle.main.path(forResource: filename, ofType: "json") else { return nil }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let strings = try JSONSerialization.jsonObject(with: data)
            guard let dict = strings as? [String: String] else { return nil }
            self.dictionary = dict
        } catch {
            print(error)
            return nil
        }
    }
    
    func translate(_ phrase: String) -> String {
        guard isOn, let translated = self.dictionary[phrase] else { return phrase }
        return translated
    }
    
    func translate(_ phrase: String?) -> String? {
        guard let phrase = phrase else { return nil }
        return translate(phrase)
    }
}
