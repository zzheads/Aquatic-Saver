//
//  Socket.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 13.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Foundation
import Starscream

protocol ObjectsObservable {
    func socketDidReceived(_ devices: [Device])
    func socketDidReceived(_ positions: [Position])
    func socketDidReceived(_ events: [Event])
}

extension ObjectsObservable {
    func socketDidReceived(_ devices: [Device]) {}
    func socketDidReceived(_ positions: [Position]) {}
    func socketDidReceived(_ events: [Event]) {}
}

class SocketObserver: NSObject {
    static let `default` = SocketObserver(center: NotificationCenter.default)
    
    private let center      : NotificationCenter
    private var socket      : WebSocket?
    private var observers   : [ObjectsObservable] = []
    private var errorHandler: ((Error) -> Void)?

    private init(center: NotificationCenter) {
        self.center = center
        super.init()
    }
    
    deinit {
        self.center.removeObserver(self)
    }

    func register(_ observer: ObjectsObservable, errorHandler: ((Error) -> Void)? = nil) {
        self.observers.append(observer)
        self.errorHandler = errorHandler
    }
    
    func start() {
        self.center.addObserver(self, selector: #selector(userLogged(notification:)), name: AppNotification.userLogged(user: User()).name, object: nil)
    }
    
    @objc func userLogged(notification: Notification) {
        let baseURL = URL(string: Server.serverInfo.baseURL)!
        let socketURL = URL(string: Server.serverInfo.baseURL.replacingOccurrences(of: "http", with: "ws") + "socket")!
        guard let cookie = HTTPCookieStorage.shared.cookies(for: baseURL)?.first else { return }
        var request = URLRequest(url: socketURL)
        request.setValue("\(cookie.name)=\(cookie.value)", forHTTPHeaderField: "Cookie")
        self.socket = WebSocket(request: request)
        self.socket?.delegate = self
        self.socket?.connect()
    }
}

extension SocketObserver: WebSocketDelegate {
    enum WebSocketObject: String, Codable {
        case devices, positions, events
        static let all: [WebSocketObject] = [.devices, .positions, .events]
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("WebSocket \(socket) did connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        DispatchQueue.main.async {
            print("WebSocket \(socket) did disconnected, error: \(error?.localizedDescription ?? "")")
            self.socket?.connect()
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("WebSocket \(socket) did received message: \(text)")
        DispatchQueue.main.async {
            guard let json = self.jsonFrom(text), let key = json.keys.first, let jsonArray = json[key] as? [JSON], let objectsKey = WebSocketObject(rawValue: key) else {
                self.center.post(AppNotification.socketUnknown(message: text).notification)
                return
            }
            self.center.post(AppNotification.socketObjects(key: objectsKey, json: jsonArray).notification)
            var isSerializationSuccess = false
            switch objectsKey {
            case .devices   :
                if let devices = [Device](fromJSONArray: jsonArray) {
                    self.observers.forEach { $0.socketDidReceived(devices) }
                    isSerializationSuccess = true
                }
            case .events   :
                if let events = [Event](fromJSONArray: jsonArray) {
                    self.observers.forEach { $0.socketDidReceived(events) }
                    isSerializationSuccess = true
                }
            case .positions   :
                if let positions = [Position](fromJSONArray: jsonArray) {
                    self.observers.forEach { $0.socketDidReceived(positions) }
                    isSerializationSuccess = true
                }
            }
            if !isSerializationSuccess {
                self.errorHandler?(AppError.serialization(message: "Key: \(objectsKey), JSON: \(jsonArray)").error)
            }
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("WebSocket \(socket) did received data: \(data)")
    }
    
    fileprivate func jsonFrom(_ text: String) -> [String: Any]? {
        guard let data = text.data(using: .utf8), let result = try? JSONSerialization.jsonObject(with: data, options: []) as? JSON else { return nil }
        return result
    }
}
