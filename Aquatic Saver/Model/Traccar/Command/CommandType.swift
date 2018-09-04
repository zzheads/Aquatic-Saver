//
//  CommandType.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 02.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Foundation

typealias PhoneNumber = String

enum CommandType: RawRepresentable, Codable {
    
    enum CustomType: RawRepresentable {
        case pedometer(Bool)
        case sosContacts(Int?, [Contact])
        case favContacts(Int, [Contact])
        case call(PhoneNumber)
        case monitor
        case center(PhoneNumber)
        case reset
        case location
        case poweroff
        case find
        case flower(Int)
        case message(String)
        
        static let all: [CustomType] = [.pedometer(false), .sosContacts(nil, [Contact]()), .favContacts(1, [Contact]()), .call(""), .monitor, .center(""), .reset, .location, .poweroff, .find, .flower(0), .message("")]
        
        var keyword: String {
            switch self {
            case .pedometer(_)                              :   return "PEDO"
            case .favContacts(let number, _)                :   return "PHB\(number > 1 ? "2" : "")"
            case .sosContacts(_)                            :   return "SOS"
            case .call(_)                                   :   return "CALL"
            case .monitor                                   :   return "MONITOR"
            case .center(_)                                 :   return "CENTER"
            case .reset                                     :   return "RESET"
            case .location                                  :   return "CR"
            case .poweroff                                  :   return "POWEROFF"
            case .find                                      :   return "FIND"
            case .flower(_)                                 :   return "FLOWER"
            case .message(_)                                :   return "MESSAGE"
            }
        }
        
        var rawValue: String {
            return self.keyword
        }
        
        init?(rawValue: String) {
            guard let found = CustomType.all.filter({$0.rawValue == rawValue}).first else {
                return nil
            }
            self = found
        }
    }
    
    case custom(CustomType)
    
    static let all: [CommandType] = CustomType.all.map({.custom($0)})
    
    var rawValue: String {
        switch self {
        case .custom(_) :   return "custom"
        }
    }
    
    init?(rawValue: String) {
        guard let found = CommandType.all.filter({$0.rawValue == rawValue}).first else {
            return nil
        }
        self = found
    }
    
    var keyword: String {
        switch self {
        case .custom(let customKey)                     :   return customKey.keyword
        }
    }
    
    private func sos(number: Int?, _ contacts: [Contact]) -> String {
        guard
            let number = number,
            let contact = contacts.first
            else {
                var result = self.keyword
                for contact in contacts {
                    result += ",\(contact.phone)"
                }
                return result
        }
        return "\(self.keyword)\(number),\(contact.phone)"
    }
    
    private func fav(listNumber: Int, _ contacts: [Contact]) -> String {
        var result: String = self.keyword
        for count in 0..<(contacts.count > 5 ? 5 : contacts.count) {
            let contact = contacts[count]
            result += ",\(contact.phone),\(contact.name.utf16converted.uppercased())"
        }
        return result
    }
    
    var command: String {
        switch self {
        case .custom(let customKey)                             :
            switch customKey {
            case .sosContacts(let number, let contacts)             :   return self.sos(number: number, contacts)
            case .favContacts(let listNum, let contacts)            :   return self.fav(listNumber: listNum, contacts)
            case .pedometer(let ped)                                :   return "\(self.keyword),\(ped ? "1" : "0")"
            case .call(let phone)                                   :   return "\(self.keyword),\(phone)"
            case .center(let phone)                                 :   return "\(self.keyword),\(phone)"
            case .monitor, .reset, .location, .poweroff, .find      :   return self.keyword
            case .flower(let number)                                :   return "\(self.keyword),\(number)"
            case .message(let text)                                 :   return "\(self.keyword),\(text.utf16converted)"
            }
        }
    }
}
