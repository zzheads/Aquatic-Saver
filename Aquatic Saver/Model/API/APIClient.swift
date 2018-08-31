//
//  APIClient.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 31.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Alamofire
import PromiseKit

final class APIClient {
    static let `default` = APIClient(WebService.default)
    
    private var webService  : WebService
    
    private init(_ webService: WebService) {
        self.webService = webService
    }
    
    func getServerInfo() -> Promise<Server> {
        return Promise<Server>() { resolver in
            self.webService.fetchObject(resource: Server.serverInfo).done{ resolver.fulfill($0) }.catch{ resolver.reject($0) }
        }
    }
    
    func login(email: String, password: String) -> Promise<User> {
        return Promise<User>() { resolver in
            self.webService.fetchObject(resource: User.session(email: email, password: password))
                .done { user in
                    resolver.fulfill(user)
                    self.webService.loggedUser = user
                    NotificationCenter.default.post(AppNotification.userLogged(user: user).notification)
                }
                .catch { resolver.reject($0) }
        }
    }
    
    func allDevices() -> Promise<[Device]> {
        return Promise<[Device]>() { resolver in
            self.webService.fetchArray(resource: Device.getAll())
                .done { devices in
                    resolver.fulfill(devices)
                    NotificationCenter.default.post(AppNotification.getDevices(devices: devices).notification)
                }
                .catch { resolver.reject($0) }
        }
    }
}
