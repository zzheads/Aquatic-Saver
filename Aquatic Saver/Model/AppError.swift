//
//  AppError.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 31.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Alamofire

public enum AppError: Error {
    static let domain = "Parrot Wings Errors domain"
    
    case notLogged
    case filterStringEmpty
    case badEmail
    case badPassword
    case serialization(message: String)
    case api(error: Error, response: DataResponse<Any>)
    case transaction(message: String)
    case nilResource(message: String)
    
    var title: String {
        var title = ""
        switch self {
        case .notLogged                     : title = "Login error"
        case .filterStringEmpty             : title = "Requesting users error"
        case .badEmail, .badPassword        : title = "Registering user error"
        case .serialization(_)              : title = "Serialization error"
        case .api(_, _)                     : title = "API Error"
        case .transaction(_)                : title = "Transaction error"
        case .nilResource(_)                : title = "Resource is nil"
        }
        return title
    }
    
    var code: Int {
        var code = 400
        switch self {
        case .notLogged                     : code = 401
        case .filterStringEmpty             : code = 400
        case .serialization(_)              : code = 406
        case .api(_, let response)          : if let statusCode = response.response?.statusCode { code = statusCode } else { code = 400 }
        case .transaction(_)                : code = 400
        default                             : code = 400
        }
        return code
    }
    
    var message: String {
        var message = ""
        switch self {
        case .notLogged                     : message = "You must be logged"
        case .filterStringEmpty             : message = "Filter string is empty"
        case .serialization(let msg)        : message = "Serialization error: \(msg)"
        case .api(let error, let response)  : if let data = response.data, let msg = String(data: data, encoding: .utf8) { message = msg } else { message = error.localizedDescription }
        case .transaction(let msg)          : message = "Transaction error: \(msg)"
        case .badEmail                      : message = "Invalid email"
        case .badPassword                   : message = "Password and verify password are not equal"
        case .nilResource(let msg)          : message = "Resource is nil: \(msg)"
        }
        return message
    }
    
    var error: NSError {
        return NSError(domain: AppError.domain, code: self.code, userInfo: [NSLocalizedDescriptionKey: self.message])
    }
}
