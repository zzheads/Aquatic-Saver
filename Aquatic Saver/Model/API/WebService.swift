//
//  WebService.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 31.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Alamofire
import PromiseKit

final class WebService {
    static let `default` = WebService()
    public var loggedUser  : User?
    public var isLogged     : Bool {
        return !(self.loggedUser == nil)
    }
    private var credential  : URLCredential? {
        guard let user = self.loggedUser?.email, let password = self.loggedUser?.password else { return nil }
        return URLCredential(user: user, password: password, persistence: .forSession)
    }

    private init() {
    }
    
    func fetchObject<T: Codable>(resource: Resource<T>) -> Promise<T> {
        return Promise<T>() { seal in
            if let credential = self.credential {
                resource.request.authenticate(usingCredential: credential)
            }
            resource.request.responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let json = value as? JSON else {
                        seal.reject(AppError.serialization(message: "value: \(value) is not json").error)
                        return
                    }
                    guard let object = T(fromJSON: json) else {
                        seal.reject(AppError.serialization(message: "can't parse \(T.self) from json: \(json)").error)
                        return
                    }
                    seal.fulfill(object)
                    
                case .failure(let error):
                    seal.reject(AppError.api(error: error, response: response).error)
                }
            }
        }
    }
    
    func fetchArray<T: Codable>(resource: Resource<T>) -> Promise<[T]> {
        return Promise<[T]>() { seal in
            if let credential = self.credential {
                resource.request.authenticate(usingCredential: credential)
            }
            resource.request.responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let json = value as? [JSON] else {
                        seal.reject(AppError.serialization(message: "value: \(value) is not json array").error)
                        return
                    }
                    guard let objects = [T](fromJSONArray: json) else {
                        seal.reject(AppError.serialization(message: "can't parse \([T].self) from json array: \(json)").error)
                        return
                    }
                    seal.fulfill(objects)
                    
                case .failure(let error):
                    seal.reject(AppError.api(error: error, response: response).error)
                }
            }
        }
    }
}
