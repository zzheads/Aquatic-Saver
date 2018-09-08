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
    var device  : Device?
    var map     : GMSMapView?
    var marker  : GMSMarker?
        
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnRefresh: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let map = self.map(nil)
        self.map = map
        self.marker = marker(nil)
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updatePressed()
    }
    
    func map(_ position: Position?) -> GMSMapView {
        let latitude = position?.latitude ?? 151.20
        let longitude = position?.longitude ?? -33.86
        let scale = UserDefaults.store?.scale ?? 10.0
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: scale)
        let map = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        map.animate(toZoom: camera.zoom)
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }
    
    func marker(_ position: Position? = nil) -> GMSMarker {
        let latitude = position?.latitude ?? 151.20
        let longitude = position?.longitude ?? -33.86
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: longitude, longitude: latitude)
        marker.title = self.device?.name
        marker.snippet = self.device?.onMapDescription
        marker.map = self.map
        self.marker = marker
        return marker
    }
    
    func update(_ position: Position? = nil) {
        guard let map = self.map, let marker = self.marker, let latitude = position?.latitude, let longitude = position?.longitude else { return }
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let updateCamera = GMSCameraUpdate.setTarget(marker.position, zoom: map.camera.zoom)
        map.moveCamera(updateCamera)
    }
}

extension MapViewController {
    @objc fileprivate func scalePlusPressed(_ sender: UIButton) {
        guard let map = self.map else { return }
        map.animate(toZoom: map.camera.zoom + 1.0)
        UserDefaults.store?.scale = map.camera.zoom
    }
    
    @objc fileprivate func scaleMinusPressed(_ sender: UIButton) {
        guard let map = self.map else { return }
        map.animate(toZoom: map.camera.zoom - 1.0)
        UserDefaults.store?.scale = map.camera.zoom
    }
    
    @objc fileprivate func updatePressed(_ sender: UIButton? = nil) {
        guard let deviceId = self.device?.id else { return }
        sender?.isEnabled = false
        APIClient.default.lastKnownPositionOf(deviceId)
            .done { self.update($0) }
            .catch { self.showAlert(title: "Getting position error", message: $0.localizedDescription, style: .alert) }
            .finally { sender?.isEnabled = true }
    }
}

