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
    func socketDidReceived(key: SocketObserver.WebSocketObject, json: [JSON])
}

class SocketObserver: NSObject {
    static let `default` = SocketObserver(center: NotificationCenter.default)
    
    let center  : NotificationCenter
    var socket  : WebSocket?
    var observers: [ObjectsObservable] = []

    private init(center: NotificationCenter) {
        self.center = center
        super.init()
    }
    
    deinit {
        self.center.removeObserver(self)
    }

    func register(_ observer: ObjectsObservable) {
        self.observers.append(observer)
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
        case devices, positions
        static let all: [WebSocketObject] = [.devices, .positions]
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
            self.observers.forEach { $0.socketDidReceived(key: objectsKey, json: jsonArray) }
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
