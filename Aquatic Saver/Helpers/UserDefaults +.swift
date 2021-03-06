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
        case scale
        
        case baseUrl
        case devices
        case language
    }
    
    var email: String? {
        get { return self.value(forKey: Keys.email.rawValue) as? String }
        set { self.set(newValue, forKey: Keys.email.rawValue) }
    }

    var password: String? {
        get { return self.value(forKey: Keys.password.rawValue) as? String }
        set { self.set(newValue, forKey: Keys.password.rawValue) }
    }

    var rememberMe: Bool? {
        get { return self.value(forKey: Keys.rememberMe.rawValue) as? Bool }
        set { self.set(newValue, forKey: Keys.rememberMe.rawValue) }
    }
    
    var scale: Float? {
        get { return self.value(forKey: Keys.scale.rawValue) as? Float }
        set { self.set(newValue, forKey: Keys.scale.rawValue) }
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

// MARK: Settings

extension UserDefaults {
    var baseUrl: String? {
        get { return self.value(forKey: Keys.baseUrl.rawValue) as? String }
        set { self.set(newValue, forKey: Keys.baseUrl.rawValue) }
    }
    
    var devices: [String]? {
        get { return self.value(forKey: Keys.devices.rawValue) as? [String] }
        set { self.set(newValue, forKey: Keys.devices.rawValue) }
    }
    
    var language: ArrayChoice? {
        get {
            guard let json = self.value(forKey: Keys.language.rawValue) as? JSON else { return nil }
            return ArrayChoice(fromJSON: json)
        }
        set { self.set(newValue.toJSON, forKey: Keys.language.rawValue) }
    }
}
