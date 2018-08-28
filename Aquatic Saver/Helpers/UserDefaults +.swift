//
//  Defaults.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 28.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit
import Material

protocol DefaultsLoadable {
    var emailField          : TextField { get set }
    var passwordField       : TextField { get set }
    var rememberMeButton    : CheckButton { get set }
}

extension UserDefaults {
    static let suiteName = "Aquatic Saver User Defaults"
    static let store = UserDefaults(suiteName: suiteName)
    
    enum Keys: String {
        case email
        case password
        case rememberMe
    }
    
    var email: String? {
        get { return self.value(forKey: Keys.email.rawValue) as? String }
        set { self.setValue(newValue, forKey: Keys.email.rawValue) }
    }

    var password: String? {
        get { return self.value(forKey: Keys.password.rawValue) as? String }
        set { self.setValue(newValue, forKey: Keys.password.rawValue) }
    }

    var rememberMe: Bool? {
        get { return self.value(forKey: Keys.rememberMe.rawValue) as? Bool }
        set { self.setValue(newValue, forKey: Keys.rememberMe.rawValue) }
    }
    
    func load(_ vc: DefaultsLoadable) {
        vc.emailField.text = self.email
        vc.passwordField.text = self.password
        vc.rememberMeButton.isSelected = self.rememberMe ?? false
    }
    
    func save(_ vc: DefaultsLoadable) {
        self.email = vc.emailField.text
        self.password = vc.passwordField.text
        self.rememberMe = vc.rememberMeButton.isSelected
    }
    
    func clear() {
        self.email = nil
        self.password = nil
        self.rememberMe = nil
    }
}
