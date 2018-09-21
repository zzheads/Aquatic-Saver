//
//  MapViewController.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 04.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
import Material

class MapViewController: UIElements.ViewController {
    var device      : Device?
    
    lazy var map    : GMSMapView = {
        let latitude = 151.20
        let longitude = -33.86
        let scale = UserDefaults.store?.scale ?? 10.0
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: scale)
        let map = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        map.animate(toZoom: camera.zoom)
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    var marker      : GMSMarker?
        
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnRefresh: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(map)

        NSLayoutConstraint.activate([
            map.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            map.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            map.topAnchor.constraint(equalTo: self.view.topAnchor),
            map.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])

        self.btnPlus.addTarget(self, action: #selector(self.scalePlusPressed(_:)), for: .touchUpInside)
        self.btnMinus.addTarget(self, action: #selector(self.scaleMinusPressed(_:)), for: .touchUpInside)
        self.btnRefresh.addTarget(self, action: #selector(self.updatePressed(_:)), for: .touchUpInside)
        
        self.view.sendSubview(toBack: map)
        SocketObserver.default.register(self) { self.showAlert(title: "Socket observing error:", message: $0.localizedDescription, style: .alert) }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updatePressed()
    }
    
    func update(_ position: Position? = nil) {
        guard let device = self.device, let latitude = position?.latitude, let longitude = position?.longitude else {
            self.updateCamera()
            return
        }
        if self.marker == nil {
            self.marker = device.marker(at: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            self.marker?.map = self.map
        } else {
            device.update(self.marker)
        }
        
        self.marker?.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.updateCamera()
    }
    
    func updateCamera() {
        let position = self.marker?.position ?? CLLocationCoordinate2D(latitude: -33, longitude: 150)
        let updateCamera = GMSCameraUpdate.setTarget(position, zoom: map.camera.zoom)
        map.moveCamera(updateCamera)
    }
}

extension MapViewController {
    @objc fileprivate func scalePlusPressed(_ sender: UIButton) {
        self.map.animate(toZoom: map.camera.zoom + 1.0)
        UserDefaults.store?.scale = map.camera.zoom
    }
    
    @objc fileprivate func scaleMinusPressed(_ sender: UIButton) {
        self.map.animate(toZoom: map.camera.zoom - 1.0)
        UserDefaults.store?.scale = map.camera.zoom
    }
    
    @objc fileprivate func updatePressed(_ sender: UIButton? = nil) {
        guard let deviceId = self.device?.id else { return }
        sender?.isEnabled = false
        APIClient.default.lastKnownPositionOf(deviceId)
            .done { position in
                self.toast(position == nil ? "No position data" : "Position updated", duration: 5.0, color: UIElements.Color.darkBlue)
                self.update(position)
            }
            .catch { self.showAlert(title: "Getting position error", message: $0.localizedDescription, style: .alert) }
            .finally { sender?.isEnabled = true }
    }
}

extension MapViewController: ObjectsObservable {
    func socketDidReceived(_ positions: [Position]) {
        self.update(positions.last)
    }
    
    func socketDidReceived(_ devices: [Device]) {
        self.device = devices.first
        self.updatePressed()
    }
    
    func socketDidReceived(_ events: [Event]) {
        let message = events.compactMap{"\($0.serverTime ?? ""): \($0.description), "}.reduce("", +).dropLast()
        PushNotification(title: "Новые события: ", message: String(message)).push()
    }
}

