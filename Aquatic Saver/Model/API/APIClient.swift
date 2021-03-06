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
    
    func register(username: String, email: String, password: String) -> Promise<User> {
        return Promise<User>() { resolver in
            self.webService.fetchObject(resource: User.register(username: username, email: email, password: password))
                .done { user in
                    resolver.fulfill(user)
                }
                .catch { resolver.reject($0) }
        }
    }
    
    func delete(id: Int) -> Promise<Device?> {
        return Promise<Device?>() { resolver in
            self.webService.fetchObject(resource: Device.delete(id))
                .done { _ in resolver.fulfill(nil) }
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
    
    func addDevice(imei: String, phone: String, name: String) -> Promise<Device> {
        return Promise<Device>() { resolver in
            self.webService.fetchObject(resource: Device.add(imei: imei, phone: phone, name: name))
                .done { resolver.fulfill($0) }
                .catch { resolver.reject($0) }
        }
    }
    
    func update(device: Device) -> Promise<Device> {
        return Promise<Device>() { resolver in
            guard let resource = Device.update(device) else {
                resolver.reject(AppError.nilResource(message: "Can not update device: \(device)").error)
                return
            }
            self.webService.fetchObject(resource: resource)
                .done { resolver.fulfill($0) }
                .catch { resolver.reject($0) }
        }
    }
    
    func lastPosition() -> Promise<[Position]> {
        return Promise<[Position]>() { resolver in
            self.webService.fetchArray(resource: Position.last)
                .done { resolver.fulfill($0) }
                .catch { resolver.reject($0) }
        }
    }
    
    func allPositions() -> Promise<[Position]> {
        return Promise<[Position]>() { resolver in
            self.webService.fetchArray(resource: Position.all)
                .done { resolver.fulfill($0) }
                .catch { resolver.reject($0) }
        }
    }

    func positionsBy(ids: [Int]) -> Promise<[Position]> {
        return Promise<[Position]>() { resolver in
            self.webService.fetchArray(resource: Position.by(ids: ids))
                .done { resolver.fulfill($0) }
                .catch { resolver.reject($0) }
        }
    }
    
    func lastKnownPositionOf(_ deviceId: Int) -> Promise<Position?> {
        return Promise<Position?>() { resolver in
            self.positionsOf(deviceId)
                .done { resolver.fulfill($0.filter{ $0.latitude != 0 || $0.longitude != 0}.last) }
                .catch { resolver.reject($0) }
        }
    }
    
    func positionsOf(_ deviceId: Int, from: String = "2017-01-01", to: String = "2100-01-01") -> Promise<[Position]> {
        return Promise<[Position]>() { resolver in
            self.webService.fetchArray(resource: Position.ofDevice(deviceId: deviceId, from: from, to: to))
                .done { resolver.fulfill($0) }
                .catch { resolver.reject($0) }
        }
    }
    
    func events(_ deviceIds: [Int], from: String = "2017-01-01", to: String = "2100-01-01") -> Promise<[Event]> {
        return Promise<[Event]>() { resolver in
            self.webService.fetchArray(resource: Event.eventsFor(deviceIds: deviceIds, from: from, to: to))
                .done { resolver.fulfill($0) }
                .catch { resolver.reject($0) }
        }
    }
}
